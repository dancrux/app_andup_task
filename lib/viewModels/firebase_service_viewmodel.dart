import 'package:app_andup_task/constants/styles.dart';
import 'package:app_andup_task/network/firebase.dart';
import 'package:app_andup_task/network/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum BookState { loading, favorite, notFavorite, error, success }

class FirebaseViewModel extends ChangeNotifier {
  final FirebaseDao _firebaseDao = FirebaseDao();
  List<Book> book = List.empty();

  BookState _state = BookState.loading;
  BookState get state => _state;

  Future saveToFavorites(Book book, BuildContext context) async {
    _state = BookState.loading;
    notifyListeners();
    try {
      await _firebaseDao.saveFavourite(book);
      _state = BookState.favorite;
    } on FirebaseException catch (e) {
      _state = BookState.error;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(content: " ${e.message}"));
    }
  }

  Future checkIsFavorite(Book book) async {
    _state = BookState.loading;
    notifyListeners();
    var checkSaved = await _firebaseDao.checkIsFavourited(book);
    if (checkSaved.exists) {
      _state = BookState.favorite;
      notifyListeners();
    } else {
      _state = BookState.notFavorite;
      notifyListeners();
    }
  }

  Stream<QuerySnapshot> getFavoritesAsStream() {
    return _firebaseDao.retrieveFavouritesStream();
  }

  Future<List<Book>> getFavoriteBooks(BuildContext context) async {
    _state = BookState.loading;
    try {
      var result = await _firebaseDao.retrieveFavourites();
      book = List<Book>.from(result.docs.map((doc) => doc.data()).toList());
      // List<Book>.from(result.docs.map((e) => Book.fromJson(e.data())).toList());
      _state = BookState.success;
    } catch (e) {
      _state = BookState.error;
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(content: "An Error Occured $e"));
    }
    return book;
  }

  Future deleteFromFavorites(Book book, BuildContext context) async {
    _state = BookState.loading;
    try {
      await _firebaseDao.deleteFromFavourites(book);
      _state = BookState.notFavorite;
    } catch (e) {
      _state = BookState.error;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
          content: "An Error Occured while deleting From Favourites"));
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      content: Text(
        content,
        style: AppStyles.bodyText1,
      ),
    );
  }
}
