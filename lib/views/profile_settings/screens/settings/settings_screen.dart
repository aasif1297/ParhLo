import 'package:bookapp/provider/auth_provider.dart';
import 'package:bookapp/theme/mytext.dart';
import 'package:bookapp/views/home/screens/auth_screen.dart';
import 'package:bookapp/views/profile_settings/screens/settings/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = "/settings";

  @override
  Widget build(BuildContext context) {
    Widget tile(String name, Function onTap) {
      return InkWell(
        onTap: onTap,
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(name, style: MyText.headings),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
              ),
              Container(
                  margin: EdgeInsets.only(left: 13, right: 13),
                  height: 1,
                  color: Colors.grey[300])
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Setting",
          style: MyText.headings,
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  tile("Notifications", () {}),
                  tile("Reset Password", () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResetPassword()));
                  }),
                  tile("Rate us", () {}),
                  tile("About", () {}),
                  InkWell(
                    onTap: () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .checkIdProviderAndLogout()
                          .then((_) => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthScreen()),
                              ModalRoute.withName("/")));
                    },
                    child: Container(
                      margin:
                          EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                      height: 50,
                      width: double.infinity,
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
                child: Column(
              children: <Widget>[
                Text(
                  "Version 1.0.0",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.purple)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Software Update",
                      style: TextStyle(
                          color: Colors.purple,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
