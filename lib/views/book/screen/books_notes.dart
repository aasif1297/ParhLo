import 'package:bookapp/theme/mytext.dart';
import 'package:flutter/material.dart';

class BooksNotes extends StatelessWidget {
  static const String routeName = "/book_notes";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Notes",
          style: MyText.headings,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(),
    );
  }
}
