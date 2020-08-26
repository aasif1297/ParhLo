import 'package:bookapp/model/author.dart';
import 'package:bookapp/provider/author_provider.dart';
import 'package:bookapp/views/author/screen/author_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:side_header_list_view/side_header_list_view.dart';

class AuthorScreen extends StatefulWidget {
  static const String routeName = "/author_Screen";

  @override
  _AuthorScreenState createState() => _AuthorScreenState();
}

class _AuthorScreenState extends State<AuthorScreen> {
  // List<Author> authorList;
  List<Author> _authList = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Provider.of<AuthorProvider>(context).getAuthorList();
    _authList = Provider.of<AuthorProvider>(context).authorList;
  }

  final globalKey = new GlobalKey<ScaffoldState>();
  TextEditingController _controller = TextEditingController();

  List<SearchData> searchList = new List<SearchData>();

  bool _isSearching;
  String _searchText = '';

  @override
  void initState() {
    // TODO: implement initState

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
    // values();
    // _list = Provider.of<User>(context).userList;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final authorList = Provider.of<AuthorProvider>(context).authorList;
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
                      onTap: () {
                        _controller.text = '';
                        searchList.clear();
                      },
                      autofocus: true,
                      onChanged: searchOperation,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        // contentPadding: EdgeInsets.only(left: 10, top: 0),
                        hintText: 'Search Author',
                        // enabledBorder: UnderlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.grey),
                        // ),
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.black),
                        labelStyle: TextStyle(color: Colors.black),
                        // suffixIcon: InkWell(
                        //   onTap: () {},
                        //   child: Icon(
                        //     Icons.close,
                        //     color: Colors.black,
                        //   ),
                        // ),
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
          SizedBox(
            height: 10,
          ),
          searchList.length != 0 || _controller.text.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchList.length,
                      itemBuilder: (ctx, index) => InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) =>
                                      AuthorProfile(searchList[index].name)));
                            },
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Container(
                                    width: 60,
                                    child: ClipOval(
                                      child: Image.network(
                                        searchList[index].profilepic.toString(),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  title:
                                      Text(searchList[index].name.toString()),
                                ),
                                Container(
                                  height: 10,
                                ),
                              ],
                            ),
                          )),
                )
              : FutureBuilder(
                  future: Provider.of<AuthorProvider>(context).getAuthorList(),
                  builder: (ctx, snapshot) => Expanded(
                    child: new SideHeaderListView(
                      itemCount: authorList.length,
                      padding: new EdgeInsets.all(16.0),
                      itemExtend: 60.0,
                      headerBuilder: (BuildContext context, int index) {
                        return new SizedBox(
                            width: 32.0,
                            child: new Text(
                              authorList[index].name.substring(0, 1),
                              style: Theme.of(context).textTheme.headline,
                            ));
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    AuthorProfile(authorList[index].name)));
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey[300],
                              backgroundImage:
                                  NetworkImage(authorList[index].imgUrl),
                            ),
                            title: Text(authorList[index].name,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18)),
                          ),
                        );
                      },
                      hasSameHeader: (int a, int b) {
                        return authorList[a].name.substring(0, 1) ==
                            authorList[b].name.substring(0, 1);
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void searchOperation(String searchText) {
    searchList.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _authList.length; i++) {
        // yea chla isny list sy name lye phr
        Author data = _authList[i]; //list name data mea store hon gae
        if (data.name.toLowerCase().contains(searchText.toLowerCase())) {
          searchList.add(SearchData(data.name.toString(), data.name.toString(),
              data.imgUrl.toString()));
        } //is mea chechk karrhy hain ky list mea to searchbox sy text arha haon woh mojod ahin ya nahi
        //or new list jo bar bar change hon ge data show hony par osmea add hon jaey ga
      }
    }
  }
}

class SearchData {
  String id;
  String name;
  String profilepic;

  SearchData(this.id, this.name, this.profilepic);
}

const names = const <String>[
  'Annie',
  'Arianne',
  'Bertie',
  'Bettina',
  'Bradly',
  'Caridad',
  'Carline',
  'Cassie',
  'Chloe',
  'Christin',
  'Clotilde',
  'Dahlia',
  'Dana',
  'Dane',
  'Darline',
  'Deena',
  'Delphia',
  'Donny',
  'Echo',
  'Else',
  'Ernesto',
  'Fidel',
  'Gayla',
  'Grayce',
  'Henriette',
  'Hermila',
  'Hugo',
  'Irina',
  'Ivette',
  'Jeremiah',
  'Jerica',
  'Joan',
  'Johnna',
  'Jonah',
  'Joseph',
  'Junie',
  'Linwood',
  'Lore',
  'Louis',
  'Merry',
  'Minna',
  'Mitsue',
  'Napoleon',
  'Paris',
  'Ryan',
  'Salina',
  'Shantae',
  'Sonia',
  'Taisha',
  'Zula',
];
