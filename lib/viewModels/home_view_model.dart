import 'dart:io';

import 'package:app_andup_task/constants/styles.dart';
import 'package:app_andup_task/network/model/book.dart';
import 'package:app_andup_task/network/repository.dart';
import 'package:flutter/material.dart';

enum HomeState { loading, completed, error, noContent }

class HomeViewModel extends ChangeNotifier {
  Repository repository = Repository();
  List<Book> book = List.empty();
  HomeState _state = HomeState.noContent;
  HomeState get state => _state;

  Future<List<Book>> getBooks(BuildContext context,
      [String? searchTerm]) async {
    _state = HomeState.loading;
    notifyListeners();
    try {
      var result = await repository.getBooks(searchTerm);
      _state = HomeState.completed;
      notifyListeners();
      if (result.isNotEmpty) {
        book = result;
        return book;
      } else {
        _state = HomeState.error;
        notifyListeners();
      }
    } catch (e) {
      _state = HomeState.error;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(content: e.toString()));
    }
    return book;
  }

  Future<List<Book>> search(BuildContext context, String searchTerm) async {
    _state = HomeState.loading;
    notifyListeners();
    try {
      var result = await repository.searchApi(searchTerm);
      _state = HomeState.completed;
      notifyListeners();
      if (result.isNotEmpty) {
        book = result;
        return book;
      }
    } catch (e) {
      _state = HomeState.error;
      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(customSnackBar(content: e.toString()));
    }
    return book;
  }

  SnackBar customSnackBar({required String content}) {
    return SnackBar(
      content: Text(
        content,
        style: AppStyles.bodyText1,
      ),
    );
  }
}
