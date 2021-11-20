import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/constants/styles.dart';
import 'package:app_andup_task/network/model/book.dart';
import 'package:app_andup_task/utilities/size_config.dart';
import 'package:app_andup_task/utilities/spacing.dart';
import 'package:app_andup_task/view/bookDetail/detail_screen.dart';
import 'package:app_andup_task/view/home/home_screen.dart';
import 'package:app_andup_task/viewModels/firebase_service_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Book>> bookList;
  List<Book>? book = List.empty();
// @override
//   void initState() {
//     super.initState();
//     final homeProvider = Provider.of<FirebaseViewModel>(context, listen: false);
//     bookList = homeProvider.;
//   }

  @override
  Widget build(BuildContext context) {
    final favouritesProvider = Provider.of<FirebaseViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          AppStrings.favourites,
          style: AppStyles.heading1,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => favouritesProvider.getFavoriteBooks(context),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacing.smallHeight(),
                buildListOfBooks(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Flexible buildListOfBooks(BuildContext context) {
    final favouritesProvider = Provider.of<FirebaseViewModel>(context);
    return Flexible(
      child: StreamBuilder(
          stream: favouritesProvider.getFavoritesAsStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              snapshot.data?.docs.forEach((element) {
                var bookData = Book(
                    author: element['author'],
                    title: element['title'],
                    category: element['category'],
                    description: element['description'],
                    image: element['image'],
                    printType: element['printType'],
                    publisher: element['publisher'],
                    rating: element['rating'],
                    amount: element['amount'],
                    pageCount: element['pageCount']);
                book?.add(bookData);
              });
            }

            return buildWidgetByState(context, snapshot.error.toString());
            // homeProvider.state == HomeState.loading
            //     ? const Center(child: CircularProgressIndicator())
            //     :
          }),
    );
  }

  Widget buildWidgetByState(BuildContext context, String error) {
    return Consumer(builder: (context, FirebaseViewModel user, _) {
      switch (user.state) {
        case BookState.loading:
          return const Center(child: CircularProgressIndicator());

        case BookState.success:
          return ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: getProportionateScreenHeight(14),
                );
              },
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: book!.length,
              itemBuilder: (context, index) => BookListItem(
                    book: book![index],
                    onClick: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              BookDetailScreen(book: book![index])));
                    },
                  ));
        case BookState.error:
          return Text(error);

        default:
          return const Center(child: Text('Something Went Wrong Please Retry'));
      }
    });
  }
}
