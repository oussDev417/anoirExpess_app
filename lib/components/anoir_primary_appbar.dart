import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../helpers/helpers.dart';
import '../style/colors.dart';
import '../style/style.dart';
import '../translations.dart';

class AnoirPrimaryAppbar extends StatelessWidget implements PreferredSizeWidget{
  bool? showSteps;
  int? currentStep;
  int? totalSteps;
  int? goBackType;
  String title;
  bool? notUseTranslation;
  bool? centerTitle;
  Function()? onPop;
  List<Widget>? actions;
   AnoirPrimaryAppbar({required this.title,this.currentStep=1,this.totalSteps=1,
     this.showSteps=false,this.actions= const [],this.onPop,this.centerTitle=true,
     this.notUseTranslation=false,this.goBackType=0});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: Colors.white10,
          actions: actions ?? [],
          elevation: 0,
          centerTitle: centerTitle,
          leading: IconButton(onPressed: onPop ?? () { Get.back(); }, icon: Icon(goBackType == 1 ? Icons.close : Icons.arrow_back,color: Colors.black,),),
          title: Text(notUseTranslation! ? title : AppTranslations.of(context)!.text(title),
            style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.grey3Color,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,height: 1.5),),
        ),
        // showSteps! ?
        !showSteps! ? SizedBox() : Row(
          children: [
            ...List.generate(totalSteps!, (index) => Expanded(
              child: LinearPercentIndicator(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                width: Helpers.getScreenWidth(context,percent: 1/double.parse(totalSteps.toString())),
                linearGradient: LinearGradient(colors : [
                  AppColors.primaryBlueColor,
                  AppColors.primaryBlueColor.withOpacity(0.3),
                ],)
,                animation: true,
                animationDuration: 1000,
                lineHeight: 6.0,
                percent: currentStep! > (index + 1) ? 1.0 : currentStep! < (index + 1) ? 0 : 0.5,
                linearStrokeCap: LinearStrokeCap.butt,
                // progressColor: Colors.red,
              ),
            )  ),
          ],
        )


      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(showSteps! ? 65 : 57);
}
