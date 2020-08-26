import 'package:bookapp/theme/mytext.dart';
import 'package:bookapp/views/book/screen/watch_add_screen.dart';
import 'package:bookapp/views/profile_settings/screens/subscription.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UnlockDialog extends StatelessWidget {
  final String bookUrl;
  final String bookNam;

  UnlockDialog(this.bookUrl, this.bookNam);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        height: 190,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Please Unlock Book to Read",
                style: MyText.textBold,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  WatchAddScreen.routeName,
                  arguments: bookUrl,
                );
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
                          FontAwesomeIcons.video,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        "Watch Adds",
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
              onTap: () {
                Navigator.pop(context);
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
