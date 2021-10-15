import 'package:app_andup_task/constants/colors.dart';

import 'package:app_andup_task/utilities/size_config.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

SizedBox continueButton(
    Function clicked, double spaceBeforeIcon, String buttonText) {
  return SizedBox(
    height: getProportionateScreenHeight(52),
    width: getProportionateScreenWidth(302),
    child: ElevatedButton(
      onPressed: () {
        clicked();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            buttonText,
            style: const TextStyle(
                color: AppColors.onPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: spaceBeforeIcon,
          ),
          SvgPicture.asset("assets/svgs/short_arrow_right.svg")
        ],
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith(
              (states) => AppColors.primaryColor),
          shape: MaterialStateProperty.resolveWith((states) =>
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}
