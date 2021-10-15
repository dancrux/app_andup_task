import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/constants/styles.dart';
import 'package:app_andup_task/utilities/size_config.dart';
import 'package:app_andup_task/utilities/spacing.dart';
import 'package:app_andup_task/view/authentication/customWidgets/continue_button.dart';
import 'package:app_andup_task/view/authentication/customWidgets/google_button.dart';
import 'package:app_andup_task/view/authentication/sign_up_form.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            AppStrings.signUp,
            style: AppStyles.heading1,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacing.largeHeight(),
              SignUpForm(
                  formKey: _formKey,
                  emailTextController: _emailTextController,
                  passwordTextController: _passwordTextController,
                  nameTextController: _nameTextController),
              Spacing.bigHeight(),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    continueButton(() {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushNamed(context, AppStrings.homeRoute);
                      }
                    }, 16.0, AppStrings.continueText),
                    SizedBox(
                      height: getProportionateScreenHeight(23.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 43),
                      child: createGoogleButton(() {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushNamed(context, AppStrings.homeRoute);
                        }
                      }, AppStrings.signUpWithGoogle),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
