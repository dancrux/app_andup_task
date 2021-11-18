import 'package:app_andup_task/constants/colors.dart';
import 'package:app_andup_task/constants/strings.dart';
import 'package:app_andup_task/constants/styles.dart';
import 'package:app_andup_task/utilities/size_config.dart';
import 'package:app_andup_task/utilities/spacing.dart';
import 'package:app_andup_task/view/authentication/customWidgets/continue_button.dart';
import 'package:app_andup_task/view/authentication/customWidgets/form_fields.dart';
import 'package:app_andup_task/viewModels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          AppStrings.forgotPassword,
          style: AppStyles.heading1,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(
            flex: 1,
          ),
          Center(child: _buildForm(context)),
          Spacing.bigHeight(),
          continueButton(
              () {}, getProportionateScreenWidth(12), AppStrings.continueText),
          const Spacer()
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final authProvider = Provider.of<AuthViewModel>(context);
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppStrings.email,
                  style: TextStyle(
                      fontSize: getProportionatefontSize(11),
                      color: AppColors.formFieldLabel,
                      fontWeight: FontWeight.bold),
                ),
                buildEmailField(_emailTextController),

                // authProvider.status == Status.Authenticating
                //     ? Center(
                //         child: CircularProgressIndicator(),
                //       )
                //     : RaisedButton(
                //         child: Text(
                //           AppLocalizations.of(context)
                //               .translate("loginBtnSignIn"),
                //           style: Theme.of(context).textTheme.button,
                //         ),
                //         onPressed: () async {
                //           if (_formKey.currentState!.validate()) {
                //             FocusScope.of(context)
                //                 .unfocus(); //to hide the keyboard - if any

                //             bool status =
                //                 await authProvider.signInWithEmailAndPassword(
                //                     _emailController.text,
                //                     _passwordController.text);

                //             if (!status) {
                //               _scaffoldKey.currentState!.showSnackBar(SnackBar(
                //                 content: Text(AppLocalizations.of(context)
                //                     .translate("loginTxtErrorSignIn")),
                //               ));
                //             } else {
                //               Navigator.of(context)
                //                   .pushReplacementNamed(Routes.home);
                //             }
                //           }
                //         }),
                // authProvider.status == Status.Authenticating
                //     ? Center(
                //         child: null,
                //       )
                //     : Padding(
                //         padding: const EdgeInsets.only(top: 48),
                //         child: Center(
                //             child: Text(
                //           AppLocalizations.of(context)
                //               .translate("loginTxtDontHaveAccount"),
                //           style: Theme.of(context).textTheme.button,
                //         )),
                //       ),
                // authProvider.status == Status.Authenticating
                //     ? Center(
                //         child: null,
                //       )
                //     : FlatButton(
                //         child: Text(AppLocalizations.of(context)
                //             .translate("loginBtnLinkCreateAccount")),
                //         textColor: Theme.of(context).iconTheme.color,
                //         onPressed: () {
                //           Navigator.of(context)
                //               .pushReplacementNamed(Routes.register);
                //         },
                //       ),
              ],
            ),
          ),
        ));
  }
}
