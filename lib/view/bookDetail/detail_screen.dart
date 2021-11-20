import 'package:app_andup_task/constants/colors.dart';
import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/constants/styles.dart';
import 'package:app_andup_task/network/firebase.dart';
import 'package:app_andup_task/network/model/book.dart';
import 'package:app_andup_task/utilities/size_config.dart';
import 'package:app_andup_task/utilities/spacing.dart';
import 'package:app_andup_task/viewModels/firebase_service_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({Key? key, required this.book}) : super(key: key);
  final Book book;

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  Color favouriteButtonColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    final bookProvider = Provider.of<FirebaseViewModel>(context, listen: false);
    bookProvider.checkIsFavorite(widget.book);
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<FirebaseViewModel>(context);

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.lightGreen.shade100,
      appBar: buildAppBar(context, () => Navigator.pop(context), () async {
        if (bookProvider.state == BookState.favorite) {
          await bookProvider.deleteFromFavorites(widget.book, context);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Deleted Book From Favorites")));
          setState(() {
            favouriteButtonColor = Colors.grey;
          });
        } else {
          await bookProvider.saveToFavorites(widget.book, context);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Saved To Favourite")));
          setState(() {
            favouriteButtonColor = AppColors.primaryColor;
          });
        }
      }, widget.book),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Stack(
                children: [
                  buildBottomBookInfo(size),
                  buildTopBookDetail(),
                  Spacing.mediumHeight()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Align buildBottomBookInfo(Size size) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(top: size.height * 0.3),
        padding: EdgeInsets.only(
            top: size.height * 0.12,
            bottom: getProportionateScreenHeight(12),
            left: getProportionateScreenWidth(12),
            right: getProportionateScreenWidth(12)),
        // height: getProportionateScreenHeight(500),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(children: [
                    const Text("rating"),
                    Text(
                      "${widget.book.rating}",
                      style: AppStyles.heading6,
                    ),
                  ]),
                ),
                Expanded(
                  child: Column(children: [
                    const Text("Category"),
                    Text(
                      "${widget.book.category}",
                      style: AppStyles.heading6,
                    )
                  ]),
                ),
              ],
            ),
            Spacing.mediumHeight(),
            Text("${widget.book.description}"),
            Spacing.mediumHeight(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(children: [
                    const Text("Print Type"),
                    Text(
                      "${widget.book.printType}",
                      style: AppStyles.heading6,
                    )
                  ]),
                ),
                Expanded(
                  child: Column(children: [
                    const Text("Page No"),
                    Text(
                      "${widget.book.pageCount}",
                      style: AppStyles.heading6,
                    )
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column buildTopBookDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${widget.book.title}",
          style: AppStyles.heading2,
        ),
        Text(
          "By: ${widget.book.author}",
          style: AppStyles.heading5,
        ),
        Spacing.smallHeight(),
        Text(
          "Published By: ${widget.book.publisher}",
          style: AppStyles.bodyText1,
        ),
        Spacing.mediumWidth(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("price"),
                Text(
                  "${widget.book.amount} Usd",
                  style: AppStyles.heading5,
                )
              ],
            ),
            Spacing.mediumWidth(),
            Hero(
              tag: "${widget.book.title}",
              child: Image.network(
                "${widget.book.image}",
                fit: BoxFit.contain,
                errorBuilder: (context, exception, stackTrace) {
                  return const Text("image unavailable");
                },
              ),
              // fit: BoxFit.contain,
              // image: NetworkImage("${widget.book.image}"))
            )
          ],
        )
      ],
    );
  }

  AppBar buildAppBar(
    BuildContext context,
    Function backPressed,
    Function saveToFavourite,
    Book book,
  ) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          buildWidgetByState(context, saveToFavourite),
          // FutureBuilder(
          //   future: FirebaseDao().checkIsFavourited(book),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //     } else {
          //       return Container(
          //         padding: const EdgeInsets.only(right: 10),
          //         height: getProportionateScreenHeight(2),
          //         width: getProportionateScreenWidth(30),
          //         child: const Center(
          //           child: CircularProgressIndicator.adaptive(
          //             strokeWidth: 2.5,
          //           ),
          //         ),
          //       );
          //     }
          //   },
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppStrings.favouritesRoute);
                },
                child: Text(
                  AppStrings.viewFav,
                  style: AppStyles.heading6
                      .copyWith(color: AppColors.primaryColor),
                )),
          )
        ]);
  }

  Widget buildWidgetByState(BuildContext context, Function saveToFavourite) {
    return Consumer(builder: (context, FirebaseViewModel user, _) {
      switch (user.state) {
        case BookState.loading:
          return Container(
            padding: const EdgeInsets.only(right: 10),
            height: getProportionateScreenHeight(2),
            width: getProportionateScreenWidth(30),
            child: const Center(
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 2.5,
              ),
            ),
          );

        case BookState.favorite:
          return IconButton(
            onPressed: () => saveToFavourite(),
            icon: const Icon(
              Icons.favorite_outlined,
              color: AppColors.primaryColor,
            ),
          );
        case BookState.notFavorite:
          return IconButton(
            onPressed: () => saveToFavourite(),
            icon: Icon(
              Icons.favorite_outlined,
              color: favouriteButtonColor,
            ),
          );

        default:
          return IconButton(
            onPressed: () => saveToFavourite(),
            icon: Icon(
              Icons.favorite_outlined,
              color: favouriteButtonColor,
            ),
          );
      }
    });
  }
}
