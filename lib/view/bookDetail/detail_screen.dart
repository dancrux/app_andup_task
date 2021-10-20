import 'package:app_andup_task/constants/colors.dart';
import 'package:app_andup_task/constants/styles.dart';
import 'package:app_andup_task/network/model/book.dart';
import 'package:app_andup_task/utilities/size_config.dart';
import 'package:app_andup_task/utilities/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen({Key? key, required this.book}) : super(key: key);
  final Book book;

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(context, () => Navigator.pop(context)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Stack(
                children: [
                  Align(
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
                  ),
                  Column(
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
                              tag: "${widget.book.author}",
                              child: Image(
                                  fit: BoxFit.contain,
                                  image: NetworkImage("${widget.book.image}")))
                        ],
                      )
                    ],
                  ),
                  Spacing.mediumHeight()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

AppBar buildAppBar(BuildContext context, Function backPressed) {
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
      ));
}
