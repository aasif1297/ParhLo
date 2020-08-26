import 'package:bookapp/theme/mytext.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomTile extends StatelessWidget {
  IconData icon;
  Color iconColor;
  String name;
  Function onTap;

  CustomTile({this.name, this.icon, this.iconColor, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor,
        ),
        title: Text(
          name,
          style: MyText.tileText,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
        ),
      ),
    );
  }
}
