import 'package:app_andup_task/constants/colors.dart';
import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/utilities/size_config.dart';
import 'package:app_andup_task/utilities/spacing.dart';
import 'package:app_andup_task/view/authentication/login_form.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
    required this.formKey,
    required this.emailTextController,
    required this.passwordTextController,
    required this.nameTextController,
  }) : super(key: key);
  final GlobalKey formKey;
  final TextEditingController emailTextController;
  final TextEditingController passwordTextController;
  final TextEditingController nameTextController;
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.userNameHint,
            style: TextStyle(
                fontSize: getProportionatefontSize(11),
                color: AppColors.formFieldLabel,
                fontWeight: FontWeight.bold),
          ),
          buildNameField(widget.nameTextController),
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
