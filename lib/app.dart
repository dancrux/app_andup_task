import 'package:app_andup_task/auth_base_widget.dart';
import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/view/authentication/forgot_password_screen.dart';
import 'package:app_andup_task/view/authentication/login_screen.dart';
import 'package:app_andup_task/view/authentication/sign_up_screen.dart';
import 'package:app_andup_task/view/home/home_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: _theme(),
      onGenerateRoute: _routeFactory(),
      home: const AuthBaseWidget(),
    );
  }
}

RouteFactory _routeFactory() {
  return (settings) {
    Widget screen;
    switch (settings.name) {
      case AppStrings.loginRoute:
        screen = const LoginScreen();

        break;
      case AppStrings.signUpRoute:
        screen = const SignUpScreen();

        break;
      case AppStrings.forgotPassRoute:
        screen = const ForgotPasswordScreen();

        break;
      case AppStrings.homeRoute:
        screen = const HomeScreen();

        break;
      case AppStrings.detailRoute:
        screen = const LoginScreen();

        break;
      default:
        return null;
    }
    return MaterialPageRoute(builder: (BuildContext context) => screen);
  };
}

ThemeData _theme() {
  return ThemeData(
    appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.black),
        color: Colors.transparent,
        elevation: 0),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primarySwatch: Colors.blue,
  );
}
