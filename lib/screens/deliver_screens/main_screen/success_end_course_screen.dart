import 'package:anoirexpress/components/anoir_primary_button.dart';
import 'package:anoirexpress/controllers/CommandController.dart';
import 'package:anoirexpress/helpers/helpers.dart';
import 'package:anoirexpress/screens/deliver_screens/main_screen/deliver_home_screen.dart';
import 'package:anoirexpress/utils/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../style/colors.dart';
import '../../../style/style.dart';
import '../../../translations.dart';

class SuccessEndCourseScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.fromHeight(0),child: SizedBox(),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Helpers.getScreenHeight(context,percent: 0.1),),
             SvgPicture.asset('assets/svg/ic_success_end_course.svg'),
            SizedBox(height: 40,),
            Text(
              AppTranslations.of(context)!.text('felicitations'),
              style: TextStyle(
                  fontFamily: AppStyle.secondaryFont,
                  fontSize: AppStyle.size28,
                  color: AppColors.primaryBlueColor,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 20,),
            Text(
              AppTranslations.of(context)!.text('votreCourseAeteTermineeAvecSucces'),
              style: TextStyle(
                  fontFamily: AppStyle.secondaryFont,
                  fontSize: AppStyle.size16,
                  color: Colors.black,
                  height: 1.5,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 30,),
            AnoirPrimaryButton(text: 'revenirALaccueil', onTap: () async {
              Loader.showLoader(context);
              CommandController commandController = Get.find();
              await commandController.getAvailableCourses();
              Loader.offLoader(context);
              Get.off(()=>DeliverHomeScreen());
            })

          ],
        ),
      ),
    );
  }
}
