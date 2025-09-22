import 'package:anoirexpress/components/anoir_primary_button.dart';
import 'package:anoirexpress/controllers/CommandController.dart';
import 'package:anoirexpress/helpers/helpers.dart';
import 'package:anoirexpress/models/api_result.dart';
import 'package:anoirexpress/models/course.dart';
import 'package:anoirexpress/screens/course_details_screen.dart';
import 'package:anoirexpress/screens/deliver_screens/main_screen/deliver_home_screen.dart';
import 'package:anoirexpress/screens/main_screens/home_screen.dart';
import 'package:anoirexpress/style/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../style/style.dart';
import '../../../translations.dart';
import '../../../utils/loader.dart';

class StartCourseScreen extends StatefulWidget {
  Course course;
  StartCourseScreen({required this.course});
  @override
  State<StartCourseScreen> createState() => _StartCourseScreenState();
}

class _StartCourseScreenState extends State<StartCourseScreen> {
  CommandController commandController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlueColor,
      appBar: AppBar(backgroundColor: Colors.transparent,
        elevation: 0,
        leading : GestureDetector(
          onTap: (){
            Get.back();
          },
          child: Icon(Icons.arrow_back,color: Colors.white,)),),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          //   SizedBox(height: Helpers.getScreenHeight(context,percent: 0.06),),
            Image.asset('assets/gif/start_course.gif'),
            Text(
              AppTranslations.of(context)!
                  .text('etSiOnDemarrait'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: AppStyle.secondaryFont,
                  color: Colors.white,
                  fontSize: AppStyle.size28,
                  fontWeight: FontWeight.w700,
                  height: 1.5),
            ),
            SizedBox(height: 0,),
            Text(
              AppTranslations.of(context)!
                  .text('assurezVousDavoirPrisTousLesColis'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: AppStyle.secondaryFont,
                  color: Colors.white,
                  fontSize: AppStyle.size14,
                  fontWeight: FontWeight.w400,
                  height: 1.5),
            ),
            SizedBox(height: 30,),
            AnoirPrimaryButton(text: 'demarrerLaCourse', isWhite : true, rightIcon: 'assets/svg/ic_arrow_right.svg', onTap: () async {
              Loader.showLoader(context);
              ApiResult result = await commandController.startCourse(widget.course);
              Loader.offLoader(context);
              if(result.success){
                 Get.to(()=>DeliverHomeScreen());
              }
              else{
                FlutterToastr.show(AppTranslations.of(context)!.text('anErrorOccured'), context,backgroundColor: Colors.red,textStyle: TextStyle(color: Colors.white,fontSize: 12),);
              }
            })
          ],
        ),
      ),
    );
  }
}
