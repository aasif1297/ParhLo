import 'dart:convert';
import 'dart:io';
import 'package:bookapp/model/user_data_model.dart';
import 'package:bookapp/provider/book_provider.dart';
import 'package:bookapp/theme/mytext.dart';
import 'package:bookapp/views/book/screen/my_loader.dart';
import 'package:bookapp/views/book/screen/pdf_view.dart';
import 'package:bookapp/views/book/widget/expandible_text.dart';
import 'package:bookapp/views/book/widget/unlock_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:epub_kitty/epub_kitty.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookDetailsScreen extends StatefulWidget {
  static const String routeName = "/book_detail_screen";
  final String name;
  final String url;

  BookDetailsScreen({this.name, this.url});

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  bool isfavourite = false;
  String fav = '';
  static final Firestore firestore = Firestore.instance;
  String subscribe;
  var _init = true;
  var _isLoading = false;
  int views;
  List<String> bookView = ["safwans"];
  bool downloading = false;
  var progressString = "";
  List<String> downloadBook = List<String>();
  List<String> shared = [];
  String localPath;
  File savedDir;
  bool hasExisted = false;
  static const pageChannel =
      const EventChannel('com.xiaofwang.epub_kitty/page');
  List uidList;

//getting user book favorite

  Future<void> getBookFav(String bookName) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    await Firestore.instance
        .collection("users")
        .document(uid)
        .collection("FavoriteBooks")
        .document(bookName)
        .get()
        .then((value) {
      if (value.exists) {
        fav = value.data['book'] ?? '';
      } else {}
    });
  }

  //gettind subscribed fromo firebase
  Future<void> getSubscribed() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    await firestore.collection("users").document(uid).get().then((value) {
      subscribe = value.data['subscribed'];
    });
  }

  //adding views to firebase

  Future<void> addViews() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    firestore
        .collection("users")
        .document(uid)
        .collection("ViewedBook")
        .document(widget.name)
        .setData({"book": widget.name});
  }

  Future<void> addReads() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    firestore
        .collection("users")
        .document(uid)
        .collection("ReadBook")
        .document(widget.name)
        .setData({"book": widget.name});
  }

//getting user views
  Future<void> getViews() async {
    await firestore
        .collection("Books")
        .document(widget.name)
        .get()
        .then((value) {
      views = value.data['views'];

      if (bookView.length == 0) {
        addViews();
        views++;
      } else {
        views;
      }

      print(views);
    });
  }

