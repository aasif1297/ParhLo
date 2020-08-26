import 'package:bookapp/theme/theme_color.dart';
import 'package:bookapp/views/explore/screens/explore_screen.dart';
import 'package:bookapp/views/home/screens/home_screen.dart';
import 'package:bookapp/views/profile_settings/screens/profile_screen.dart';

import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabScreen extends StatefulWidget {
  static const String routeName = "/tab_screen";

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int currentPage = 1;
  final _pageOptions = [
    ExploreScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Are you sure you want to exit?',style: TextStyle(fontSize: 17),),
                actions: <Widget>[
                  FlatButton(
                    child: Text('No',style: TextStyle(color: Colors.purple),),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('Yes, exit',style: TextStyle(color: Colors.purple),),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            });

        return value == true;
      },
      child: Scaffold(
        body: _pageOptions[currentPage],
        bottomNavigationBar: FancyBottomNavigation(
          initialSelection: 1,
          circleColor: ThemeColors.color3,
          inactiveIconColor: Colors.black,
          tabs: [
            TabData(iconData: Icons.explore, title: "Explore"),
            TabData(iconData: FontAwesomeIcons.bookReader, title: "Home"),
            TabData(iconData: FontAwesomeIcons.user, title: "Profile")
          ],
          onTabChangedListener: (int position) {
            setState(() {
              currentPage = position;
            });
          },
        ),
      ),
    );
  }
}
