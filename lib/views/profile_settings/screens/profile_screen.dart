import 'dart:convert';
import 'package:bookapp/provider/user_provider.dart';
import 'package:bookapp/theme/mytext.dart';
import 'package:bookapp/views/book/screen/my_loader.dart';
import 'package:bookapp/views/profile_settings/screens/feedback.dart';
import 'package:bookapp/views/profile_settings/screens/settings/settings_screen.dart';
import 'package:bookapp/views/profile_settings/screens/show_data.dart';
import 'package:bookapp/views/profile_settings/screens/subscription.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:epub_kitty/epub_kitty.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/user_profile.dart';
import '../widgets/tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var id;
  var _init = true;
  var _isLoading = false;
  final viewedBooks = [];
  final readBooks = [];
  final favBooks = [];
  String localPath = '';
  List<String> downloadBook = [];
  static const pageChannel =
      const EventChannel('com.xiaofwang.epub_kitty/page');

  String readingnow = '';

  Future<void> _getList() async {
    final prefs = await SharedPreferences.getInstance();
    downloadBook = prefs.getStringList("downloadBook");

    print('check' + downloadBook.toString());
    // return prefs.getStringList("key");
  }

  Future<void> readingNow() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userBookData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userBookData')) as Map<String, Object>;

    readingnow = extractedUserData['book'];
    localPath = extractedUserData['path'];
    print(extractedUserData['book']);
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<UserProvider>(context).getUser().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    readingNow();
    _getList();
    super.initState();
  }

  Widget intro(BuildContext context, String username, String email,
      String profilrPhoto, String userId) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(UserProfile.routeName);
        Navigator.of(context).pushReplacementNamed(UserProfile.routeName);
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xff330033)),
                        ),
                        width: 60.0,
                        height: 60.0,
                        padding: EdgeInsets.all(70.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Material(
                        child: Image.asset(
                          'assets/images/img_not_available.jpeg',
                          width: 60.0,
                          height: 60.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      ),
                      imageUrl: profilrPhoto,
                      width: 60.0,
                      height: 60.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(username ?? "Name",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(email ?? "Email",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black)),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios)
            ],
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
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Account & Settings",
          style: MyText.headings,
        ),
      ),
      body: _isLoading
          ? Center(child: MyLoader())
          : SingleChildScrollView(
              child: Container(
                  child: Column(
                children: <Widget>[
                  Consumer<UserProvider>(
                      builder: (ctx, profile, _) => intro(
                            context,
                            profile.myProfile.name ?? "Your Name",
                            profile.myProfile.email ?? "Your Email",
                            profile.myProfile.profilePhoto.toString(),
                            profile.myProfile.uid == null
                                ? ""
                                : profile.myProfile.uid.toString(),
                          )),
                  Stack(
                    children: <Widget>[
                      Container(
                          height: 130,
                          width: double.infinity,
                          child: Image.asset(
                            "assets/images/back.png",
                            fit: BoxFit.fill,
                          )),
                      Positioned(
                        top: size.height * 0.035,
                        left: size.width * 0.21,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(SubscriptionScreen.routeName);
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white),
                            child: Center(
                              child: Text(
                                "Subscription Plans",
                                style: TextStyle(
                                    color: Colors.orange, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                      child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if (localPath == '') {
                          } else {
                            String path = localPath;
                            EpubKitty.setConfig(
                                "androidBook", "#06d6a7", "vertical", true);
                            EpubKitty.open(path);

                            pageChannel.receiveBroadcastStream().listen(
                                (Object event) {
                              print('page:$event');
                            }, onError: null);
                          }
                        },
                        child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Icon(
                              FontAwesomeIcons.bookOpen,
                              color: Colors.orange,
                            ),
                          ),
                          title: Text(
                            "Reading now",
                            style: MyText.tileText,
                          ),
                          subtitle: readingnow == ''
                              ? Text('0 Book')
                              : Text("$readingnow"),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          ),
                        ),
                      ),
//favotie
                      Consumer<UserProvider>(
                        builder: (ctx, fav, _) => FutureBuilder(
                          future: Provider.of<UserProvider>(context)
                              .getUserFavBookList(),
                          builder: (ctx, snapSHot) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => ShowData('Favorite')));
                            },
                            child: ListTile(
                              leading: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Icon(
                                  FontAwesomeIcons.heart,
                                  color: Colors.red,
                                ),
                              ),
                              title: Text(
                                "Favourite",
                                style: MyText.tileText,
                              ),
                              subtitle: fav.userFavBookList.length == 0
                                  ? Text('0 Books')
                                  : Text(
                                      "${fav.userFavBookList.length.toString()} Books"),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Consumer<UserProvider>(
                        builder: (ctx, view, _) => FutureBuilder(
                          future: Provider.of<UserProvider>(context)
                              .getUserViewedBookList(),
                          builder: (ctx, snapshot) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => ShowData('Viewed')));
                            },
                            child: ListTile(
                              leading: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Icon(
                                  FontAwesomeIcons.clock,
                                  color: Colors.purple,
                                ),
                              ),
                              title: Text(
                                "Viewed",
                                style: MyText.tileText,
                              ),
                              subtitle: view.userViewedBookList.length == 0
                                  ? Text('0 Books')
                                  : Text(
                                      "${view.userViewedBookList.length.toString()} Books"),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
//viewed
//download
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => ShowData('Download')));
                        },
                        child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Icon(
                              FontAwesomeIcons.download,
                              color: Colors.redAccent,
                            ),
                          ),
                          title: Text(
                            "Download",
                            style: MyText.tileText,
                          ),
                          subtitle: downloadBook == null
                              ? Text('0 Books')
                              : Text("${downloadBook.length.toString()} books"),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      //have read
                      Consumer<UserProvider>(
                        builder: (ctx, read, _) => FutureBuilder(
                          future: Provider.of<UserProvider>(context)
                              .getUserReadBookList(),
                          builder: (ctx, snap) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => ShowData('Have Read')));
                            },
                            child: ListTile(
                              leading: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Icon(
                                  FontAwesomeIcons.check,
                                  color: Colors.orange,
                                ),
                              ),
                              title: Text(
                                "Have Read",
                                style: MyText.tileText,
                              ),
                              subtitle: read.userReadBookList.length == 0
                                  ? Text('0 Books')
                                  : Text(
                                      "${read.userReadBookList.length.toString()} books"),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),

                      //request for boook
                      Container(
                        height: 15,
                        color: Colors.grey[200],
                      ),
                      CustomTile(
                        name: "Request for Book",
                        icon: Icons.font_download,
                        iconColor: Colors.black,
                        onTap: () {
                          // Navigator.of(context).pushNamed(AddBook.routeName);
                        },
                      ),
                      Container(
                        height: 15,
                        color: Colors.grey[200],
                      ),
                      CustomTile(
                        name: "Feedback",
                        icon: FontAwesomeIcons.comment,
                        iconColor: Colors.purpleAccent,
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(FeedbackScreen.routeName);
                        },
                      ),

                      CustomTile(
                        name: "Settings",
                        icon: Icons.settings,
                        iconColor: Colors.red,
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(SettingsScreen.routeName);
                        },
                      ),
                    ],
                  ))
                ],
              )),
            ),
    );
  }
}
