import 'package:bookapp/model/categories.dart';
import 'package:bookapp/provider/author_provider.dart';
import 'package:bookapp/provider/book_provider.dart';
import 'package:bookapp/provider/categories_provider.dart';
import 'package:bookapp/theme/mytext.dart';
import 'package:bookapp/views/author/screen/author_profile.dart';
import 'package:bookapp/views/author/screen/author_screen.dart';
import 'package:bookapp/views/book/screen/singlebooktile.dart';
import 'package:bookapp/views/categories/screen/categories_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    final bookData = Provider.of<BookProvider>(context);
    final authordata = Provider.of<AuthorProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          "Explore",
          style: MyText.headings,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          // margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.only(
              //       top: 8.0, left: 8.0, right: 8.0, bottom: 20),
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.of(context).pushNamed(ChooseInterest.routeName);
              //     },
              //     child: Row(
              //       children: <Widget>[
              //         Padding(
              //           padding: const EdgeInsets.only(right: 8.0),
              //           child: Text(
              //             "My Interest",
              //             style: MyText.headings,
              //           ),
              //         ),
              //         Icon(Icons.arrow_forward_ios, color: Colors.black)
              //       ],
              //     ),
              //   ),
              // ),
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Authors",
                      style: MyText.headings,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(AuthorScreen.routeName);
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
                  height: 150,
                  margin: EdgeInsets.only(right: 10, top: 10),
                  child: FutureBuilder(
                    future: Provider.of<AuthorProvider>(context, listen: false)
                        .getAuthorList(),
                    builder: (ctx, snapshot) => ListView.builder(
                      itemCount: authordata.authorList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) => InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => AuthorProfile(
                                  authordata.authorList[index].name)));
                        },
                        child: Container(
                          // padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: NetworkImage(
                                    authordata.authorList[index].imgUrl),
                              ),
                              Container(
                                width: 90,
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  authordata.authorList[index].name,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
              Consumer<CategoryProvider>(
                builder: (ctx, category, _) => Container(
                    height: 370,
                    margin: EdgeInsets.only(
                        left: 10, right: 5, top: 10, bottom: 10),
                    child: FutureBuilder(
                        future: Provider.of<CategoryProvider>(context,
                                listen: false)
                            .getCategoryList()
                            .then((value) => {}),
                        builder: (ctx, snapshot) {
                          return category.categoriesList == null
                              ? CircularProgressIndicator()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: category.categoriesList.length,
                                  itemBuilder: (ctx, index) {
                                    return _listWidget(bookData,
                                        category.categoriesList, index);
                                  });
                        })),
              ),
              // Container(
              //   padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       Text(
              //         "Islamic",
              //         style: MyText.headings,
              //       ),
              //       InkWell(
              //         onTap: () {
              //           Navigator.of(context).push(MaterialPageRoute(
              //               builder: (ctx) => CategoriesDetailsScreen(
              //                     categoryName: "Islamic",
              //                   )));
              //         },
              //         child: Text(
              //           "View All",
              //           style: MyText.simpleText,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.only(left: 2, top: 10, bottom: 10),
              //   height: 250,
              //   child: FutureBuilder(
              //       future: Provider.of<BookProvider>(context).getBookList(),
              //       builder: (ctx, snapShot) => ListView.builder(
              //           itemCount: bookData.islamic.length,
              //           scrollDirection: Axis.horizontal,
              //           shrinkWrap: true,
              //           physics: ClampingScrollPhysics(),
              //           itemBuilder: (context, index) {
              //             return BookTile(
              //               title: bookData.islamic[index].bookName,
              //               categorie: bookData.islamic[index].category,
              //               imgAssetPath: bookData.islamic[index].imgAssetPath,
              //               author: bookData.islamic[index].author,
              //               url: bookData.islamic[index].bookpdfUrl,
              //             );
              //           })),
              // ),
              // Container(
              //   padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       Text(
              //         "Self Help",
              //         style: MyText.headings,
              //       ),
              //       InkWell(
              //         onTap: () {
              //           Navigator.of(context).push(MaterialPageRoute(
              //               builder: (ctx) => CategoriesDetailsScreen(
              //                   categoryName: "Self Help")));
              //         },
              //         child: Text(
              //           "View All",
              //           style: MyText.simpleText,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.only(left: 2, top: 10, bottom: 10),
              //   height: 250,
              //   child: FutureBuilder(
              //       future: Provider.of<BookProvider>(context).getBookList(),
              //       builder: (ctx, snapShot) => ListView.builder(
              //           itemCount: bookData.selfHelp.length,
              //           scrollDirection: Axis.horizontal,
              //           shrinkWrap: true,
              //           physics: ClampingScrollPhysics(),
              //           itemBuilder: (context, index) {
              //             return BookTile(
              //               title: bookData.selfHelp[index].bookName,
              //               categorie: bookData.selfHelp[index].category,
              //               imgAssetPath: bookData.selfHelp[index].imgAssetPath,
              //               author: bookData.selfHelp[index].author,
              //               url: bookData.selfHelp[index].bookpdfUrl,
              //             );
              //           })),
              // ),
              // Container(
              //   padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       Text(
              //         "Politics",
              //         style: MyText.headings,
              //       ),
              //       InkWell(
              //         onTap: () {
              //           Navigator.of(context).push(MaterialPageRoute(
              //               builder: (ctx) => CategoriesDetailsScreen(
              //                     categoryName: "Politics",
              //                   )));
              //         },
              //         child: Text(
              //           "View All",
              //           style: MyText.simpleText,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.only(left: 2, top: 10, bottom: 10),
              //   height: 250,
              //   child: FutureBuilder(
              //       future: Provider.of<BookProvider>(context).getBookList(),
              //       builder: (ctx, snapShot) => ListView.builder(
              //           itemCount: bookData.politics.length,
              //           scrollDirection: Axis.horizontal,
              //           shrinkWrap: true,
              //           physics: ClampingScrollPhysics(),
              //           itemBuilder: (context, index) {
              //             return BookTile(
              //               title: bookData.politics[index].bookName,
              //               categorie: bookData.politics[index].category,
              //               imgAssetPath: bookData.politics[index].imgAssetPath,
              //               author: bookData.politics[index].author,
              //               url: bookData.politics[index].bookpdfUrl,
              //             );
              //           })),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listWidget(
      BookProvider bookData, List<Categories> categoriesList, int index) {
    return SizedBox(
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "${categoriesList[index].name}",
                  style: MyText.headings,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => CategoriesDetailsScreen(
                              categoryName: "${categoriesList[index].name}",
                            )));
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
            margin: EdgeInsets.only(left: 2, top: 10, bottom: 10),
            height: 250,
            child: FutureBuilder(
                future: Provider.of<BookProvider>(context).getBookList(),
                builder: (ctx, snapShot) => ListView.builder(
                    itemCount: bookData
                        .getBooksFromCategory(
                            bookData.bookList, categoriesList[index].name)
                        .length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return BookTile(
                        title: bookData
                            .getBooksFromCategory(bookData.bookList,
                                categoriesList[index].name)[index]
                            .bookName,
                        categorie: bookData
                            .getBooksFromCategory(bookData.bookList,
                                categoriesList[index].name)[index]
                            .category,
                        imgAssetPath: bookData
                            .getBooksFromCategory(bookData.bookList,
                                categoriesList[index].name)[index]
                            .imgAssetPath,
                        author: bookData
                            .getBooksFromCategory(bookData.bookList,
                                categoriesList[index].name)[index]
                            .author,
                        url: bookData
                            .getBooksFromCategory(bookData.bookList,
                                categoriesList[index].name)[index]
                            .bookpdfUrl,
                      );
                    })),
          ),
        ],
      ),
    );
  }
}
