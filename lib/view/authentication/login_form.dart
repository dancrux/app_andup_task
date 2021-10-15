import 'package:app_andup_task/constants/colors.dart';
import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/utilities/size_config.dart';
import 'package:app_andup_task/utilities/spacing.dart';
import 'package:app_andup_task/view/authentication/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
    required this.formKey,
    required this.emailTextController,
    required this.passwordTextController,
  }) : super(key: key);
  final GlobalKey formKey;
  final TextEditingController emailTextController;
  final TextEditingController passwordTextController;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spacing.mediumHeight(),
          Text(
            AppStrings.emailHint,
            style: TextStyle(
                fontSize: getProportionatefontSize(11),
                color: AppColors.formFieldLabel,
                fontWeight: FontWeight.bold),
          ),
          buildEmailField(widget.emailTextController),
          Spacing.mediumHeight(),
          Text(
            AppStrings.passwordHint,
            style: TextStyle(
                fontSize: getProportionatefontSize(11),
                color: AppColors.formFieldLabel,
                fontWeight: FontWeight.bold),
          ),
          buildPasswordField(widget.passwordTextController),
          Spacing.mediumHeight()
        ],
      ),
    );
  }
}

TextFormField buildPasswordField(
    TextEditingController passwordEditingController) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    obscureText: true,
    validator: (value) => Validator.validatePassword(password: value!),
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
    validator: (value) => Validator.validateName(name: value!),
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
    validator: (value) => Validator.validateEmail(email: value!),
    controller: emailEditingController,
    decoration: InputDecoration(
        hintText: AppStrings.emailHint,
        icon: SvgPicture.asset("assets/svgs/mail.svg")),
  );
}
