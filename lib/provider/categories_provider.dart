import 'package:bookapp/model/categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider with ChangeNotifier {
  static final Firestore firestore = Firestore.instance;
  Categories categoryModel;

  List<Categories> categoriesList = [];

  Future<void> getCategoryList() async {
    final List<Categories> loadedCategories = [];
    await firestore
        .collection("BookCategories")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      // print(snapshot.documents[0]['categoryName']);
      snapshot.documents.forEach((element) {
        categoryModel = Categories(
          name: element.data['categoryName'],
          imgUrl: element.data['categoryImg'],
        );
        loadedCategories.add(categoryModel);
        return snapshot;
      });
      if (loadedCategories == null) {
        return;
      }
      categoriesList = loadedCategories;

      notifyListeners();
    });
  }

  Future<void> getCateoryList() async {
    final List<Categories> loadedCategories = [];
    await firestore
        .collection("BookCategories")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      // print(snapshot.documents[0]['categoryName']);
      snapshot.documents.forEach((element) {
        categoryModel = Categories(
          name: element.data['categoryName'],
          imgUrl: element.data['categoryImg'],
        );
        loadedCategories.add(categoryModel);
        return snapshot;
      });
      if (loadedCategories == null) {
        return;
      }
      categoriesList = loadedCategories;

      notifyListeners();
    });
  }
}
