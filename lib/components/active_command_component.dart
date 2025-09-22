import 'dart:developer';

import 'package:anoirexpress/controllers/CommandController.dart';
import 'package:anoirexpress/helpers/helpers.dart';
import 'package:anoirexpress/screens/course_details_screen.dart';
import 'package:anoirexpress/style/colors.dart';
import 'package:anoirexpress/utils/shared_preferencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../models/course.dart';
import '../screens/deliver_screens/main_screen/start_course_screen.dart';
import '../style/style.dart';
import '../translations.dart';
import 'anoir_primary_button.dart';


class ActiveCommandComponent extends StatefulWidget {
  Course course;

  ActiveCommandComponent({required this.course});
  @override
  State<ActiveCommandComponent> createState() => _ActiveCommandComponentState();
}

class _ActiveCommandComponentState extends State<ActiveCommandComponent> {
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(7),
    ),
  );
  CommandController commandController = Get.find();

  @override
  void initState() {
    log('THE COURSE ${widget.course.toJson()}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommandController>(
      builder: (commandController) {
        return GestureDetector(
          onTap: (){
            Get.to(()=>CourseDetailsScreen(course: widget.course));
          },
          child: Container(
            padding: EdgeInsets.all(15),
            width: Helpers.getScreenWidth(context),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.primaryBlueColor.withOpacity(0.05),
                boxShadow: [
                  // BoxShadow(color: Colors.black.withOpacity(0.1),blurRadius: 2,spreadRadius: 1)
                ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    children : [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // height: 40,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: widget.course.status == "ACCEPTED" ? AppColors.yellowColor: widget.course.status == "WAITING" ? AppColors.primaryRedColor : AppColors.primaryBlueColor),
                              child: Center(
                                child: Text(
                                  AppTranslations.of(context)!.text(widget.course.status == "ACCEPTED" ? 'accepted' : widget.course.status == "WAITING" ? 'enAttente' : 'enCours'),
                                  style: TextStyle(
                                      fontFamily: AppStyle.secondaryFont,
                                      fontSize: AppStyle.size14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text('Course ${widget.course.id!.split('-').first}', style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.grey3Color,fontSize: AppStyle.size14,fontWeight: FontWeight.w400),),
                            SizedBox(height: 5,),
                            widget.course.type == 'PERSON_TRANSPORTATION' ? SizedBox() :Column(
                              children: [
                                Text(widget.course.isFragile!  ? 'FRAGILE' : 'NON FRAGILE'),
                                SizedBox(height: 5,),
                              ],
                            ),
                            Text('${widget.course.description ?? ''}', style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.grey11Color,fontSize: AppStyle.size12,fontWeight: FontWeight.w400),),

                          ],
                        ),
                      ),
                      Spacer(),
                      SvgPicture.asset('assets/svg/engines/ic_${widget.course.engineType.toLowerCase()}.svg',height: widget.course.engineType == 'BUS' ? 42 : null,),
                    ]
                ),
                SizedBox(height: 30,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment : CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            SvgPicture.asset('assets/svg/ic_map_pin.svg'),
                            ...List.generate(
                                7,
                                    (index) => Container(
                                  height: 5,
                                  width: 1,
                                  color: AppColors.grey5Color,
                                  margin: EdgeInsets.only(bottom: 5),
                                ))
                          ],
                        ),
                        SizedBox(width: 8,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppTranslations.of(context)!
                                    .text('lieuDeDepart'),
                                style: TextStyle(
                                    fontFamily: AppStyle.secondaryFont,
                                    fontSize: AppStyle.size14,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  widget.course.departure,
                                  style: TextStyle(
                                      fontFamily: AppStyle.secondaryFont,
                                      fontSize: AppStyle.size14,
                                      color: AppColors.grey6Color,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment : CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: SvgPicture.asset('assets/svg/ic_map_marker.svg'),
                            ),
                          ],
                        ),
                        SizedBox(width: 8,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppTranslations.of(context)!
                                    .text('lieuDarrivee'),
                                style: TextStyle(
                                    fontFamily: AppStyle.secondaryFont,
                                    fontSize: AppStyle.size14,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  widget.course.destination,
                                  style: TextStyle(
                                      fontFamily: AppStyle.secondaryFont,
                                      fontSize: AppStyle.size14,
                                      color: AppColors.grey6Color,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 25,),
                widget.course!.status == 'ACCEPTED' && prefs!.getString('role') == 'DELIVER'? GestureDetector(
                  onTap: (){
                    Get.to(()=>StartCourseScreen(course : widget.course));
                    // enterCourseCode(context,widget.course.courseCode.toString());
                  },
                  child: Container(
                    // height: 40,
                    padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.greenColor ),
                    child: Center(
                      child: Text(
                        AppTranslations.of(context)!.text('demarrerLaCourse'),
                        style: TextStyle(
                            fontFamily: AppStyle.secondaryFont,
                            fontSize: AppStyle.size14,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ) : SizedBox(),
              ],
            ),
          ),
        );
      }
    );
  }

  void enterCourseCode(context,code) {
    bool codeIsCorrect = false;
    showModalBottomSheet(context: context,
        isScrollControlled: true,
        constraints: BoxConstraints(maxHeight: Helpers.getScreenHeight(context,percent: 0.8,),minHeight: Helpers.getScreenHeight(context,percent: 0.6,)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))),
        builder: (context){
          return StatefulBuilder(
              builder: (context,setState2) {
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppTranslations.of(context)!.text('codeDeLivraison'),
                            style: TextStyle(
                                fontFamily: AppStyle.primaryFont,
                                fontSize: AppStyle.size22,
                                fontWeight: FontWeight.w700),
                          ),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.close,
                              ))
                        ],
                      ),
                      SizedBox(height: Helpers.getScreenHeight(context,percent: 0.02),),
                      Text(
                        AppTranslations.of(context)!
                            .text('entrerLeCodeDeLivraison'),
                        style: TextStyle(
                            fontFamily: AppStyle.secondaryFont,
                            color: AppColors.black1Color,
                            fontSize: AppStyle.size16,
                            fontWeight: FontWeight.w400,
                            height: 1.5),
                      ),
                      SizedBox(height: Helpers.getScreenHeight(context,percent: 0.05),),
                      Pinput(
                        length : 5,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: defaultPinTheme.copyDecorationWith(
                          border: Border.all(color: AppColors.primaryBlueColor),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        submittedPinTheme: defaultPinTheme.copyWith(
                          textStyle: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),
                          decoration: defaultPinTheme.decoration!.copyWith(
                            color: AppColors.primaryBlueColor,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: Colors.transparent)
                          ),
                        ),
                        onChanged : (str){
                          if(str.length != 5 || str != code.toString()){
                            setState2(() {
                              codeIsCorrect = false;
                            });
                          }
                        },
                        validator: (s) {
                          if(s==code.toString()){
                            setState2(() {
                              codeIsCorrect = true;
                            });
                            return null;
                          }
                          else{
                            setState2(() {
                              codeIsCorrect = false;
                            });
                            return 'Code incorrect !';
                          }
                        },
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        showCursor: true,
                        onCompleted: (pin) => print(pin),
                      ),
                      SizedBox(height: Helpers.getScreenHeight(context,percent: 0.04),),
                      codeIsCorrect ? AnoirPrimaryButton(text: 'valider', onTap: (){
                        Get.back();
                        Get.to(()=>StartCourseScreen(course : widget.course));
                      }) : Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.primaryRedColor.withOpacity(0.5)),
                        child: Center( 
                          child: Text(
                            AppTranslations.of(context)!.text('valider'),
                            style: TextStyle(
                                fontFamily: AppStyle.secondaryFont,
                                fontSize: AppStyle.size14,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
          );
        });
  }
}

