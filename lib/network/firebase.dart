import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/network/model/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDao {
  // 1
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection(AppStrings.firebaseCollection);
  Future<void> saveFavourite(Book book) async {
    await collectionReference.doc(book.title).set(book.toJson());
  }

  Stream<QuerySnapshot> retrieveFavouritesStream() {
    return collectionReference.snapshots();
    // await collectionReference.doc(book.title).set(book.toJson());
  }

  Future<QuerySnapshot> retrieveFavourites() {
    return collectionReference.get();
    // await collectionReference.doc(book.title).set(book.toJson());
  }

  Future<void> deleteFromFavourites(Book book) {
    return collectionReference.doc(book.title).delete();
    // await collectionReference.doc(book.title).delete();
  }

  Future<DocumentSnapshot> checkIsFavourited(Book book) async {
    // bool isSaved = false;
    return collectionReference.doc(book.title).get();
    // try {
    //   await collectionReference.doc(book.title).get().then((value) {
    //     if (value.exists) {
    //       isSaved = true;
    //     } else {
    //       isSaved = false;
    //     }
    //   });
    //   return isSaved;
    // } catch (e) {
    //   print(e);
    //   return false;
    // }
  }
}
