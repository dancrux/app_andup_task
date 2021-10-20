import 'dart:convert';

import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/network/model/book.dart';
import 'package:http/http.dart' as http;

class Repository {
  Future<List<Book>> getBooks() async {
    final response = await http.get(Uri.parse(AppStrings.bookUrl));

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

  Future refreshList() async {
    final response = await http.get(Uri.parse(AppStrings.bookUrl));
    if (response.statusCode == 200) {
      List jsonResult = json.decode(response.body);

      return jsonResult.map((data) => Book.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load list of books');
    }
  }
}
