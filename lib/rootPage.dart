import 'package:bookapp/model/user_data_model.dart';
import 'package:bookapp/views/home/screens/auth_screen.dart';
import 'package:bookapp/views/tab_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int login;
  FirebaseUser user;

  initState() {
    super.initState();
    setup();
  }

  setup() async {
    FirebaseAuth.instance.onAuthStateChanged.listen((u) {
      if (u == null) {
        //notsigned in yet
        setState(() {
          user = u;
          login = 1;
        });
      } else {
        //signed in and we have a user
        setState(() {
          user = u;
          UserSingle.userData.id = u.uid;
          login = 2;
        });
        print(u.uid);
      }
    });
    await FirebaseAuth.instance.currentUser();
  }

  /* getCurrentUser() async {
    try {
    final  user = await FirebaseAuth.instance.currentUser();
    FirebaseAuth.instance.onAuthStateChanged;
      
      .then((onValue) {
        if (onValue.uid == null) {
          setState(() {
            login = 1;
            print('${onValue.uid} no online');
          });
        } else if (onValue.uid != null) {
          id = onValue.uid;
          print(
              '------------------------${onValue.uid}  online---------------------------------');
          setState(() {
            login = 2;
            UserSingle.userData.id = onValue.uid;
          });
          print('+++++++++++++++++++++++this is my stored uid' +
              UserSingle.userData.id +
              "+++++++++++++++++++++");
        }
        return onValue.uid;
      });
    } catch (e) {
      print(e);
      setState(() {
        login = 1;
      });
      print("pppaaaaaa");
    }
  }
 */
  /*  @override
  void initState() {
    super.initState();
    try {
      getCurrentUser();
    } catch (e) {
      print(e);
    }
  } */

  @override
  Widget build(BuildContext context) {
    if (login == 0) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          ));
    } else if (login == 2) {
      return TabScreen();
    } else {
      return AuthScreen();
    }
  }
}
