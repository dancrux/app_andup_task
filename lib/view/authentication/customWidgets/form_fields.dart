import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/view/authentication/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

TextFormField buildPasswordField(
    TextEditingController passwordEditingController) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    obscureText: true,
    validator: (value) => Validator.validatePassword(password: value ?? ''),
    controller: passwordEditingController,
    decoration: InputDecoration(
        hintText: AppStrings.passwordHint,
        icon: SvgPicture.asset(
          "assets/svgs/loading.svg",
        )),
  );
}

TextFormField buildForgotPasswordField(
    TextEditingController passwordEditingController) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    obscureText: true,
    validator: (value) => Validator.validateConfirmPassword(
        firstPassword: value ?? '',
        secondPassword: passwordEditingController.text),
    controller: passwordEditingController,
    decoration: InputDecoration(
        hintText: AppStrings.passwordHint,
        icon: SvgPicture.asset(
          "assets/svgs/loading.svg",
        )),
  );
}

TextFormField buildNameField(TextEditingController nameEditingController) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    keyboardType: TextInputType.name,
    validator: (value) => Validator.validateName(name: value ?? ''),
    controller: nameEditingController,
    decoration: InputDecoration(
        hintText: AppStrings.userNameHint,
        icon: SvgPicture.asset("assets/svgs/user.svg")),
  );
}

TextFormField buildEmailField(TextEditingController emailEditingController) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    keyboardType: TextInputType.emailAddress,
    validator: (value) => Validator.validateEmail(email: value ?? ''),
    controller: emailEditingController,
    decoration: InputDecoration(
        hintText: AppStrings.emailHint,
        icon: SvgPicture.asset("assets/svgs/mail.svg")),
  );
}
