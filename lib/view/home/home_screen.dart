import 'package:app_andup_task/constants/colors.dart';
import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/constants/styles.dart';
import 'package:app_andup_task/network/model/book.dart';
import 'package:app_andup_task/network/repository.dart';
import 'package:app_andup_task/utilities/size_config.dart';
import 'package:app_andup_task/utilities/spacing.dart';
import 'package:app_andup_task/view/bookDetail/detail_screen.dart';
import 'package:app_andup_task/viewModels/auth_view_model.dart';
import 'package:app_andup_task/viewModels/firebase_service_viewmodel.dart';
import 'package:app_andup_task/viewModels/home_view_model.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Book>> bookList;
  List<Book>? book = List.empty();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final homeProvider = Provider.of<HomeViewModel>(context, listen: false);
    bookList = homeProvider.getBooks(context);
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeViewModel>(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => homeProvider.getBooks(context),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.homeTitle,
                  style: AppStyles.heading1,
                ),
                Spacing.mediumHeight(),
                buildCustomSearchBar(),
                Spacing.bigHeight(),
                const Text(
                  AppStrings.famousBooks,
                  style: AppStyles.heading2,
                ),
                Spacing.mediumHeight(),
                buildListOfBooks(context),
                Spacing.mediumHeight(),
              ],
            ),
          ),
        ),
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
    return Consumer(builder: (context, HomeViewModel user, _) {
      switch (user.state) {
        case HomeState.loading:
          return const Center(child: CircularProgressIndicator());

        case HomeState.completed:
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
        case HomeState.error:
          return Center(
              child: Text('Something Went Wrong Please Retry $error'));
        case HomeState.noContent:
          return const Center(child: Icon(Icons.error));

        default:
          return const Center(child: Text('Something Went Wrong Please Retry'));
      }
    });
  }

  Container buildCustomSearchBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: AppColors.neutralGrey.withOpacity(0.1),
              spreadRadius: 4,
              blurRadius: 7),
        ],
      ),
      padding: const EdgeInsets.only(
        top: 20,
      ),
      child: SizedBox(
        height: getProportionateScreenHeight(75),
        child: TextField(
          onChanged: (String searchTerm) => _searchInput(searchTerm),
          decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              hintText: AppStrings.searchHint,
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.search,
                  color: AppColors.grey,
                  size: 35,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.all(Radius.circular(30)))),
        ),
      ),
    );
  }

  _searchInput(String input) {
    final homeProvider = Provider.of<HomeViewModel>(context, listen: false);
    setState(() {
      bookList = homeProvider.search(context, input);
    });
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

class BookListItem extends StatelessWidget {
  final Book book;
  final Function onClick;
  const BookListItem({Key? key, required this.book, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        height: getProportionateScreenHeight(240),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: AppColors.neutralGrey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 9)
            ],
            color: Colors.white,
            border: Border.all(width: 2.0, color: AppColors.lightGrey),
            borderRadius: BorderRadius.circular(26)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Hero(
              tag: "${book.title}",
              child: Image.network(
                "${book.image}",
                fit: BoxFit.contain,
                errorBuilder: (context, exception, stackTrace) {
                  return const Text("image unavailable");
                },
              ),
            )),
            Spacing.smallWidth(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('${book.author}'),
                  Text('${book.title}', maxLines: 3, style: AppStyles.heading5),
                  Row(
                    children: [
                      const Icon(Icons.star_border_outlined),
                      Spacing.smallWidth(),
                      Text('${book.rating}'),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.lightBlue.shade100),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "${book.category}",
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
