import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/constants/styles.dart';
import 'package:app_andup_task/utilities/size_config.dart';
import 'package:app_andup_task/utilities/spacing.dart';
import 'package:app_andup_task/view/authentication/customWidgets/continue_button.dart';
import 'package:app_andup_task/view/authentication/customWidgets/google_button.dart';
import 'package:app_andup_task/view/authentication/firebase_auth.dart';
import 'package:app_andup_task/view/authentication/sign_up_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  bool _isProcessing = false;
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
              _isProcessing
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          continueButton(() async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isProcessing = true;
                              });
                              User? user = await FirebaseAuthentication
                                  .registerWithEmailPassword(
                                      name: _nameTextController.text,
                                      email: _emailTextController.text,
                                      password: _passwordTextController.text,
                                      context: context);
                              setState(() {
                                _isProcessing = false;
                              });
                              if (user != null) {
                                Navigator.pushNamed(
                                    context, AppStrings.homeRoute);
                              }
                            }
                          }, 16.0, AppStrings.continueText),
                          SizedBox(
                            height: getProportionateScreenHeight(23.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 43),
                            child: createGoogleButton(() async {
                              setState(() {
                                _isProcessing = true;
                              });
                              User? user =
                                  await FirebaseAuthentication.signInWithGoogle(
                                      context: context);
                              setState(() {
                                _isProcessing = false;
                              });
                              if (user != null) {
                                Navigator.pushNamed(
                                    context, AppStrings.homeRoute);
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
