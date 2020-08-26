import 'dart:async';
import 'dart:io';
import 'package:bookapp/views/book/screen/books_notes.dart';
import 'package:bookapp/views/book/screen/my_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class BookViewerPage extends StatefulWidget {
  final String url;
  BookViewerPage({@required this.url});
  @override
  _BookViewerPageState createState() => _BookViewerPageState();
}

class _BookViewerPageState extends State<BookViewerPage>
    with WidgetsBindingObserver {
  String localPath;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  bool nightMode = false;

  Future<File> getFileFromUrl(String url, {name}) async {
    var fileName = 'testonline';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/" + fileName + ".pdf");
      print(dir.path);
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  Future _changeMode() {
    setState(() {
      nightMode = !nightMode;
    });
  }

  @override
  void initState() {
    super.initState();
    getFileFromUrl(widget.url).then((f) {
      setState(() {
        localPath = f.path;
        print(localPath);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: nightMode ? Colors.white : Colors.black),
        backgroundColor: nightMode ? Colors.black : Colors.white,
        elevation: 0,
        title: Text(
          '${currentPage.toString()}\/$pages',
          style: TextStyle(color: nightMode ? Colors.white : Colors.black),
        ),
      ),
      body: localPath != null
          ? Stack(
              children: <Widget>[
                PDFView(
                  nightMode: nightMode,
                  filePath: localPath,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  autoSpacing: true,
                  pageFling: true,
                  defaultPage: currentPage,
                  fitEachPage: true,
                  fitPolicy: FitPolicy.BOTH,
                  onRender: (_pages) {
                    setState(() {
                      pages = _pages;
                      isReady = true;
                    });
                  },
                  onError: (error) {
                    setState(() {
                      errorMessage = error.toString();
                    });
                    print(error.toString());
                  },
                  onPageError: (page, error) {
                    setState(() {
                      errorMessage = '$page: ${error.toString()}';
                    });
                    print('$page: ${error.toString()}');
                  },
                  onViewCreated: (PDFViewController pdfViewController) {
                    _controller.complete(pdfViewController);
                  },
                  onPageChanged: (int page, int total) {
                    print('page change: $page/$total');
                    setState(() {
                      currentPage = page;
                    });
                  },
                ),
                errorMessage.isEmpty
                    ? !isReady
                        ? Center(
                            child: MyLoader(),
                          )
                        : Container()
                    : Center(
                        child: Text(errorMessage),
                      )
              ],
            )
          : Center(child: MyLoader()),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                      onTap: () async {
                        await snapshot.data.setPage(currentPage + 1);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Icon(
                          Icons.last_page,
                          size: 35,
                        ),
                      )),
                  InkWell(
                      onTap: () async {
                        await _changeMode();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Icon(FontAwesomeIcons.moon),
                      )),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(BooksNotes.routeName);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Icon(FontAwesomeIcons.file),
                      )),
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
