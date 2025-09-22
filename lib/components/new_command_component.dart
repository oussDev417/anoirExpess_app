import 'dart:developer';

import 'package:anoirexpress/components/anoir_primary_button.dart';
import 'package:anoirexpress/controllers/CommandController.dart';
import 'package:anoirexpress/helpers/helpers.dart';
import 'package:anoirexpress/models/api_result.dart';
import 'package:anoirexpress/models/course.dart';
import 'package:anoirexpress/screens/course_details_screen.dart';
import 'package:anoirexpress/screens/deliver_screens/main_screen/deliver_home_screen.dart';
import 'package:anoirexpress/style/colors.dart';
import 'package:anoirexpress/translations.dart';
import 'package:anoirexpress/utils/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';

import '../style/style.dart';

class NewCommandComponent extends StatefulWidget {
  Course course;
  Function() onIgnore;
  NewCommandComponent({required this.course,required this.onIgnore});


  @override
  State<NewCommandComponent> createState() => _NewCommandComponentState();
}

class _NewCommandComponentState extends State<NewCommandComponent> {
  CommandController commandController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
      },
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1),blurRadius: 2,spreadRadius: 1)
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children : [
                SvgPicture.asset('assets/svg/engines/ic_${widget.course.engineType.toLowerCase()}.svg',height: widget.course.engineType == 'BUS' ? 42 : null,),
                Spacer(),
                SvgPicture.asset('assets/svg/ic_wallet.svg'),
                SizedBox(width: 3,),
                Text('${widget.course.price} Fr',textAlign : TextAlign.center, style: TextStyle(fontFamily: AppStyle.secondaryFont,color: Colors.black,fontSize: AppStyle.size18,fontWeight: FontWeight.w600),)
              ]
            ),
            SizedBox(height: 5,),
            Divider(),
            SizedBox(height: 5,),
            Text(widget.course.type == 'PERSON_TRANSPORTATION' ? AppTranslations.of(context)!.text('nombreDePassagers') + ' (${widget.course.passengersNumber})' : AppTranslations.of(context)!.text('colisDeLivraison') + ' (${widget.course.colisType})', style: TextStyle(fontFamily: AppStyle.secondaryFont,color: Colors.black,fontSize: AppStyle.size16,fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            widget.course.type == 'PERSON_TRANSPORTATION' ? SizedBox() :Column(
              children: [
                Text(widget.course.isFragile!  ? 'FRAGILE' : 'NON FRAGILE'),
                SizedBox(height: 10,),
              ],
            ),
            Text('${widget.course.description ?? ''}', style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.grey11Color,fontSize: AppStyle.size12,fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
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
            SizedBox(height: 20,),
            Container(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        widget.onIgnore();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),border: Border.all(color: AppColors.grey9Color)),
                        child: Center(child: Text(AppTranslations.of(context)!.text('ignorer'), style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.grey9Color,fontSize: AppStyle.size14,fontWeight: FontWeight.w400),)),),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                      flex: 2,
                      child: AnoirPrimaryButton(text: 'accepter', onTap: (){
                        showEstimationTime();
                      })),
                ],
              ),
            )
      
            // Row(
            //   children: [
            //   ],
            // )
      
          ],
        ),
      ),
    );
  }

  void showEstimationTime() {
    int minutes = 15;
    int hours = 00;
    showModalBottomSheet(context: context, 
        isScrollControlled: true,
        constraints: BoxConstraints(maxHeight: Helpers.getScreenHeight(context,percent: 0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))),
        builder: (context){
      return StatefulBuilder(
        builder: (context,setState2) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      AppTranslations.of(context)!.text('estimationDeLaDuree'),
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
                      .text('estimationDureeText'),
                  style: TextStyle(
                      fontFamily: AppStyle.secondaryFont,
                      color: AppColors.black1Color,
                      fontSize: AppStyle.size16,
                      fontWeight: FontWeight.w400,
                      height: 1.5),
                ),
                SizedBox(height: Helpers.getScreenHeight(context,percent: 0.03),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: (){
                          if(minutes > 0){
                            setState2(() {
                              minutes --;
                            });


                          }
                          else if(minutes == 0 && hours > 0){
                            setState2(() {
                              hours--;
                            });
                            if(hours == 0 && minutes == 0){
                              setState2(() {
                                minutes = 59;
                              });
                            }
                          }
                        },
                        child: SvgPicture.asset('assets/svg/ic_minus.svg')),
                     SizedBox(width: 10,),
                     Container(padding: EdgeInsets.symmetric(vertical: 25,horizontal: 20),decoration: BoxDecoration(color: AppColors.grey12Color.withOpacity(0.08),borderRadius: BorderRadius.circular(4)),
                     child:  Text(
                       hours.toString().length == 1 ? '0$hours' : '$hours',
                       style: TextStyle(
                           fontFamily: AppStyle.secondaryFont,
                           color: Colors.black,
                           fontSize: AppStyle.size24,
                           fontWeight: FontWeight.w500,),
                     ),),
                    SizedBox(width: 10,),
                    Text(
                      'H',
                      style: TextStyle(
                        fontFamily: AppStyle.secondaryFont,
                        color: Colors.black,
                        fontSize: AppStyle.size16,
                        fontWeight: FontWeight.w500,),
                    ),
                    SizedBox(width: 10,),
                    Container(padding: EdgeInsets.symmetric(vertical: 25,horizontal: 20),decoration: BoxDecoration(color: AppColors.grey12Color.withOpacity(0.08),borderRadius: BorderRadius.circular(4)),
                      child:  Text(
                        minutes.toString().length == 1 ? '0$minutes' : '$minutes',
                        style: TextStyle(
                          fontFamily: AppStyle.secondaryFont,
                          color: Colors.black,
                          fontSize: AppStyle.size24,
                          fontWeight: FontWeight.w500,),
                      ),),
                    SizedBox(width: 10,),
                    Text(
                      'min',
                      style: TextStyle(
                        fontFamily: AppStyle.secondaryFont,
                        color: Colors.black,
                        fontSize: AppStyle.size16,
                        fontWeight: FontWeight.w500,),
                    ),
                    SizedBox(width: 10,),
                    GestureDetector(
                        onTap: (){
                          if(minutes < 59){
                            setState2(() {
                              minutes ++;
                            });
                          }
                          else if(minutes == 59){
                            setState2(() {
                              minutes = 0;
                              hours++;
                            });
                          }
                        },
                        child: SvgPicture.asset('assets/svg/ic_plus.svg')),
                  ],
                ),
                SizedBox(height: Helpers.getScreenHeight(context,percent: 0.035),),
                AnoirPrimaryButton(text: 'valider', onTap: () async {
                  if(minutes + hours > 0) {
                    DateTime estimationTime = DateTime.now().add(Duration(minutes: minutes,hours: hours));
                    log(estimationTime.toIso8601String());
                    Loader.showLoader(context);
                    ApiResult result = await commandController.acceptCourse(widget.course.id!,estimationTime.toIso8601String() + 'Z');
                    Loader.offLoader(context);
                    if(result.success){
                      await commandController.getAvailableCourses();
                      await commandController.getMyLastAcceptedCourse();
                      Get.back();
                      Get.to(()=>DeliverHomeScreen());
                      FlutterToastr.show(AppTranslations.of(context)!.text('courseAccepteeAvecSucces'), context,backgroundColor: Colors.green,textStyle: TextStyle(color: Colors.white,fontSize: 12),);
                    }
                    else{
                      if(result.code == 403){
                        FlutterToastr.show(AppTranslations.of(context)!.text('cetteCourseAdejaEteReservee'), context,backgroundColor: Colors.red,textStyle: TextStyle(color: Colors.white,fontSize: 12));
                      }
                      else{
                        FlutterToastr.show(AppTranslations.of(context)!.text('ilNestPlusPossibleDeReserverCetteCourse'), context,backgroundColor: Colors.red,textStyle: TextStyle(color: Colors.white,fontSize: 12));
                      }
                    }
                  }
                })
              ],
            ),
          );
        }
      );
    });
  }


}