//checking if book is already exsist in device or not
  Future<void> fileExsist() async {
    var dir = await getApplicationDocumentsDirectory();
    localPath = "${dir.path}/${widget.name}.epub";

    savedDir = File(localPath);
    hasExisted = await savedDir.exists();

    if (hasExisted) {
      print(localPath);
    }
  }

  Future<void> getList() async {
    final prefs = await SharedPreferences.getInstance();
    downloadBook = prefs.getStringList("downloadBook");

    print('check' + downloadBook.toString());
    // return prefs.getStringList("key");
  }

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    getList();
    getUidList();
    UserSingle.userData.bookName = widget.name;
    //checking if book is already exsist in device or not
    fileExsist();

    //getting subscribed users
    getSubscribed();
    // addViews().then((_) {});

    Future.delayed(Duration(seconds: 5), () {
      getViews().then((value) => firestore
          .collection("Books")
          .document(widget.name)
          .updateData({'views': views.toInt()}));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<BookProvider>(context, listen: false)
        .getUserViewedBooks()
        .then((_) {
      bookView = Provider.of<BookProvider>(context, listen: false)
          .bookViewed
          .where((element) => element == widget.name)
          .toList();
    });
  }

  getUidList() async {
    await Firestore.instance
        .collection('Books')
        .document(widget.name)
        .get()
        .then((value) {
      setState(() {
        if (uidList == null) {
          uidList = List.from(value.data["unblocked"]);
        } else if (!uidList.contains(UserSingle.userData.id)) {
          uidList = List.from(value.data["unblocked"]);
        }
      });
    });
    // print(uidList);
  }

  @override
  void dispose() {
    super.dispose();
    uidList = [];
  }

  @override
  Widget build(BuildContext context) {
    final singleBookData = Provider.of<BookProvider>(context);

    //  int downloads;
    // int readers;

//Downloading book file from url

    /*  Future<void> downloadFile() async {
      if (downloadBook == null) {
        shared.add(widget.name);
        final prefs = await SharedPreferences.getInstance();
        prefs.setStringList("downloadBook", shared);

        print('safwan' + shared.toString());
      } else {
        downloadBook.add(widget.name);
        final prefs = await SharedPreferences.getInstance();
        prefs.setStringList("downloadBook", downloadBook);

        print('check' + downloadBook.toString());
      }

      Dio dio = Dio();

      try {
        setState(() {
          downloading = true;
        });

        showDialog(
          context: context,
          builder: (ctx) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
                height: 190,
                child: Center(
                  child: CircularProgressIndicator(),
                )),
          ),
        );
        print(singleBookData.bookModel.bookpdfUrl);
        var download = dio.download(
          singleBookData.bookModel.bookpdfUrl,
          localPath,
        );
        await download;
        print(localPath);
      } catch (e) {
        print(e);
      }

      setState(() {
        downloading = false;
        Navigator.pop(context);
        progressString = "Completed";
      });
      print("Download completed");
    }
 */
//getting downloding user
    /*   Future<void> getDownload() async {
      await firestore
          .collection("Books")
          .document(widget.name)
          .get()
          .then((value) {
        downloads = value.data['downloads'];

        downloads++;
      });
    } */

    Future<void> openBook() async {
      int readers;

      addReads();
      await firestore
          .collection("Books")
          .document(widget.name)
          .get()
          .then((value) {
        readers = value.data['readers'];

        readers++;
      });

      await firestore
          .collection("Books")
          .document(widget.name)
          .updateData({'readers': readers.toInt()}).then((_) {});

      String path = localPath;
      EpubKitty.setConfig("androidBook", "#06d6a7", "vertical", true);
      EpubKitty.open(path);

      pageChannel.receiveBroadcastStream().listen((Object event) {
        print('page:$event');
      }, onError: null);

      final prefs = await SharedPreferences.getInstance();
      final userBookData = json.encode(
        {
          'book': widget.name,
          'path': localPath,
          //because it is date
        },
      );

      prefs.setString('userBookData', userBookData);

      print('check' + userBookData.toString());
    }

    return FutureBuilder(
      future: Provider.of<BookProvider>(context)
          .getBookDetails(widget.name)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      }),
      builder: (ctx, snapShot) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          actions: <Widget>[
            Row(
              children: <Widget>[
                /* hasExisted
                    ? Container()
                    : InkWell(
                        onTap: () {
                          getUidList();
                          if (!uidList.contains(UserSingle.userData.id)) {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return UnlockDialog(
                                      singleBookData.bookModel.bookpdfUrl,
                                      widget.name);
                                }).then((_) {});
                          } else {
                            downloadFile().then((_) {
                              getDownload().then((value) => firestore
                                  .collection("Books")
                                  .document(widget.name)
                                  .updateData(
                                      {'downloads': downloads.toInt()}));

                              Navigator.of(context).pop();
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 3, right: 3, bottom: 8),
                          child: Icon(FontAwesomeIcons.download),
                        )),
                SizedBox(width: 15), */
                InkWell(
                    onTap: () async {
                      share(context, widget.name);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 3, right: 3, bottom: 8),
                      child: Icon(FontAwesomeIcons.shareAlt),
                    )),
                SizedBox(width: 10),
              ],
            )
          ],
        ),
        body: _isLoading
            ? Center(
                child: MyLoader(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 350,
                                width: double.infinity,
                                child: singleBookData.bookModel.imgAssetPath ==
                                        null
                                    ? Container()
                                    : CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            Container(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Color(0xff330033)),
                                          ),
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
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                        ),
                                        imageUrl: singleBookData
                                            .singelbookModel.imgAssetPath,
                                        fit: BoxFit.contain,
                                      ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 8),
                                child: Text(
                                    singleBookData.singelbookModel.bookName,
                                    style: MyText.bigHeading),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 10,
                                      child: Image.asset(
                                          "assets/images/avator.png"),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(singleBookData.singelbookModel.author,
                                        style: MyText.greyText),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.eye,
                                    size: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: Text(
                                        singleBookData.singelbookModel.views
                                            .toString(),
                                        style: MyText.textBold),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(right: 8),
                                      height: 15,
                                      width: 2,
                                      color: Colors.grey),
                                  Icon(
                                    FontAwesomeIcons.bookReader,
                                    size: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: Text(
                                        singleBookData.singelbookModel.readers
                                            .toString(),
                                        style: MyText.textBold),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(right: 8),
                                      height: 15,
                                      width: 2,
                                      color: Colors.grey),
                                  Icon(
                                    FontAwesomeIcons.download,
                                    size: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8),
                                    child: Text(
                                        singleBookData.singelbookModel.downloads
                                            .toString(),
                                        style: MyText.textBold),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15.0, bottom: 8),
                                child: Text("Description"),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: .0, bottom: 8),
                                child: ExpandableText(
                                  singleBookData.singelbookModel.description
                                      .toString(),
                                  trimLines: 5,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          hasExisted
                              ? openBook().then((_) {})

                              //checking wheather user is subscired or not
                              : (!uidList.contains(UserSingle.userData.id))
                                  ? showDialog(
                                      context: context,
                                      child: UnlockDialog(
                                          singleBookData.bookModel.bookpdfUrl,
                                          widget.name))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (contex) => BookViewerPage(
                                                url: widget.url,
                                              )));
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.75,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.purple,
                                Colors.purple,
                                Colors.pink,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: hasExisted
                                ? Text(
                                    "Read Book",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )
                                : Text(
                                    !uidList.contains(UserSingle.userData.id)
                                        ? "Unlock Book"
                                        : "Read Book",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                          ),
                        ),
                      ),
                      FutureBuilder(
                          future: getBookFav(widget.name),
                          builder: (ctx, snapshot) {
                            getUidList();
                            return InkWell(
                              onTap: fav == ''
                                  ? () {
                                      setState(() {
                                        fav = widget.name;
                                      });

                                      Provider.of<BookProvider>(context,
                                              listen: false)
                                          .addBookFavorite(widget.name);
                                    }
                                  : () {
                                      setState(() {
                                        fav = '';
                                      });
                                      Provider.of<BookProvider>(context,
                                              listen: false)
                                          .deleteFavorite(widget.name);

                                      setState(() {});
                                    },
                              child: Container(
                                margin: EdgeInsets.all(10),
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.12,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.purple,
                                      Colors.purple,
                                      Colors.pink,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Icon(
                                    fav == ''
                                        ? Icons.favorite_border
                                        : Icons.favorite,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  share(BuildContext context, String bookName) {
    final RenderBox box = context.findRenderObject();

    Share.share(
        "I am reading Book bookName - Parhlo Book App \nDownload app from Play Store\n",
        subject: 'Parhlo Book App',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
