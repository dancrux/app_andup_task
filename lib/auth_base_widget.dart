import 'package:app_andup_task/view/authentication/login_screen.dart';
import 'package:app_andup_task/view/home/home_screen.dart';
import 'package:app_andup_task/viewModels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthBaseWidget extends StatelessWidget {
  const AuthBaseWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel.instance(),
      child: Consumer(builder: (context, AuthViewModel user, _) {
        switch (user.authStatus) {
          case AuthStatus.unauthenticated:
            return const LoginScreen();

          case AuthStatus.authenticated:
            return const HomeScreen();
          case AuthStatus.authenticating:
            return const LoginScreen();

          default:
            return const LoginScreen();
        }
      }),
    );
  }
}
