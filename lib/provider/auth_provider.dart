import 'dart:io';
import 'package:bookapp/model/user.dart';
import 'package:bookapp/model/user_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FacebookLogin fbLogin = FacebookLogin();
  static final Firestore firestore = Firestore.instance;

  String myUid;

  String errorMessage;

  User user = User();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    myUid = currentUser.uid;

    UserSingle.userData.id = myUid;
    notifyListeners();

    return currentUser;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await firestore
        .collection("users")
        .where("email", isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    //if user is registered then length of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoUrl,
        username: currentUser.email,
        subscribed: "Unsubscribed");

    await firestore
        .collection("users")
        .document(currentUser.uid)
        .setData(user.toMap(user));

    notifyListeners();
  }

  Future<FirebaseUser> signInManually(String email, String password) async {
    try {
      AuthResult singInuser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser _user = singInuser.user;
      notifyListeners();

      return _user;
    } on PlatformException catch (e) {
      if (Platform.isAndroid) {
        errorMessage = e.message.toString();
      } else if (Platform.isIOS) {
        errorMessage = e.message.toString();
      }
      return null;
    }
  }

  Future<FirebaseUser> signUpManually(String email, String password) async {
    try {
      AuthResult signUpuser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser _user = signUpuser.user;
      notifyListeners();
      return _user;
    } on PlatformException catch (e) {
      if (Platform.isAndroid) {
        errorMessage = e.message.toString();
      } else if (Platform.isIOS) {
        errorMessage = e.message.toString();
      }
      return null;
    }
  }

  Future<int> checkIdProviderAndLogout() async {
    int logged;
    await _auth.currentUser().then((user) {
      print(user.providerData[1].providerId);
      if (user.providerData[1].providerId == 'google.com') {
        logged = 0;
      } else if (user.providerData[1].providerId == 'facebook.com') {
        logged = 1;
      } else {
        logged = 2;
      }
    });
    return logged;
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut();
  }

  Future<void> signOutFaceBook() async {
    await fbLogin.logOut();
  }

  Future<FirebaseUser> googlesSignIn() async {
    FirebaseUser currentUser;
    try {
      GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuthentication =
          await _signInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: _signInAuthentication.accessToken,
          idToken: _signInAuthentication.idToken);

      AuthResult user = await _auth.signInWithCredential(credential);
      FirebaseUser _user = user.user;
      currentUser = _user;
      notifyListeners();

      return currentUser;
    } on PlatformException catch (e) {
      if (Platform.isAndroid) {
        errorMessage = e.message.toString();
      } else if (Platform.isIOS) {
        errorMessage = e.message.toString();
      }
      return currentUser;
    }
  }

  Future<FirebaseUser> facebookLogin() async {
    FirebaseUser currentUser;

    fbLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;

    try {
      final FacebookLoginResult facebookLoginResult =
          await fbLogin.logIn(['email', 'public_profile']);
      if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        FacebookAccessToken facebookAccessToken =
            facebookLoginResult.accessToken;
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: facebookAccessToken.token);
        final AuthResult user = await _auth.signInWithCredential(credential);
        assert(user.user.email != null);
        assert(user.user.displayName != null);
        assert(!user.user.isAnonymous);
        assert(await user.user.getIdToken() != null);
        currentUser = await _auth.currentUser();
        assert(user.user.uid == currentUser.uid);
      }
      return currentUser;
    } on PlatformException catch (e) {
      if (Platform.isAndroid) {
        errorMessage = e.message.toString();
      } else if (Platform.isIOS) {
        errorMessage = e.message.toString();
      }

      return currentUser;
    }
  }
}
