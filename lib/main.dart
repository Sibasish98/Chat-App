import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'loggedIn.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LogIn());
  //runApp(MyApp("test@abcd.com"));
}

class login extends StatefulWidget {
  @override
  rest createState() {
    return rest();
  }
}

class LogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: login(),
    );
  }
}

class rest extends State<login> {
  String email = " ", password = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lets Chat"),
        ),
        body: Container(
          color: Colors.black12,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              emaill(),
              passwordd(),
              signInBtn(),
            ],
          ),
        ));
  }

  OutlineInputBorder styleInputt() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
    );
  }

  Widget emaill() {
    return Container(
        padding: EdgeInsets.only(bottom: 10),
        width: 250,
        child: TextField(
            onChanged: (value) {
              this.setState(() {
                email = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Username",
              enabledBorder: styleInputt(),
            )));
  }

  Widget passwordd() {
    return Container(
        padding: EdgeInsets.only(bottom: 14),
        width: 250,
        child: TextField(
            onChanged: (value) {
              this.setState(() {
                password = value;
              });
            },
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              enabledBorder: styleInputt(),
            )));
  }

  Widget signInBtn() {
    return Container(
        alignment: Alignment.center,
        child: RaisedButton(child: Text("Log In"), onPressed: loginPressed));
  }

  Future<void> loginPressed() async {
    UserCredential uc = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    proceed();
  }

  void proceed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp(email)),
    );
  }
}
