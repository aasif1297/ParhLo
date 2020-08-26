import 'dart:io';

import 'package:bookapp/model/user.dart';
import 'package:bookapp/provider/user_provider.dart';
import 'package:bookapp/theme/mytext.dart';
import 'package:bookapp/views/book/screen/my_loader.dart';
import 'package:bookapp/views/profile_settings/widgets/birthday_widget.dart';
import 'package:bookapp/views/profile_settings/widgets/name_widget.dart';
import 'package:bookapp/views/profile_settings/widgets/user_image_widget.dart';
import 'package:bookapp/views/tab_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as Path;

class UserProfile extends StatefulWidget {
  static const String routeName = "/user_profile";

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController _nameController = new TextEditingController();

  File _image;

  bool nameVisi = false;
  bool genderVisi = false;

  var _init = true;
  var _isLoading = false;

  static String edu;
  static String gen;
  static String loc;
  static String _imageUrl = '';

  DateTime selectedDate;

  var _gender = ['Male', 'Female', 'Others', "Select Gender"];

  var _education = [
    "Bachelor's",
    "Master",
    "Phd",
    'Inter',
    'Matriculation',
    "Select Education"
  ];

  var _selectedGender = gen == null ? "Select Gender" : gen.toString();

  var _selectedEducation = edu == null ? "Select Education" : edu.toString();

  var _selectedLocation = loc == null ? "Select Location" : loc.toString();

  var _uploadedFileURL = _imageUrl == null ? "" : _imageUrl.toString();

  User user;

  void _submitPresentDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoading = true;
    _location.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
//    if (_init) {
//      setState(() {
//        _isLoading = true;
//      });
//      _refreshUser(context).then((_) {
//        setState(() {
//          _isLoading = false;
//        });
//      });
//    }
//    _init = false;
    super.didChangeDependencies();
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
      showDialog(
          context: context,
          child: AlertDialog(
            contentPadding: EdgeInsets.all(0.0),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.61,
                  child: Column(
                    children: <Widget>[
                      Container(
//                  height: 200,
                        child: _image == null
                            ? Container(
                                child: Center(
                                  child: Text("No File Choosen"),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                              )
                            : Image.file(
                                _image,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              ),
                      ),
                      _image == null
                          ? Container()
                          : InkWell(
                              onTap: () {
                                uploadFile()
                                    .then((value) => Navigator.pop(context));
                              },
                              child: Container(
                                margin: EdgeInsets.all(15),
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                        width: 1, color: Colors.purple)),
                                child: Center(
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                        color: Colors.purple, fontSize: 18),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),
          ));
    });

    print(_image.path);
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('Users/ProfilePics/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  Future<void> _refreshUser(BuildContext context) async {
    await Provider.of<UserProvider>(context, listen: false).getUser();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProvider>(context);
    gen = userProfile.myProfile.gender;
    loc = userProfile.myProfile.location;
    edu = userProfile.myProfile.education;
    _imageUrl = userProfile.myProfile.profilePhoto;
    var size = MediaQuery.of(context).size;

//    _selectedGender = gen == null ? "Select Gender" : gen.toString();
//    _uploadedFileURL = _imageUrl == null ? "" : _imageUrl.toString();
//
//    _selectedEducation = edu == null ? "Select Education" : edu.toString();
//
//    _selectedLocation = loc == null ? "Select Location" : loc.toString();
//    DateTime selectedDate;

//    void _submitPresentDate() {
//      showDatePicker(
//          context: context,
//          initialDate: DateTime.now(),
//          firstDate: DateTime(1900),
//          lastDate: DateTime.now())
//          .then((pickedDate) {
//        if (pickedDate == null) {
//          return;
//        }
//        setState(() {
//          selectedDate = pickedDate;
//        });
//      });
//    }
//

    Future<void> _updateAll() async {
      user = User(
          subscribed: userProfile.myProfile.subscribed.toString(),
          name: _nameController.text.isEmpty
              ? userProfile.myProfile.name.toString()
              : _nameController.text.toString(),
          birthday: selectedDate == null
              ? userProfile.myProfile.birthday.toString()
              : selectedDate.toString(),
          gender: _selectedGender.toString(),
          location: _selectedLocation.toString(),
          education: _selectedEducation.toString(),
          email: userProfile.myProfile.email.toString(),
          profilePhoto: _uploadedFileURL.toString(),
          username: userProfile.myProfile.username.toString(),
          uid: userProfile.myProfile.uid.toString());
      Provider.of<UserProvider>(context, listen: false)
          .updateUserProfile(user)
          .then((value) =>
              Navigator.of(context).pushReplacementNamed(TabScreen.routeName));
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushReplacementNamed(TabScreen.routeName);
      },
      child: FutureBuilder(
        future: Provider.of<UserProvider>(context, listen: false)
            .getUser()
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        }),
        builder: (ctx, snapshot) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, TabScreen.routeName);
              },
            ),
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            title: Text(
              userProfile.myProfile.name == null
                  ? ""
                  : userProfile.myProfile.name,
              style: MyText.headings,
            ),
            centerTitle: true,
          ),
          body: _isLoading
              ? Center(
                  child: MyLoader(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshUser(context),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
//                      profilePic(context),
                          UserImageWidget(size, _uploadedFileURL, chooseFile),
                          Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Name",
                                  style: MyText.greyText,
                                ),
                              ),

                              NameWidget(
                                  userProfile.myProfile.name == null
                                      ? "Your Name"
                                      : userProfile.myProfile.name.toString(),
                                  _nameController),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "BIRTHDAY",
                                  style: MyText.greyText,
                                ),
                              ),
