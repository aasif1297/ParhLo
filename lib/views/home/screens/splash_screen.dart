import 'dart:async';
import 'package:bookapp/rootPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), route);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  route() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => RootPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/images/logo.jpeg')),
    );
  }
}

//"Parhlo کتاب",
