import 'package:bookapp/model/user_data_model.dart';
import 'package:bookapp/theme/mytext.dart';
import 'package:bookapp/views/book/screen/pdf_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WatchAddScreen extends StatefulWidget {
  static const String routeName = "/watch_add_screen";
  final String bookName;
  WatchAddScreen({@required this.bookName});

  @override
  _WatchAddScreenState createState() => _WatchAddScreenState();
}

const String testDevices = '65CB13B827D619F511105ABB74149FB0';

class _WatchAddScreenState extends State<WatchAddScreen> {
  String networkPathPDF = "";
  bool loading = false;
  String ad1 = "ad1";
  String ad2 = "";
  String ad3 = "";
  String unlockBook = "";
  String fileUrl = "";
  RewardedVideoAd videoAd = RewardedVideoAd.instance;
  RewardedVideoAdEvent event;
  RewardedVideoAdEvent event1;
  RewardedVideoAdEvent event2;
  int coins = 0;
  List uidList = List();

  @override
  initState() {
    super.initState();
    getUidList();

    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    print(uidList);
    videoAd.load(
        adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo);
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent listen, {String rewardType, int rewardAmount}) {
      print("REWARDED VIDEO AD $listen");
      if (ad1 == 'ad1') {
        setState(() {
          event = listen;
        });
      }
      if (ad2 == 'ad2') {
        setState(() {
          event1 = listen;
        });
      }
      if (ad3 == 'ad3') {
        setState(() {
          event2 = listen;
        });
      }
      if (listen == RewardedVideoAdEvent.rewarded) {
        setState(() {
          coins += rewardAmount;
        });
      }
    };
  }

  getUidList() async {
    await Firestore.instance
        .collection('Books')
        .document(UserSingle.userData.bookName)
        .get()
        .then((value) {
      setState(() {
        uidList = List.from(value.data["unblocked"]);
        fileUrl = value.data['bookpdfUrl'];
      });
    });
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevices != null ? <String>[] : null,
    keywords: <String>['Book', 'Game'],
    nonPersonalizedAds: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Watch Adds",
          style: MyText.headings,
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      ad2 = "ad2";
                      loading = true;
                    });
                    loadVideoAdd();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.purple)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 16),
                            child: Icon(
                              FontAwesomeIcons.video,
                              color: Colors.purple,
                            ),
                          ),
                          Text(
                            event == RewardedVideoAdEvent.loaded
                                ? "Show Ad 1"
                                : "Watch Ad 1",
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: ad2 == "ad2"
                      ? () {
                          setState(() {
                            ad3 = "ad3";
                            loading = true;
                          });
                          loadVideoAdd();
                        }
                      : null,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1,
                            color: ad2 == "ad2" ? Colors.purple : Colors.grey)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 16),
                            child: Icon(
                              FontAwesomeIcons.video,
                              color: ad2 == "ad2" ? Colors.purple : Colors.grey,
                            ),
                          ),
                          Text(
                            event1 == RewardedVideoAdEvent.loaded
                                ? "Show Ad 2"
                                : "Watch Ad 2",
                            style: TextStyle(
                                color:
                                    ad2 == "ad2" ? Colors.purple : Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: ad3 == "ad3"
                      ? () {
                          setState(() {
                            loading = true;
                          });
                          loadVideoAdd();
                        }
                      : null,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1,
                            color: ad3 == "ad3" ? Colors.purple : Colors.grey)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 16),
                            child: Icon(
                              FontAwesomeIcons.video,
                              color: ad3 == "ad3" ? Colors.purple : Colors.grey,
                            ),
                          ),
                          Text(
                            event2 == RewardedVideoAdEvent.loaded
                                ? "Show Ad 3"
                                : "Watch Ad 3",
                            style: TextStyle(
                                color:
                                    ad3 == "ad3" ? Colors.purple : Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: unlockBook == "unlockBook"
                      ? () {
                          unblockBook();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookViewerPage(
                                        url: fileUrl,
                                      )));
                        }
                      : null,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 1,
                            color: unlockBook == "unlockBook"
                                ? Colors.purple
                                : Colors.grey)),
                    child: Center(
                      child: Text(
                        "Start Reading",
                        style: TextStyle(
                            color: unlockBook == "unlockBook"
                                ? Colors.purple
                                : Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loadVideoAdd() async {
    setState(() {
      loading = true;
    });
    try {
      await videoAd.load(
          adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo);
      print(
          "---------------------------$event--------------------------------");
      if (event == RewardedVideoAdEvent.loaded ||
          event1 == RewardedVideoAdEvent.loaded ||
          event2 == RewardedVideoAdEvent.loaded) {
        setState(() {
          loading = false;
        });
        await videoAd.show();

        setState(() {
          loading = false;
          if (ad1 == 'ad1') {
            ad1 = null;
            event = null;
          }
          if (ad2 == 'ad2') {
            ad1 = null;
          }
          if (ad3 == 'ad3') {
            ad1 = null;
            unlockBook = 'unlockBook';
          }
        });
      }
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
        msg: "Video is not loaded yet",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
      );
      print(e.message);
    }
  }

  unblockBook() {
    print(UserSingle.userData.bookName);
    print(UserSingle.userData.id);
    print(fileUrl);
    if (uidList.contains(UserSingle.userData.id)) {
    } else {
      uidList.add(UserSingle.userData.id);
    }
    print(uidList);
    Firestore.instance
        .collection("Books")
        .document(UserSingle.userData.bookName)
        .updateData({
      'unblocked': uidList,
    });
  }
}
