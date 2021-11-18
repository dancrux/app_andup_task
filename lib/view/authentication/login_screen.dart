import 'package:app_andup_task/constants/colors.dart';
import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/constants/styles.dart';
import 'package:app_andup_task/utilities/size_config.dart';
import 'package:app_andup_task/utilities/spacing.dart';
import 'package:app_andup_task/view/authentication/customWidgets/continue_button.dart';
import 'package:app_andup_task/view/authentication/customWidgets/google_button.dart';
import 'package:app_andup_task/view/authentication/login_form.dart';
import 'package:app_andup_task/view/home/home_screen.dart';
import 'package:app_andup_task/viewModels/auth_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

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
        body: _buildLoginScreen(context));
  }

  Widget _buildLoginScreen(BuildContext context) {
    final authProvider = Provider.of<AuthViewModel>(context);

    return SingleChildScrollView(
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
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppStrings.forgotPassRoute);
              },
              child: Text(AppStrings.forgotPassword,
                  style: AppStyles.heading6
                      .copyWith(color: AppColors.primaryColor)),
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
            authProvider.authStatus == AuthStatus.authenticating
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        continueButton(() async {
                          if (_formKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus;

                            User? user =
                                await authProvider.signInWithEmailPassword(
                                    email: _emailTextController.text,
                                    password: _passwordTextController.text,
                                    context: context);

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
                            User? user = await authProvider.signInWithGoogle(
                                context: context);

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
        ));
  }
}
