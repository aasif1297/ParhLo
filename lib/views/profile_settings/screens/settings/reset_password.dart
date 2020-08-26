import 'package:bookapp/views/home/screens/home_screen.dart';
import 'package:bookapp/views/tab_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final email = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Reset Password',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                autofocus: true,
                controller: email,
                decoration: InputDecoration(hintText: 'john@gmail.com'),
              ),
            ),
            RaisedButton(
              onPressed: () {
                if (email.text.isNotEmpty) {
                  auth.sendPasswordResetEmail(email: email.text);
                  Fluttertoast.showToast(
                    msg: "Password reset link has been sent to your email",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => TabScreen()),
                      ModalRoute.withName("/"));
                } else {
                  Fluttertoast.showToast(
                    msg: "Please enter an email",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                }
              },
              child: Text('Reset Password'),
            )
          ],
        ),
      ),
    );
  }
}
