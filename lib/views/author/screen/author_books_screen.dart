import 'package:bookapp/model/book.dart';
import 'package:bookapp/provider/book_provider.dart';
import 'package:bookapp/theme/mytext.dart';
import 'package:bookapp/views/book/screen/singlebooktile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorBooks extends StatefulWidget {
  final String authorName;
  final int items;

  AuthorBooks({@required this.authorName, @required this.items});
  static const String routeName = "/author_books";

  @override
  _AuthorBooksState createState() => _AuthorBooksState();
}

class _AuthorBooksState extends State<AuthorBooks> {
  List<BookModel> authorBooksList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<BookProvider>(context).getBookList().then((_) {});
    authorBooksList = Provider.of<BookProvider>(context)
        .bookList
        .where((element) => element.author == widget.authorName)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Widget gridBooks(BuildContext context) {
      return Expanded(
          child: GridView.builder(
              itemCount: authorBooksList.length,
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
                      title: authorBooksList[index].bookName,
                      imgAssetPath: authorBooksList[index].imgAssetPath,
                      author: authorBooksList[index].author,
                      categorie: authorBooksList[index].category,
                      url: authorBooksList[index].bookpdfUrl,
                    ));
              }));
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
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
                widget.authorName,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  authorBooksList.length.toString() + " Books",
                  style: MyText.smallText,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
          margin: EdgeInsets.only(left: 5),
          child: Column(
            children: <Widget>[
              gridBooks(context),
            ],
          )),
    );
  }
}
