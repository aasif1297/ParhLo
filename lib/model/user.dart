import 'package:flutter/material.dart';

class User {
  final String uid;
  final String name;
  final String email;
  final String username;
  final String birthday;
  final String gender;
  final String location;
  final String education;
  final String profilePhoto;
  final String subscribed;

  User(
      {this.uid,
      this.name,
      this.email,
      this.username,
      this.birthday,
      this.gender,
      this.education,
      this.location,
      this.profilePhoto,
      this.subscribed});

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['username'] = user.username;
    data["birthday"] = user.birthday;
    data["gender"] = user.gender;
    data["location"] = user.location;
    data["education"] = user.education;

    data["profile_photo"] = user.profilePhoto;
    data['subscribed'] = user.subscribed;
    return data;
  }
//
//  User.fromMap(Map<String, dynamic> mapData) {
//    this.uid = mapData['uid'];
//    this.name = mapData['name'];
//    this.email = mapData['email'];
//    this.username = mapData['username'];
//    this.birthday = mapData['birthday'];
//    this.gender = mapData['gender'];
//    this.location = mapData['location'];
//    this.education = mapData['education'];
//
//    this.profilePhoto = mapData['profile_photo'];
//  }
}
