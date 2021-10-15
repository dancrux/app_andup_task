import 'package:app_andup_task/constants/colors.dart';
import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/constants/styles.dart';
import 'package:app_andup_task/utilities/size_config.dart';
import 'package:app_andup_task/utilities/spacing.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                AppStrings.homeTitle,
                style: AppStyles.heading1,
              ),
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
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.famousBooks,
                      style: AppStyles.heading2,
                    ),
                    Spacing.bigHeight(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      height: getProportionateScreenHeight(240),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.neutralGrey.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 9)
                          ],
                          color: Colors.white,
                          border: Border.all(
                              width: 2.0, color: AppColors.lightGrey),
                          borderRadius: BorderRadius.circular(26)),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(AppStrings.author),
                              const Text(AppStrings.title,
                                  style: AppStyles.heading5),
                              Row(
                                children: [
                                  const Icon(Icons.star_border_outlined),
                                  Spacing.smallWidth(),
                                  const Text("Rating"),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.lightBlue.shade100),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    "hdkd",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
