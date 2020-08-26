import 'package:bookapp/model/book.dart';
import 'package:bookapp/provider/author_provider.dart';
import 'package:bookapp/provider/book_provider.dart';
import 'package:bookapp/theme/mytext.dart';
import 'package:bookapp/theme/theme_color.dart';
import 'package:bookapp/views/author/screen/author_books_screen.dart';
import 'package:bookapp/views/book/screen/my_loader.dart';
import 'package:bookapp/views/book/screen/singlebooktile.dart';
import 'package:bookapp/views/book/widget/expandible_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthorProfile extends StatefulWidget {
  final String authorName;
  static const String routeName = "/author_profile";
  AuthorProfile(this.authorName);
  @override
  _AuthorProfileState createState() => _AuthorProfileState();
}

class _AuthorProfileState extends State<AuthorProfile> {
  var _isLoading = false;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
  }

  Widget genres(String text) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1, color: Colors.purple)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
              color: Colors.purple, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget profilePic(BuildContext context, String image) {
    var size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 10),
        height: 130,
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
            child: Image.network(
              image,
              height: 121,
              width: 121,
              fit: BoxFit.cover,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authorData = Provider.of<AuthorProvider>(context);

    final bookData = Provider.of<BookProvider>(context);
    return FutureBuilder(
      future: Provider.of<AuthorProvider>(context)
          .getAuthorDetails(widget.authorName)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      }),
      builder: (ctx, snapshot) => Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: _isLoading
            ? Center(
                child: MyLoader(),
              )
            : SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      profilePic(
                        context,
                        authorData.authorDesc.imgUrl.toString(),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            authorData.authorDesc.name.toString(),
                            style: MyText.headings,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        height: 2,
                        width: double.infinity,
                        color: ThemeColors.colorGrey,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Genres",
                                style: MyText.headings,
                              ),
                            ),
                            Container(
                              height: 50,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      authorData.authorDesc.genres.length,
                                  itemBuilder: (ctx, index) => genres(
                                      authorData.authorDesc.genres[index])),
                            ),
                            // Row(
                            //   children: <Widget>[
                            //     genres("Self Help"),
                            //     genres("Motivation"),
                            //     genres("Money")
                            //   ],
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "About",
                                style: MyText.headings,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: .0, bottom: 8, left: 8, right: 8),
                              child: ExpandableText(
                                authorData.authorDesc.about.toString(),
                                trimLines: 5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Books",
                                    style: MyText.headings,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) => AuthorBooks(
                                                  authorName: authorData
                                                      .authorDesc.name,
                                                  items: 6)));
                                    },
                                    child: Text(
                                      "View All",
                                      style: MyText.simpleText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 2, top: 10, bottom: 10),
                              height: 250,
                              child: FutureBuilder(
                                  future: Provider.of<BookProvider>(context)
                                      .getBookList(),
                                  builder: (ctx, snapShot) => ListView.builder(
                                      itemCount: authorBooksList.length,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return BookTile(
                                          title:
                                              authorBooksList[index].bookName,
                                          categorie:
                                              authorBooksList[index].category,
                                          imgAssetPath: authorBooksList[index]
                                              .imgAssetPath,
                                          author: authorBooksList[index].author,
                                          url:
                                              authorBooksList[index].bookpdfUrl,
                                        );
                                      })),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
