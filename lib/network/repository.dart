import 'dart:convert';

import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/network/model/book.dart';
import 'package:http/http.dart' as http;

class Repository {
  Future<List<Book>> getBooks(String? searchTerm) async {
    List<Book> list = List.empty();

    final response = await http.get(Uri.parse(AppStrings.bookUrl));

    if (response.statusCode == 200) {
      print("${response.statusCode} server stuff");
      final jsonResult = json.decode(response.body);

      return list = List<Book>.from(
          jsonResult['items'].map((data) => Book.fromJson(data)).toList());
    } else {
      print("${response.body} server stuff");
      throw Exception('Failed to load list of books');
    }
  }

  Future<List<Book>> searchApi(String searchTerm) async {
    final response = await http.get(Uri.parse(
        'https://www.googleapis.com/books/v1/volumes?q=$searchTerm=full&key=AIzaSyDVux4lBMmak0rqXFBm3fsOPq5AVjyFMdM'));

    if (response.statusCode == 200) {
      print("${response.statusCode} server stuff");
      final jsonResult = json.decode(response.body);

      return List<Book>.from(
          jsonResult['items'].map((data) => Book.fromJson(data)).toList());
    } else {
      print("${response.statusCode} server stuff");
      throw Exception('Failed to load list of books');
    }
  }
}
 // Firebase data Access Object
