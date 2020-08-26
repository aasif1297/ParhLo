import 'package:bookapp/model/book.dart';
import 'package:bookapp/provider/book_provider.dart';
import 'package:bookapp/theme/mytext.dart';
import 'package:bookapp/views/book/screen/book_details_screen.dart';
import 'package:bookapp/views/book/screen/singlebooktile.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CategoriesDetailsScreen extends StatefulWidget {
  static const String routeName = "/categories_details";
  final String categoryName;

  CategoriesDetailsScreen({@required this.categoryName});

  @override
  _CategoriesDetailsScreenState createState() =>
      _CategoriesDetailsScreenState();
}

class _CategoriesDetailsScreenState extends State<CategoriesDetailsScreen> {
  bool selectView = false;
  List<BookModel> category;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Provider.of<BookProvider>(context).getBookList().then((_) {});
    category = Provider.of<BookProvider>(context)
        .bookList
        .where((element) => element.category == widget.categoryName)
        .toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bookData = Provider.of<BookProvider>(context);
    final args = ModalRoute.of(context).settings;

    Widget gridCategories() {
      var size = MediaQuery.of(context).size;
      return Expanded(
          child: GridView.builder(
              itemCount: category.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.2,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 4.0,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {},
                    child: BookTile(
                      title: category[index].bookName,
                      imgAssetPath: category[index].imgAssetPath,
                      author: category[index].author,
                      categorie: category[index].category,
                      url: category[index].bookpdfUrl,
                    ));
              }));
    }

    Widget listCategories() {
      var size = MediaQuery.of(context).size;
      return FutureBuilder(
        future: Provider.of<BookProvider>(context).getBookList(),
        builder: (ctx, snapShot) => Expanded(
          child: ListView.builder(
              itemCount: category.length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => BookDetailsScreen(
                              name: category[index].bookName,
                              url: category[index].bookpdfUrl,
                            )));
                  },
                  child: Container(
                      margin: EdgeInsets.only(
                          left: 5, right: 5, top: 10, bottom: 10),
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  category[index].imgAssetPath,
                                  fit: BoxFit.contain,
                                  width: 80,
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  category[index].bookName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    category[index].author,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                );
              }),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          actions: <Widget>[
            InkWell(
                onTap: () {
                  setState(() {
                    selectView = !selectView;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                      selectView
                          ? FontAwesomeIcons.thList
                          : FontAwesomeIcons.list,
                      color: Colors.black),
                ))
          ],
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.categoryName,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  '${category.length.toString()}' + " Books",
                  style: MyText.smallText,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 3, right: 5),
        child: Column(
          children: <Widget>[selectView ? listCategories() : gridCategories()],
        ),
      ),
    );
  }
}
