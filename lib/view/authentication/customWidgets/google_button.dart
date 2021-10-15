import 'package:app_andup_task/constants/colors.dart';
import 'package:app_andup_task/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Container createGoogleButton(Function clicked, String buttontext) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.grey)),
    height: getProportionateScreenHeight(52),
    width: getProportionateScreenWidth(302),
    child: TextButton.icon(
      icon: SvgPicture.asset("assets/svgs/google.svg"),
      onPressed: () {
        clicked();
      },
      label: Text(
        buttontext,
        style: TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.white),
          shape: MaterialStateProperty.resolveWith(
              (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ))),
    ),
  );
}
