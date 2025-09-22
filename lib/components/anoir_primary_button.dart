import 'package:anoirexpress/style/colors.dart';
import 'package:anoirexpress/style/style.dart';
import 'package:anoirexpress/translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/helpers.dart';

class AnoirPrimaryButton extends StatelessWidget {
  bool? isWhite;
  bool? isBlue;
  String rightIcon;
  String text;
  Color? iconColor;
  TextStyle? textStyle;
  GestureTapCallback   onTap;
  AnoirPrimaryButton({this.isWhite=false,this.rightIcon='',required this.text,required this.onTap,this.iconColor,this.isBlue = false,this.textStyle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,),
        height : 50,
        decoration: BoxDecoration(
          color: isWhite! ? Colors.white : isBlue! ? AppColors.primaryBlueColor : AppColors.primaryRedColor,
          borderRadius: BorderRadius.circular(50)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // rightIcon != '' ? Spacer() : SizedBox(),
            Expanded(child: Center(child: Text(AppTranslations.of(context)!.text(text),style: textStyle ?? TextStyle(color: isWhite! ? Colors.black : Colors.white,fontWeight: FontWeight.w500,fontSize: AppStyle.size16),))),
            // rightIcon != '' ? SizedBox(width: Helpers.getScreenWidth(context,percent: 0.21),) : SizedBox(),
            rightIcon != '' ? SvgPicture.asset(rightIcon,color: iconColor ?? null,) : SizedBox()
          ],
        ),
      ),
    );
  }
}