//                          birthdayWidget(),
                              BirthdayWidget(userProfile, selectedDate,
                                  _submitPresentDate),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Email",
                                  style: MyText.greyText,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(8),
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey[300]),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          userProfile.myProfile.email
                                              .toString(),
                                          style: MyText.text,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Gender",
                                  style: MyText.greyText,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: DropdownButton<String>(
                                  focusColor: Colors.black,
                                  iconEnabledColor: Colors.black,
                                  iconDisabledColor: Colors.black,
                                  iconSize: 30,
                                  items:
                                      _gender.map((String dropDownStringItem) {
                                    return DropdownMenuItem<String>(
                                      value: dropDownStringItem,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 60),
                                        child: Text(
                                          dropDownStringItem,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      this._selectedGender = newValue;
                                    });
                                  },
                                  value: _selectedGender,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Educational Level",
                                  style: MyText.greyText,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: DropdownButton<String>(
                                  focusColor: Colors.black,
                                  iconEnabledColor: Colors.black,
                                  iconDisabledColor: Colors.black,
                                  iconSize: 30,
                                  items: _education
                                      .map((String dropDownStringItem) {
                                    return DropdownMenuItem<String>(
                                      value: dropDownStringItem,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 60),
                                        child: Text(
                                          dropDownStringItem,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Location",
                                  style: MyText.greyText,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: DropdownButton<String>(
                                  focusColor: Colors.black,
                                  iconEnabledColor: Colors.black,
                                  iconDisabledColor: Colors.black,
                                  iconSize: 30,
                                  items: _location
                                      .map((String dropDownStringItem) {
                                    return DropdownMenuItem<String>(
                                      value: dropDownStringItem,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 60),
                                        child: Text(
                                          dropDownStringItem,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      this._selectedLocation = newValue;
                                    });
                                  },
                                  value: _selectedLocation,
                                ),
                              ),
//                        Text(_nameController.text.isNotEmpty
//                            ? _nameController.text.toString()
//                            : userProfile.myProfile.name.toString()),
                              InkWell(
                                onTap: () {
                                  _updateAll();
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
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

var _location = [
  'Karachi',
  'Lahore',
  'Faisalabad',
  'Rawalpindi',
  'Multan',
  'Hyderabad',
  'Gujranwala',
  'Peshawar',
  'Islamabad',
  'Bahawalpur',
  'Sargodha',
  'Sialkot'
      'Quetta',
  'Sukkur',
  'Jhang',
  'Shekhupura',
  'Mardan',
  'Gujrat',
  'Larkana',
  'Kasur',
  'Rahim Yar Khan',
  'Sahiwal',
  'Okara',
  'Wah Cantonment',
  'Dera Ghazi Khan',
  'Mingora',
  'Mirpur Khas',
  'Chiniot',
  'Nawabshah',
  'Burewala',
  'Jhelum',
  'Sadiqabad',
  'Khanewal',
  'Hafizabad',
  'Kohat',
  'Jacobabad',
  'Shikarpur',
  'Muzaffargarh',
  'Khanpur',
  'Gojra',
  'Bahawalnagar',
  'Abbottabad',
  'Muridke',
  'Pakpattan',
  'Khuzdar',
  'Jaranwala',
  'Chishtian',
  'Daska',
  'Bhalwal',
  'Mandi Bahauddin',
  'Ahmadpur East',
  'Kamalia',
  'Tando Adam',
  'Khairpur',
  'Dera Ismail Khan',
  'Vehari',
  'Nowshera',
  'Dadu',
  'Wazirabad',
  'Khushab',
  'Charsada',
  'Swabi',
  'Chakwal',
  'Mianwali',
  'Tando Allahyar',
  'Kot Adu',
  'Turbat',
  "Select Location"
];
