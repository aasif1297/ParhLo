import 'package:bookapp/provider/user_provider.dart';
import 'package:bookapp/theme/mytext.dart';
import 'package:bookapp/views/book/screen/book_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowData extends StatefulWidget {
  final String page;
  ShowData(this.page);
  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  List<String> myList;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<UserProvider>(context).getUserFavBookList();
    Provider.of<UserProvider>(context).getUserReadBookList();
    Provider.of<UserProvider>(context).getUserViewedBookList();
    Provider.of<UserProvider>(context).getUserDownloadList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.page == 'Favorite') {
      myList = Provider.of<UserProvider>(context).userFavBookList;
    } else if (widget.page == 'Viewed') {
      myList = Provider.of<UserProvider>(context).userViewedBookList;
    } else if (widget.page == 'Have Read') {
      myList = Provider.of<UserProvider>(context).userReadBookList;
    } else if (widget.page == 'Download') {
      myList = Provider.of<UserProvider>(context).userDownloadBookList;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "My ${widget.page} Books",
          style: MyText.headings,
        ),
      ),
      body: Container(
        height: 300,
        child: ListView.builder(
            itemCount: myList.length,
            itemBuilder: (ctx, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) =>
                          BookDetailsScreen(name: myList[index])));
                },
                child: Container(
                    margin: EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            myList[index],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey[300],
                        )
                      ],
                    )),
              );
            }),
      ),
    );
  }
}
