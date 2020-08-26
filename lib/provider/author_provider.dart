import 'package:bookapp/model/author.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AuthorProvider with ChangeNotifier {
  static final Firestore firestore = Firestore.instance;
  Author authorModel;
  Author authorDesc;
  List<Author> authorList = [];

  Future<void> getAuthorList() async {
    final List<Author> loadedAuthors = [];
    await firestore
        .collection("Auhtor")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        authorModel = Author(
          name: element.data['name'],
          about: element.data['about'],
          imgUrl: element.data['imgUrl'],
          genres: element.data['genres'],
        );
        loadedAuthors.add(authorModel);
      });

      if (loadedAuthors == null) {
        return;
      }
      authorList = loadedAuthors;

      notifyListeners();
    });
  }

  Future<void> getAuthorDetails(String authorName) async {
    try {
      await firestore
          .collection("Auhtor")
          .document(authorName)
          .get()
          .then((value) {
        authorDesc = Author(
          name: value.data['name'],
          about: value.data['about'],
          imgUrl: value.data['imgUrl'],
          genres: value.data['genres'],
        );
      });
    } catch (e) {
      print(e);
    }
  }
}
