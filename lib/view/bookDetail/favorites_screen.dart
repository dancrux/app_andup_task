import 'dart:io';

import 'package:app_andup_task/constants/colors.dart';
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
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Book>> bookList;
  List<Book>? book = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
    final homeProvider = Provider.of<FirebaseViewModel>(context, listen: false);
    bookList = homeProvider.getFavoriteBooks(context);
  }

  @override
  Widget build(BuildContext context) {
    final favouritesProvider = Provider.of<FirebaseViewModel>(context);
    return Scaffold(
      appBar: buildAppBar(() => Navigator.pop(context), () async {
        await favouritesProvider.signOut(context);
        Navigator.pushNamed(context, AppStrings.loginRoute);
      }),
      body: RefreshIndicator(
        onRefresh: () => favouritesProvider.getFavoriteBooks(context),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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

  AppBar buildAppBar(Function backPressed, Function logout) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 22),
        child: Container(
          height: getProportionateScreenHeight(45.0),
          width: getProportionateScreenWidth(45.0),
          decoration: const BoxDecoration(
            color: AppColors.lightGrey,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              backPressed();
            },
            icon: SvgPicture.asset(
              "assets/svgs/short_arrow_left.svg",
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: TextButton(
              onPressed: () {
                logout();
              },
              child: Text(
                AppStrings.logout,
                style:
                    AppStyles.heading6.copyWith(color: AppColors.primaryColor),
              )),
        )
      ],
      centerTitle: true,
      title: const Text(
        AppStrings.favourites,
        style: AppStyles.heading1,
      ),
    );
  }

  Flexible buildListOfBooks(BuildContext context) {
    return Flexible(
      child: FutureBuilder<List<Book>>(
          future: bookList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              book = snapshot.data;
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
