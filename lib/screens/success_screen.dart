import 'package:anoirexpress/components/anoir_primary_button.dart';
import 'package:anoirexpress/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../style/colors.dart';
import '../style/style.dart';
import '../translations.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlueColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: buidSuccessRegistration(context)
            ),
      ));
  }

  buidSuccessRegistration(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Spacer(),
        SvgPicture.asset('assets/svg/ic_check.svg'),
        SizedBox(height: 44,),
        Text(AppTranslations.of(context)!.text('felicitations'),
          style: TextStyle(color: Colors.white,fontSize: AppStyle.size28,fontFamily: AppStyle.primaryFont,fontWeight: FontWeight.bold),),
        SizedBox(height: 12,),
        Text(AppTranslations.of(context)!.text('votreCompteAeteCreeAvecSucces'),textAlign : TextAlign.center, style: TextStyle(fontFamily: AppStyle.secondaryFont,color: Colors.white,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,),),
        SizedBox(height: 20,),
        Spacer(),
        AnoirPrimaryButton(text: 'termine',
            isWhite : true,
            onTap: (){
          Get.to(()=>LoginScreen());
        }),
        Spacer(),

    ],);
  }
}
