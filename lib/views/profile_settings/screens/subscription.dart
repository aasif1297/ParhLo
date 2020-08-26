import 'package:bookapp/provider/user_provider.dart';
import 'package:bookapp/theme/mytext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionScreen extends StatefulWidget {
  static const String routeName = "/subscription";

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String selectedPackage = "";
  String subscribe;

  Future<void> getSubscribed() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    await Firestore.instance
        .collection("users")
        .document(uid)
        .get()
        .then((value) {
      subscribe = value.data['subscribed'];
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final subscribe = Provider.of<UserProvider>(context).subscribe;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: FutureBuilder(
          future: Provider.of<UserProvider>(context).getSubscribed(),
          builder: (ctx, snapShot) => subscribe == "Unsubscribed"
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, left: 10, right: 10, bottom: 5),
                            child:
                                Text("Subscription", style: MyText.bigHeading),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                                "Get unllimited solve of reading books and audiobooks at ant time whenever you are with online or offline access",
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 18)),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedPackage = "Monthly";
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(10),
                              height: 90,
                              decoration: BoxDecoration(
                                  color: selectedPackage == "Monthly"
                                      ? Color.fromRGBO(241, 231, 254, 1)
                                      : Colors.white,
                                  border: Border.all(
                                      width: 2,
                                      color: selectedPackage == "Monthly"
                                          ? Colors.purple
                                          : Colors.grey[300]),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 20, left: 10, right: 10),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Text("Monthly")),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.yellow,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 8),
                                                child: Text(
                                                  "Popular",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text("500 PKR"),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 13,
                                      backgroundColor:
                                          selectedPackage == "Monthly"
                                              ? Colors.green
                                              : Colors.grey[200],
                                      child: selectedPackage == "Monthly"
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            )
                                          : Container(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),

                          //second

                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedPackage = "Annual";
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              height: 90,
                              decoration: BoxDecoration(
                                  color: selectedPackage == "Annual"
                                      ? Color.fromRGBO(241, 231, 254, 1)
                                      : Colors.white,
                                  border: Border.all(
                                      width: 2,
                                      color: selectedPackage == "Annual"
                                          ? Colors.purple
                                          : Colors.grey[300]),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 20, left: 10, right: 10),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Text("Annual")),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0, right: 8),
                                                child: Text(
                                                  "Best Value",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text("5000 PKR"),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 13,
                                      backgroundColor:
                                          selectedPackage == "Annual"
                                              ? Colors.green
                                              : Colors.grey[200],
                                      child: selectedPackage == "Annual"
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            )
                                          : Container(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ])),
                    InkWell(
                      onTap: () {
                        if (selectedPackage == "Monthly") {
                          Provider.of<UserProvider>(context, listen: false)
                              .updateSubscribed("Monthly");
                        } else {
                          Provider.of<UserProvider>(context, listen: false)
                              .updateSubscribed("Annual");
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(154, 18, 179, 1)),
                        child: Center(
                          child: Text(
                            "Proceed",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(child: Text("You are our Premium User")),
        ));
  }
}
