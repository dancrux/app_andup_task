import 'package:app_andup_task/constants/colors.dart';
import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/constants/styles.dart';
import 'package:app_andup_task/network/model/book.dart';
import 'package:app_andup_task/network/repository.dart';
import 'package:app_andup_task/utilities/size_config.dart';
import 'package:app_andup_task/utilities/spacing.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Book>> bookList;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bookList = Repository().getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
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
              Container(
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
                  child: const TextField(
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.lightGrey),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)))),
                  ),
                ),
              ),
              Spacing.bigHeight(),
              const Text(
                AppStrings.famousBooks,
                style: AppStyles.heading2,
              ),
              Spacing.mediumHeight(),
              Flexible(
                child: FutureBuilder<List<Book>>(
                  future: bookList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Book>? data = snapshot.data;
                      return ListView.separated(
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: getProportionateScreenHeight(14),
                            );
                          },
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data!.length,
                          itemBuilder: (context, index) => BookListItem(
                                book: data[index],
                                onClick: () {},
                              ));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              Spacing.mediumHeight(),
            ],
          ),
        ),
      ),
    );
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
            Expanded(child: Image(image: NetworkImage("${book.image}"))),
            Spacing.smallWidth(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('${book.author}'),
                  Text('${book.title}', style: AppStyles.heading5),
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
