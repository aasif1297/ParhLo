import 'dart:math';
import 'package:bookapp/model/book.dart';
import 'package:bookapp/provider/book_provider.dart';
import 'package:bookapp/theme/mytext.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';

class AddBook extends StatefulWidget {
  static const String routeName = "/add_book";

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  var _categories = ['Islamic', 'Adveture', 'Politcs', 'Self Help'];
  var _selectedCategories = 'Islamic';
  File _image;
  String _uploadedFileURL = '';

  File _bookPdf;
  String _bookURL = '';

  String email = '';
  String bookfileName = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });

    print(_image.path);
  }

  //  final mainReference = FirebaseDatabase.instance.reference().child('Database');
  Future getPdfAndUpload() async {
    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
    }
    await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['pdf'])
        .then((pdf) {
      setState(() {
        _bookPdf = pdf;
      });
    });

    bookfileName = bookNamecontroller.text.isEmpty
        ? '$randomName.pdf'
        : '${bookNamecontroller.text.toString()}.pdf';
    print(bookfileName);
    print('${_bookPdf.readAsBytesSync()}');
    savePdf(_bookPdf.readAsBytesSync(), bookfileName);
  }

  Future savePdf(List<int> asset, String name) async {
    StorageReference reference =
        FirebaseStorage.instance.ref().child('Books/pdf/$name');
    StorageUploadTask uploadTask = reference.putData(asset);
    _bookURL = await (await uploadTask.onComplete).ref.getDownloadURL();
    print(_bookURL);

    return _bookURL;
  }

  Future uploadFile() async {}

  TextEditingController bookNamecontroller = TextEditingController();
  TextEditingController authorNamecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  TextEditingController bookPdfUrlcontroller = TextEditingController();

  String publishDate = DateTime.now().toString();

  // TextEditingController gendercontroller = TextEditingController();

  var _bookAdd = BookModel(
      bookName: '',
      author: '',
      description: '',
      bookpdfUrl: '',
      category: '',
      imgAssetPath: '',
      publishDate: '');

  Future<void> _submit() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('Books/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);

    await uploadTask.onComplete;

    print('File Uploaded');

    await storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _bookAdd = BookModel(
          bookName: bookNamecontroller.text,
          author: authorNamecontroller.text,
          description: descriptioncontroller.text,
          category: _selectedCategories.toString(),
          bookpdfUrl: _bookURL.toString(),
          imgAssetPath: fileURL.toString(),
          publishDate: DateTime.now().toString(),
          views: 0,
          downloads: 0,
          readers: 0,
        );

        _uploadedFileURL = fileURL;
        print(_uploadedFileURL);
      });
    });
//    print(_selectedGender);
//    print(_userAdd.dateofbirth);
    await Provider.of<BookProvider>(context, listen: false)
        .addBook(_bookAdd)
        .then((_) {});
  }

  @override
  Widget build(BuildContext context) {
//    final data = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Add Book",
          style: MyText.headings,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              left: 10,
              top: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 150,
                child: Stack(
                  children: <Widget>[
                    _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Image.file(
                              _image,
                              height: 190,
                              width: 150,
                              fit: BoxFit.fill,
                            ),
                          )
                        : Container(
                            height: 190,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10)),
                          ),
                    Positioned(
                        top: 110,
                        left: 110,
                        child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Theme.of(context).accentColor,
                            child: IconButton(
                              onPressed: () => chooseFile(),
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ))),
                  ],
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Book Name'),
                textInputAction: TextInputAction.next,
                controller: bookNamecontroller,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Author Name'),
                textInputAction: TextInputAction.next,
                // keyboardType: TextInputType.text,
                controller: authorNamecontroller,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                textInputAction: TextInputAction.next,
                // keyboardType: TextInputType.text,
                controller: descriptioncontroller,
              ),
              Container(
                // height: 130,
                child: Container(
                  width: double.infinity,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      focusColor: Colors.white,
                      iconEnabledColor: Colors.purple,
                      iconDisabledColor: Colors.purple,
                      iconSize: 20,
                      items: _categories.map((String dropDownStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDownStringItem,
                          child: Container(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              dropDownStringItem,
                              style:
                                  TextStyle(fontSize: 15, color: Colors.purple),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String newValue) {
                        setState(() {
                          this._selectedCategories = newValue;
                        });
                      },
                      value: _selectedCategories,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20, left: 5, bottom: 5, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 150,
                      child: Text(_bookURL.toString() == ''
                          ? "Please Select File"
                          : bookfileName),
                    ),
                    InkWell(
                        onTap: () {
                          getPdfAndUpload();
                        },
                        child: Container(
                            child: Text(
                          "Add Book Pdf",
                          style: TextStyle(color: Colors.purple),
                        ))),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  _submit();
                },
                child: Container(
                  margin: EdgeInsets.all(15),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.purple),
                  child: Center(
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
