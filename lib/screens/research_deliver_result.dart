import 'package:anoirexpress/components/anoir_primary_appbar.dart';
import 'package:anoirexpress/components/anoir_primary_button.dart';
import 'package:anoirexpress/screens/course_details_screen.dart';
import 'package:anoirexpress/screens/main_screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../components/deliver_result_component.dart';
import '../models/course.dart';
import '../style/colors.dart';
import '../style/style.dart';
import '../translations.dart';

class ResearchDeliverResult extends StatefulWidget {
  Course course;
  ResearchDeliverResult({required this.course});

  @override
  State<ResearchDeliverResult> createState() => _ResearchDeliverResultState();
}

class _ResearchDeliverResultState extends State<ResearchDeliverResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AnoirPrimaryAppbar(
        onPop: () {
          Get.offAll(() => HomeScreen());
        },
        title: '',
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: GestureDetector(
              onTap: () {
                cancelCommandAlert(context);
              },
              child: Container(
                // height: 40,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.primaryBlueColor.withOpacity(0.06)),
                child: Center(
                  child: Text(
                    AppTranslations.of(context)!.text('cancel'),
                    style: TextStyle(
                        fontFamily: AppStyle.secondaryFont,
                        fontSize: AppStyle.size14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.primaryRedColor.withOpacity(0.08)),
            child: Row(
              children: [
                SvgPicture.asset('assets/svg/ic_accepted_course.svg'),
                SizedBox(
                  width: 20,
                ),
                Text(
                  AppTranslations.of(context)!
                      .text('leLivreurAaccepteVotreDemande'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: AppStyle.secondaryFont,
                      fontSize: AppStyle.size12,
                      color: AppColors.red2Color,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          DeliverResultComponent(course: widget.course,),
          SizedBox(
            height: 40,
          ),
          AnoirPrimaryButton(text: 'confirmerDepartDuLivreur', onTap: () {
            Get.to(()=>CourseDetailsScreen(course:  widget.course,));
          },textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: AppStyle.size15),)
        ],
      ),
    );
  }

  void cancelCommandAlert(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            alignment: Alignment.center,
            content: Container(
              height: 120,
              child: Column(
                children: [
                  Text(
                    AppTranslations.of(context)!.text('confirmerAnnulerCourse'),
                    style: TextStyle(
                        fontFamily: AppStyle.secondaryFont,
                        fontSize: AppStyle.size14,
                        height: 1.5,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.offAll(() => HomeScreen());
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.primaryRedColor.withOpacity(0.9),
                          ),
                          child: Text(
                            AppTranslations.of(context)!.text('cancel'),
                            style: TextStyle(
                                fontFamily: AppStyle.secondaryFont,
                                color: Colors.white,
                                fontSize: AppStyle.size14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.primaryBlueColor.withOpacity(0.9),
                          ),
                          child: Text(
                            AppTranslations.of(context)!.text('continuer'),
                            style: TextStyle(
                                fontFamily: AppStyle.secondaryFont,
                                fontSize: AppStyle.size14,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
