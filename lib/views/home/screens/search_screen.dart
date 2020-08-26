import 'package:bookapp/model/book.dart';
import 'package:bookapp/model/categories.dart';
import 'package:bookapp/provider/author_provider.dart';
import 'package:bookapp/provider/book_provider.dart';
import 'package:bookapp/theme/mytext.dart';
import 'package:bookapp/views/author/screen/author_profile.dart';
import 'package:bookapp/views/author/screen/author_screen.dart';
import 'package:bookapp/views/book/screen/book_details_screen.dart';
import 'package:bookapp/views/categories/screen/categories.dart';
import 'package:bookapp/views/categories/screen/categories_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = "/Search_Screen";

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<BookModel> _booklist = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<BookProvider>(context).getBookList();
    _booklist = Provider.of<BookProvider>(context).bookList;
  }

  final globalKey = new GlobalKey<ScaffoldState>();
  TextEditingController _controller = TextEditingController();

  List<SearchData> searchList = new List<SearchData>();

  bool _isSearching;
  String _searchText = '';

  @override
  void initState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
    super.initState();
    _isSearching = false;
  }

  @override
  Widget build(BuildContext context) {
    final authordata = Provider.of<AuthorProvider>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 50,
            margin:
                EdgeInsets.only(top: size.height * 0.05, right: 10, left: 10),
            child: Row(
              children: <Widget>[
                Container(
                  height: 40,
                  width: size.width * 0.94,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      onTap: () {
                        _controller.text = '';
                        searchList.clear();
                      },
                      autofocus: true,
                      onChanged: searchOperation,
                      decoration: InputDecoration(
                        hintText: 'Search Books...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black),
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
          Expanded(
            child: searchList.length != 0 || _controller.text.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchList.length,
                    itemBuilder: (ctx, index) => InkWell(
                          onTap: () {
                            print(searchList[index].profilepic);
                            //print(searchList[index].url);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => BookDetailsScreen(
                                      name: searchList[index].name,
                                      url: searchList[index].url,
                                    )));
                          },
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Container(
                                  width: 60,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
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
                                    errorWidget: (context, url, error) =>
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
                                    imageUrl: searchList[index].profilepic,
                                    width: 1000.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(searchList[index].name.toString()),
                              ),
                              Container(
                                height: 10,
                              ),
                            ],
                          ),
                        ))
                : ListView(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Top Author",
                              style: MyText.headings,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(AuthorScreen.routeName);
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
                            future: Provider.of<AuthorProvider>(context,
                                    listen: false)
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.grey[300],
                                        backgroundImage: NetworkImage(authordata
                                            .authorList[index].imgUrl),
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
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
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
                      Container(
                        height: 370,
                        margin: EdgeInsets.only(left: 10, right: 5, bottom: 10),
                        child: GridView.count(
                          crossAxisCount: 2,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(
                            4,
                            (index) => InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => CategoriesDetailsScreen(
                                          categoryName:
                                              categoriesList[index].name,
                                        )));
                              },
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
                                      top: size.height * 0.14,
                                      child: Text(
                                        categoriesList[index].name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  void searchOperation(String searchText) {
    searchList.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _booklist.length; i++) {
        // yea chla isny list sy name lye phr
        // print(_booklist[i].bookpdfUrl);
        BookModel data = _booklist[i]; //list name data mea store hon gae
        if (data.bookName.toLowerCase().contains(searchText.toLowerCase())) {
          searchList.add(SearchData(
            data.bookName.toString(),
            data.bookName.toString(),
            data.imgAssetPath.toString(),
            data.bookpdfUrl.toString(),
          ));
        } //is mea chechk karrhy hain ky list mea to searchbox sy text arha haon woh mojod ahin ya nahi
        //or new list jo bar bar change hon ge data show hony par osmea add hon jaey ga
      }
    }
  }
}

class SearchData {
  String id;
  String name;
  String url;
  String profilepic;

  SearchData(this.id, this.name, this.profilepic, this.url);
}
