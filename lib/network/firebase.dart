import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/network/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDao {
  // 1
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection(AppStrings.firebaseCollection);
  Future<void> saveFavourite(Book book) async {
    await collectionReference.add(book.toJson());
  }
}
