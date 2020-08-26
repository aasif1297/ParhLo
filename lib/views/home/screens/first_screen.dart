import 'package:bookapp/views/home/screens/auth_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  static const String routeName = "/first_screen";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        body: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AuthScreen.routeName);
              },
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.purple)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Login / Signup as User",
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.purple)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Login / Signup as Author",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
