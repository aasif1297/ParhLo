import 'package:bookapp/model/categories.dart';
import 'package:bookapp/theme/mytext.dart';
import 'package:bookapp/views/categories/screen/categories_detail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChooseInterest extends StatefulWidget {
  static const String routeName = "/choose_interest";
  @override
  _ChooseInterestState createState() => _ChooseInterestState();
}

class _ChooseInterestState extends State<ChooseInterest> {
  bool selectView = false;
  Widget gridCategories(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        children: List.generate(
          categoriesList.length,
          (index) => InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(10),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        categoriesList[index].imgUrl,
                        fit: BoxFit.cover,
                        width: 150,
                        height: 150,
                      )),
                  Positioned(
                    left: size.width * 0.03,
                    top: size.height * 0.06,
                    child: Text(
                      categoriesList[index].name,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Positioned(
                    left: size.width * 0.03,
                    top: size.height * 0.09,
                    child: Text(
                      "${categoriesList[index].itemAvailble.toString()} books",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                  Positioned(
                      left: size.width * 0.2,
                      top: size.height * 0.015,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor: Colors.green,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 10, right: 10, bottom: 5),
                child: Text("Choose Interest", style: MyText.bigHeading),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Which type of book are you interested in?",
                    style: TextStyle(color: Colors.grey[500], fontSize: 18)),
              ),
              gridCategories(context),
              Container(
                margin: EdgeInsets.all(10),
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green),
                child: Center(
                  child: Text(
                    "Done",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
