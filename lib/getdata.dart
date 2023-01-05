import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/updata.dart';
import 'package:flutter/material.dart';

class Getdata extends StatefulWidget {
  @override
  State<Getdata> createState() => _GetdataState();
}

class _GetdataState extends State<Getdata> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View data"),leading: IconButton(onPressed: () {
          
        }, icon: Icon(Icons.logout))),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {

            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['full_name']),
                subtitle: Text(data['contatc']),
                trailing: Wrap(
                  children: [
                    IconButton(
                        onPressed: () {
                          users
                              .doc(document.id)
                              .delete()
                              .then((value) => print("User Deleted"))
                              .catchError((error) => print("Failed to delete user: $error"));
                        },
                        icon: Icon(Icons.delete_forever)),
                    IconButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return Updata(document);
                      },));
                    }, icon: Icon(Icons.edit)),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      
    );
  }
}
