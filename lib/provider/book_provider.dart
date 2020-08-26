import 'package:bookapp/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookProvider with ChangeNotifier {
  BookModel bookModel;
  BookModel singelbookModel;
  List<String> bookViewed = [];

  List<BookModel> _bookList = [];

  static final Firestore firestore = Firestore.instance;

  bool favorite;

  List<BookModel> get bookList {
    return [..._bookList];
  }

  Future<void> addBook(BookModel book) async {
    try {
      bookModel = BookModel(
          bookName: book.bookName,
          author: book.author,
          category: book.category,
          description: book.description,
          bookpdfUrl: book.bookpdfUrl,
          imgAssetPath: book.imgAssetPath,
          publishDate: book.publishDate,
          downloads: book.downloads,
          readers: book.readers,
          views: book.views);

      await firestore
          .collection("Books")
          .document(book.bookName)
          .setData(bookModel.toMap(bookModel));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<BookModel> getBooksFromCategory(List<BookModel> book, String category) {
    final islamic =
        book.where((element) => element.category == "$category").toList();

    notifyListeners();
    return islamic;
  }

  List<BookModel> get islamic {
    final islamic =
        _bookList.where((element) => element.category == "Islamic").toList();

    notifyListeners();
    return islamic;
  }

  List<BookModel> get politics {
    final politics =
        _bookList.where((element) => element.category == "Politics").toList();

    notifyListeners();
    return politics;
  }

  List<BookModel> get selfHelp {
    return _bookList
        .where((element) => element.category == "Self Help")
        .toList();
  }

  Future<void> getUserViewedBooks() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    final List<String> bookView = [];
    DocumentReference ref = await firestore
        .collection("users")
        .document(uid)
        .collection("ViewedBook")
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((element) {
        bookView.add(element.data['book']);
      });
      bookViewed = bookView;

      if (bookViewed == null) {
        return;
      }
      notifyListeners();
    });
  }

  Future<void> getBookList() async {
    final List<BookModel> loadedBooks = [];
    await firestore
        .collection("Books")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        bookModel = BookModel(
          bookName: element.data['bookName'],
          author: element.data['author'],
          category: element.data['category'],
          description: element.data['description'],
          bookpdfUrl: element.data['bookpdfUrl'],
          imgAssetPath: element.data['bookImage'],
        );
        loadedBooks.add(bookModel);
      });
      _bookList = loadedBooks;

      notifyListeners();
    });
  }

  Future<void> addBookDownload(String bookName, int download) async {
    try {
      await firestore
          .collection("Books")
          .document(bookName)
          .updateData({'downloads': download});

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addBookView(String bookName, int views) async {
    try {
      await firestore
          .collection("Books")
          .document(bookName)
          .updateData({'views': views});

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addBookFavorite(String bookName) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    try {
      await firestore
          .collection("users")
          .document(uid)
          .collection("FavoriteBooks")
          .document(bookName)
          .setData({"book": bookName});

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteFavorite(String bookName) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    try {
      await firestore
          .collection("users")
          .document(uid)
          .collection("FavoriteBooks")
          .document(bookName)
          .delete();

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getBookFav(String bookName) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;

    DocumentReference ref = await Firestore.instance
        .collection("users")
        .document(uid)
        .collection("FavoriteBooks")
        .document(bookName)
        .get()
        .then((value) {
      favorite = value.data['isFav'];
    });
  }

  Future<void> getBookDetails(String bookName) async {
    try {
      DocumentReference ref = await firestore
          .collection("Books")
          .document(bookName)
          .get()
          .then((value) {
        singelbookModel = BookModel(
            bookName: value.data['bookName'],
            author: value.data['author'],
            category: value.data['category'],
            description: value.data['description'],
            bookpdfUrl: value.data['bookpdfUrl'],
            imgAssetPath: value.data['bookImage'],
            publishDate: value.data['publishDate'],
            views: value.data['views'],
            readers: value.data['readers'],
            downloads: value.data['downloads']);
      });
    } catch (e) {
      print(e);
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
}
