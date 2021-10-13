import 'package:app_andup_task/constants/colors.dart';
import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/constants/styles.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
          child: Column(
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
                padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
                child: const TextField(
                  decoration: InputDecoration(
                      hintText: AppStrings.searchHint,
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.grey,
                        size: 30,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.only(left: 16),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.lightGrey),
                          borderRadius: BorderRadius.all(Radius.circular(30)))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
