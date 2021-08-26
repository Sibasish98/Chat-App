import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import "package:fluuter_androidstudio_project/main.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp extends StatelessWidget {
  String username = "";
  String msg = "";
  MyApp(String uname) {
    username = uname;
  }
  var controllerr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Container(
                color: Colors.indigo,
                child: Column(children: [
                  Expanded(
                      child:
                          Container(/*height: 150,*/ child: stFull(username))),
                  Container(
                    color: Colors.white,
                    child: Row(children: [
                      Container(width: 272, child: inputt()),
                      FlatButton(
                          onPressed: () {
                            controllerr.clear();
                            sendMessage(msg);
                          },
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.orange,
                            size: 30,
                          ))
                    ]),
                    alignment: Alignment.bottomCenter,
                  )
                ]))));
  }

  Widget inputt() {
    return TextField(
        controller: controllerr,
        decoration: InputDecoration(
          hintText: "Enter Message Here",
          border: OutlineInputBorder(),
        ),
        onChanged: (strr) => msg = strr,
        onSubmitted: (str) {
          controllerr.clear();
          sendMessage(str);
        });
  }

  Future<void> sendMessage(String msg) {
    CollectionReference users =
        FirebaseFirestore.instance.collection("Messages");
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'message': msg, // John Doe
          'user': username,
          'createdAt': FieldValue.serverTimestamp()
        })
        .then((value) => print("Message Added" + username))
        .catchError((error) => print("Failed to add message: $error"));
  }
}

class stFull extends StatefulWidget {
  String username = "";
  stFull(String uname) {
    username = uname;
  }
  @override
  MyWidget createState() => MyWidget(username);
}

class MyWidget extends State<stFull> {
  String username = "";
  MyWidget(String uname) {
    username = uname;
  }
  static MyWidget instancee = new MyWidget("xyz");
  var s = "ttxtt";
  var messages = [];
  static void set(str) {
    instancee.setState(() {
      instancee.s = "xyz";
      instancee.messages.add(str);
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream = FirebaseFirestore
      .instance
      .collection('Messages')
      .orderBy('createdAt', descending: false)
      .limitToLast(25)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    MyWidget.instancee = this;
    /*_usersStream = FirebaseFirestore.instance
        .collection('Messages')
        .orderBy('createdAt', descending: true)
        .limit(5)
        .snapshots();*/
    var l = [];
    return StreamBuilder<QuerySnapshot>(
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

            int n = username == data['user'] ? 0 : 1;

            return messageBox(n, data['message']);
          }).toList(),
        );
      },
    );

    /*messages.length != 0
        ? ListView.builder(
            itemCount: messages.length,
            itemBuilder: (c, i) {
              return messageBox(i);
            },
          )
        : Text(" ");*/
  }

  Widget messageBox(n, str) {
    return Container(
        alignment: n % 2 == 0 ? Alignment.centerRight : Alignment.centerLeft,
        child: msg(str));
  }

  Widget msg(str) {
    return Container(
      /* width: 300,*/
      constraints: BoxConstraints(maxWidth: 300),
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Text(str, style: TextStyle(color: Colors.white)),
    );
  }

  void test() {
    //test code
    print("Hello");

    setState(() {
      s = "SS";
      messages.add("testing");
    });
  }
}
