import 'package:bookapp/model/feedback.dart';
import 'package:bookapp/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String currentUser;
  String subscribe;
  FeedBackModel feedbackModel;
  List<String> userViewedBookList = [];
  List<String> userFavBookList = [];
  List<String> userReadBookList = [];
  List<String> userDownloadBookList = [];
  UserProvider({this.currentUser});

  User myProfile;
  final databaseReference = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Firestore firestore = Firestore.instance;

  void inputData() async {
    // here you write the codes to input the data into firestore
  }

  Future<void> getUserDownloadList() async {
    final prefs = await SharedPreferences.getInstance();
    userDownloadBookList = prefs.getStringList("downloadBook");

    // return prefs.getStringList("key");
  }

  Future<void> getUserFavBookList() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    String bookName;

    final List<String> loadedFavBooks = [];
    await firestore
        .collection("users")
        .document(uid)
        .collection('FavoriteBooks')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        bookName = element.data['book'];
        loadedFavBooks.add(bookName);
      });
      if (loadedFavBooks == null) {
        return;
      }
      userFavBookList = loadedFavBooks;

      notifyListeners();
    });
  }

  Future<void> getUserReadBookList() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    String bookName;

    final List<String> loadedReadBooks = [];
    await firestore
        .collection("users")
        .document(uid)
        .collection('ReadBook')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        bookName = element.data['book'];
        loadedReadBooks.add(bookName);
      });
      if (loadedReadBooks == null) {
        return;
      }
      userReadBookList = loadedReadBooks;

      notifyListeners();
    });
  }

  Future<void> getUserViewedBookList() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    String bookName;

    final List<String> loadedViewBooks = [];
    await firestore
        .collection("users")
        .document(uid)
        .collection('ViewedBook')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        bookName = element.data['book'];
        loadedViewBooks.add(bookName);
      });
      if (loadedViewBooks == null) {
        return;
      }

      userViewedBookList = loadedViewBooks;

      notifyListeners();
    });
  }

  Future<void> addFeedBack(FeedBackModel feedback) async {
    try {
      feedbackModel = FeedBackModel(
          feedback: feedback.feedback,
          email: feedback.email,
          imgAssetPath: feedback.imgAssetPath,
          education: feedback.education);

      await firestore
          .collection("FeedBack")
          .document(feedback.email)
          .setData(feedbackModel.toMap(feedbackModel));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getUser() async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    User myInfo;

    try {
      await databaseReference
          .collection("users")
          .document(uid)
          .get()
          .then((value) {
        myProfile = User(
            uid: value.data['uid'],
            email: value.data['email'],
            name: value.data['name'] ?? '',
            birthday: value.data['birthday'],
            education: value.data['education'],
            gender: value.data['gender'],
            location: value.data['location'],
            profilePhoto: value.data['profile_photo'],
            username: value.data['username'] ?? '',
            subscribed: value.data['subscribed']);
      });
      notifyListeners();
//    print(currentUserUid);

    } catch (e) {
      print(e);
    }
  }

  Future<void> updateSubscribed(String sub) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    firestore
        .collection("users")
        .document(uid)
        .updateData({'subscribed': 'Subscribed ${sub.toString()} package'});
  }

  Future<void> getSubscribed() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    await Firestore.instance
        .collection("users")
        .document(uid)
        .get()
        .then((value) {
      subscribe = value.data['subscribed'];
    });
  }

  Future<void> updateUserProfile(User currentUser) async {
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    myProfile = User(
      uid: user.uid,
      email: currentUser.email,
      name: currentUser.name ?? 'your name',
      profilePhoto: currentUser.profilePhoto,
      username: user.email ?? '',
      birthday: currentUser.birthday,
      education: currentUser.education,
      gender: currentUser.gender,
      location: currentUser.location,
      subscribed: currentUser.subscribed,
    );

    await firestore
        .collection("users")
        .document(uid)
        .updateData(myProfile.toMap(myProfile));
//
    notifyListeners();
  }
}
