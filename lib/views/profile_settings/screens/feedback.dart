import 'dart:io';

import 'package:bookapp/views/book/screen/my_loader.dart';
import 'package:path/path.dart' as Path;

import 'package:bookapp/model/feedback.dart';
import 'package:bookapp/provider/user_provider.dart';
import 'package:bookapp/theme/mytext.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FeedbackScreen extends StatefulWidget {
  static const String routeName = "/feedback";

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  var _isSubmit = false;
  var _education = [
    "Bachelor's",
    "Master",
    "Phd",
    'Inter',
    'Matriculation',
    "Select Education"
  ];
  File _image;

  var _selectedEducation = "Bachelor's";
  TextEditingController feedbackcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  String _uploadedFileURL = '';

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });

    print(_image.path);
  }

  var _feedbackAdd = FeedBackModel(
    education: '',
    email: '',
    feedback: '',
    imgAssetPath: '',
  );

  Future<void> _submit() async {
    setState(() {
      _isSubmit = true;
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('FeedBackImages/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);

    await uploadTask.onComplete;

    print('File Uploaded');

    await storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _feedbackAdd = FeedBackModel(
          feedback: feedbackcontroller.text,
          email: emailcontroller.text,
          education: _selectedEducation.toString(),
          imgAssetPath: fileURL.toString(),
        );

        _uploadedFileURL = fileURL;
        print(_uploadedFileURL);
      });
    });

    await Provider.of<UserProvider>(context, listen: false)
        .addFeedBack(_feedbackAdd)
        .then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Feedback",
          style: MyText.headings,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 10, top: 15),
            child: Text(
              "Q&A",
              style: MyText.headings,
            ),
          )
        ],
      ),
      body: _isSubmit
          ? Center(
              child: MyLoader(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey[200]),
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                focusColor: Colors.black,
                                iconEnabledColor:
                                    Color.fromRGBO(128, 128, 128, 1),
                                iconDisabledColor:
                                    Color.fromRGBO(128, 128, 128, 1),
                                iconSize: 30,
                                items:
                                    _education.map((String dropDownStringItem) {
                                  return DropdownMenuItem<String>(
                                    value: dropDownStringItem,
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 60),
                                      child: Text(
                                        dropDownStringItem,
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                128, 128, 128, 1)),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String newValue) {
                                  setState(() {
                                    this._selectedEducation = newValue;
                                  });
                                },
                                value: _selectedEducation,
                              ),
                            ),
                          ),
                          Container(
                              height: 160,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[200]),
                              margin:
                                  EdgeInsets.only(left: 10, right: 10, top: 15),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: feedbackcontroller,
                                  maxLines: 5,
                                  maxLength: 2000,
                                  decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          color:
                                              Color.fromRGBO(128, 128, 128, 1)),
                                      hintText:
                                          "Leave your Feedback here (required)",
                                      border: InputBorder.none),
                                ),
                              )),
                          Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.grey[200]),
                              margin:
                                  EdgeInsets.only(left: 10, right: 10, top: 15),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: emailcontroller,
                                  decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                          color:
                                              Color.fromRGBO(128, 128, 128, 1)),
                                      hintText:
                                          "Write your Email here (required)",
                                      border: InputBorder.none),
                                ),
                              )),
                          InkWell(
                            onTap: () => chooseFile(),
                            child: _image != null
                                ? ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: Image.file(
                                      _image,
                                      height: 190,
                                      width: 150,
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Container(
                                    height: 160,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey[200]),
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, top: 15),
                                    child: Center(
                                        child: Icon(
                                      Icons.add,
                                      size: 50,
                                      color: Color.fromRGBO(128, 128, 128, 1),
                                    ))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Upload a screenshot to help us better to identify your issue",
                              style: TextStyle(
                                  color: Color.fromRGBO(128, 128, 128, 1)),
                            ),
                          ),
                        ],
                      ),
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
                            "Submit",
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
