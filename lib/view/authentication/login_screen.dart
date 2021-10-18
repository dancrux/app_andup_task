import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/constants/styles.dart';
import 'package:app_andup_task/utilities/size_config.dart';
import 'package:app_andup_task/utilities/spacing.dart';
import 'package:app_andup_task/view/authentication/customWidgets/continue_button.dart';
import 'package:app_andup_task/view/authentication/customWidgets/google_button.dart';
import 'package:app_andup_task/view/authentication/firebase_auth.dart';
import 'package:app_andup_task/view/authentication/login_form.dart';
import 'package:app_andup_task/view/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  bool isLoogedIn = false;
  bool _isProcessing = false;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            AppStrings.login,
            style: AppStyles.heading1,
          ),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacing.largeHeight(),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: LoginForm(
                    formKey: _formKey,
                    emailTextController: _emailTextController,
                    passwordTextController: _passwordTextController,
                  ),
                ),
                Spacing.mediumHeight(),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppStrings.signUpRoute);
                  },
                  child: const Text(
                    AppStrings.newUserSignUp,
                    style: AppStyles.heading5,
                  ),
                ),
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
                                    .signInWithEmailPassword(
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
                                User? user = await FirebaseAuthentication
                                    .signInWithGoogle(context: context);
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
            )));
  }
}
