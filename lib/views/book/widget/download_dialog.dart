import 'package:bookapp/theme/mytext.dart';
import 'package:bookapp/views/profile_settings/screens/subscription.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DownloadDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: 190,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 35.0, bottom: 25, left: 15, right: 15),
              child: Text(
                "This feature is only for premium user",
                style: MyText.textBold,
              ),
            ),
            // InkWell(
            //   onTap: () {},
            //   child: Container(
            //     width: 220,
            //     margin: EdgeInsets.all(10),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         border: Border.all(width: 1, color: Colors.purple)),
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Row(
            //         children: <Widget>[
            //           Padding(
            //             padding: const EdgeInsets.only(left: 8.0, right: 16),
            //             child: Icon(
            //               FontAwesomeIcons.video,
            //               color: Colors.purple,
            //             ),
            //           ),
            //           Text(
            //             "Watch Adds",
            //             style: TextStyle(
            //                 color: Colors.purple,
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.bold),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(SubscriptionScreen.routeName);
              },
              child: Container(
                width: 220,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.purple)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 16),
                        child: Icon(
                          FontAwesomeIcons.buysellads,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        "Subscription Plans",
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
          ],
        ),
      ),
    );
  }
}
