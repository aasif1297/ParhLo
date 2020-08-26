import 'package:bookapp/provider/author_provider.dart';
import 'package:bookapp/provider/book_provider.dart';
import 'package:bookapp/provider/categories_provider.dart';
import 'package:bookapp/theme/mytext.dart';
import 'package:bookapp/theme/theme_color.dart';
import 'package:bookapp/views/author/screen/author_profile.dart';
import 'package:bookapp/views/author/screen/author_screen.dart';
import 'package:bookapp/views/book/screen/book_details_screen.dart';
import 'package:bookapp/views/book/screen/singlebooktile.dart';
import 'package:bookapp/views/categories/screen/categories.dart';
import 'package:bookapp/views/categories/screen/categories_detail.dart';
import 'package:bookapp/views/home/screens/search_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isloading = false;
  var _init = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final bookData = Provider.of<BookProvider>(context);
    final authordata = Provider.of<AuthorProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Parhlo کتاب",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: ThemeColors.color2,
        elevation: 10,
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(SearchScreen.routeName);
                },
                icon: Icon(
                  FontAwesomeIcons.search,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.bell,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: CarouselSlider(
                  options: CarouselOptions(
                      height: 300.0,
                      initialPage: 0,
                      enlargeCenterPage: true,
                      // autoPlay: false,
                      reverse: false,
                      enableInfiniteScroll: false,
                      // autoPlayInterval: Duration(seconds: 2),
                      // autoPlayAnimationDuration: Duration(milliseconds: 2000),
                      pauseAutoPlayOnTouch: true,
                      scrollDirection: Axis.horizontal,
                      aspectRatio: 2.0),
                  items: bookData.bookList
                      .map((item) => InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => BookDetailsScreen(
                                        name: item.bookName,
                                        url: item.bookpdfUrl,
                                      )));
                            },
                            child: Container(
                              child: Container(
                                  margin: EdgeInsets.all(5),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Stack(
                                        children: <Widget>[
                                          CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                Container(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Color(0xff330033)),
                                              ),
                                              width: 1000,
                                              padding: EdgeInsets.all(70.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0),
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Material(
                                              child: Image.asset(
                                                'assets/images/img_not_available.jpeg',
                                                width: 1000.0,
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8.0),
                                              ),
                                              clipBehavior: Clip.hardEdge,
                                            ),
                                            imageUrl: item.imgAssetPath,
                                            width: 1000.0,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            bottom: 0.0,
                                            left: 0.0,
                                            right: 0.0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color.fromARGB(
                                                        200, 0, 0, 0),
                                                    Color.fromARGB(0, 0, 0, 0)
                                                  ],
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                ),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 20.0),
                                              child: Text(
                                                item.bookName,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))),
                            ),
                          ))
                      .toList(),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                child: Text(
                  "Recently Added",
                  style: MyText.headings,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 2, top: 10, bottom: 10),
                height: 250,
                // width: 100,
                child: FutureBuilder(
                    future: Provider.of<BookProvider>(context).getBookList(),
                    builder: (ctx, snapShot) {
                      //  print(MediaQuery.of(context).size.width / 3);
                      return ListView.builder(
                          itemCount: bookData.bookList.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return BookTile(
                              title: bookData.bookList[index].bookName,
                              categorie: bookData.bookList[index].category,
                              imgAssetPath:
                                  bookData.bookList[index].imgAssetPath,
                              author: bookData.bookList[index].author,
                              url: bookData.bookList[index].bookpdfUrl,
                            );
                          });
                    }),
              ),
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Popular Author",
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
                        .getAuthorList()
                        .then((_) {}),
                    builder: (ctx, snapshot) => ListView.builder(
                      itemCount: authordata.authorList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) => authordata
                                      .authorList[index].name ==
                                  null ||
                              authordata.authorList[index].imgUrl == null
                          ? Text('Nothing Found')
                          : InkWell(
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
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Categories",
                      style: MyText.headings,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(CategoriesScreen.routeName);
                      },
                      child: Text(
                        "View All",
                        style: MyText.simpleText,
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<CategoryProvider>(
                builder: (ctx, category, _) => Container(
                  height: 370,
                  margin:
                      EdgeInsets.only(left: 10, right: 5, top: 10, bottom: 10),
                  child: FutureBuilder(
                      //initialData: [],
                      future:
                          Provider.of<CategoryProvider>(context, listen: false)
                              .getCategoryList()
                              .then((_) {}),
                      builder: (ctx, snapshot) {
                        return category.categoriesList == null
                            ? CircularProgressIndicator()
                            : GridView.builder(
                                gridDelegate:
                                    new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: category.categoriesList.length,
                                itemBuilder: (ctx, index) => InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                CategoriesDetailsScreen(
                                                  categoryName: category
                                                      .categoriesList[index]
                                                      .name,
                                                )));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Stack(
                                      children: <Widget>[
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              category
                                                  .categoriesList[index].imgUrl,
                                              fit: BoxFit.cover,
                                              width: 150,
                                              height: 150,
                                            )),
                                        Positioned(
                                          left: size.width * 0.03,
                                          top: size.height * 0.11,
                                          child: Container(
                                            width: 150,
                                            child: Text(
                                              category
                                                  .categoriesList[index].name,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
