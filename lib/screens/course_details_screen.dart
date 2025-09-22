import 'dart:developer';

import 'package:anoirexpress/components/anoir_primary_appbar.dart';
import 'package:anoirexpress/controllers/CommandController.dart';
import 'package:anoirexpress/models/api_result.dart';
import 'package:anoirexpress/utils/loader.dart';
import 'package:anoirexpress/utils/shared_preferencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/anoir_primary_button.dart';
import '../components/client_result_component.dart';
import '../components/course_progress_component.dart';
import '../components/deliver_result_component.dart';
import '../models/course.dart';
import '../services/command_service.dart';
import '../style/colors.dart';
import '../style/style.dart';
import '../translations.dart';
import 'deliver_screens/main_screen/deliver_home_screen.dart';
import 'deliver_screens/main_screen/success_end_course_screen.dart';
import 'main_screens/home_screen.dart';

class CourseDetailsScreen extends StatefulWidget {
  bool? goHome;
  Course course;
  CourseDetailsScreen({this.goHome=false,required this.course});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  CommandController commandController = Get.find();
  // List courseProgress = ['validated','inprogress','done'];

  getCourse() async {
    CommandService commandService = CommandService();
    Course? c = await commandService.getCourseById(widget.course.id);
    setState(() {
      widget.course = c!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primaryBlueColor,
      displacement : 100,
      onRefresh: () async {
        getCourse();
      },
      child: Scaffold(
        appBar: AnoirPrimaryAppbar(
          notUseTranslation : true,
          centerTitle: false,
          title: 'Course #${widget.course.id!.split('-').first}',
          actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: GestureDetector(
              onTap: () {
                if(widget.course.status == 'WAITING' && prefs!.getString('role') == 'CLIENT'){
                  cancelCommandAlert(context);
                }
              },
              child: Container(
                // height: 40,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: getColor()),
                child: Center(
                  child: Text(
                    AppTranslations.of(context)!.text( widget.course.status == 'CANCELED' ? 'cancel' : widget.course.status == 'IN_PROGRESS' ? 'enCours' : widget.course.status == 'WAITING' ? 'enAttente' : widget.course.status == 'ACCEPTED' ? 'accepted' : 'termine'),
                    style: TextStyle(
                        fontFamily: AppStyle.secondaryFont,
                        fontSize: AppStyle.size14,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],onPop: (){
            if(widget.goHome!){
              if(prefs!.getString('role') == 'DELIVER'){
                Get.offAll(()=>DeliverHomeScreen());
              }
              else{
                Get.offAll(()=>HomeScreen());
              }
            }
            else{
              Get.back();
            }
            },),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  prefs!.getString('role') == 'CLIENT' ? DeliverResultComponent(course : widget.course) : ClientResultComponent(course : widget.course),
                  SizedBox(height: 16,),
                  prefs!.getString('role') == 'CLIENT' ? CourseProgressComponent(course : widget.course!) : Column(
                    children: [
                      widget.course.type == 'PERSON_TRANSPORTATION' ? SizedBox() : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8)),
                            border: Border(
                                top: BorderSide(color: AppColors.grey4Color),
                                left: BorderSide(color: AppColors.grey4Color),
                                bottom: BorderSide(color: AppColors.grey4Color),
                                right: BorderSide(color: AppColors.grey4Color))),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppTranslations.of(context)!
                                  .text('recipiendaire'),
                              style: TextStyle(
                                  fontFamily: AppStyle.secondaryFont,
                                  fontSize: AppStyle.size14,
                                  fontWeight: FontWeight.w400),
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.course.recipientPhone ?? '-',
                                  style: TextStyle(
                                      fontFamily: AppStyle.secondaryFont,
                                      fontSize: AppStyle.size16,
                                      fontWeight: FontWeight.w400),
                                ),
                                Spacer(),
                                IconButton(
                                  icon: SvgPicture.asset('assets/svg/ic_call.svg'),
                                  onPressed: () {
                                    try{
                                        launchUrl(Uri.parse('tel://${widget.course!.recipientPhone}'));
                                    }
                                    catch(e){

                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      widget.course.status == 'IN_PROGRESS' ? AnoirPrimaryButton(text: 'terminerLaCourse', onTap: (){
                         showAlertTerminateCourse();
                      }) : SizedBox()
                    ],
                  ),
                  SizedBox(height: 20,),

                  widget.course.status == 'ACCEPTED' && prefs!.getString('role') == 'CLIENT' ? buildDeliveryCode(context) : SizedBox(),
                  SizedBox(height: 200,)
                ],
              ),
            ),
           // widget.course.status != 'IN_PROGRESS'  ?
           Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(20),
                height: 90,
                color: getColor(),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                        AppTranslations.of(context)!.text(widget.course.type == 'PERSON_TRANSPORTATION' ? 'nombreDePassagers': 'typeDeColis'),
                        style: TextStyle(
                            fontFamily: AppStyle.secondaryFont,
                            fontSize: AppStyle.size14,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        widget.course.type == 'PERSON_TRANSPORTATION' ? widget.course.passengersNumber.toString() : widget.course.colisType,
                        style: TextStyle(
                            fontFamily: AppStyle.secondaryFont,
                            fontSize: AppStyle.size16,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ],)),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                        AppTranslations.of(context)!.text('prix'),
                        style: TextStyle(
                            fontFamily: AppStyle.secondaryFont,
                            fontSize: AppStyle.size14,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        '${widget.course.price} FCFA',
                        style: TextStyle(
                            fontFamily: AppStyle.secondaryFont,
                            fontSize: AppStyle.size16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ],)),
                  ],
                ),
              ),
            )
               // : SizedBox()
          ],
        ),
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

  buildDeliveryCode(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColors.primaryBlueColor.withOpacity(0.08)),
        child: Column(
          children: [
            Text(
              AppTranslations.of(context)!.text('codeDeLivraison'),
              style: TextStyle(
                  fontFamily: AppStyle.secondaryFont,
                  fontSize: AppStyle.size16,
                  color: AppColors.primaryBlueColor,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 25,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (index) => Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.35),border: Border.all(color: AppColors.primaryBlueColor)),
                child: Text(widget.course.courseCode.toString()[index],style: TextStyle(),),
              )),
            ),
            SizedBox(height: 25,),
            Text(
              AppTranslations.of(context)!.text('veuillezCommuniquerCeCode'),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: AppStyle.secondaryFont,
                  fontSize: AppStyle.size16,
                  height: 1.5,
                  color: AppColors.grey7Color,
                  fontWeight: FontWeight.w400),
            ),
          ],
        )
    );
  }

  getColor(){
    switch(widget.course.status){
      case 'WAITING' :
        return AppColors.primaryRedColor;
      case 'ACCEPTED' :
        return AppColors.yellowColor;
      case 'IN_PROGRESS' :
        return AppColors.primaryBlueColor;
      case 'DONE' :
        return AppColors.greenColor;
    }
  }

  void showAlertTerminateCourse() {
    showDialog(context: context, builder: (context){
      return  AlertDialog(
        content: Container(height: 180,child: Column(
          children: [
            Text(
              AppTranslations.of(context)!.text('voulezVousTerminer'),
              style: TextStyle(
                  fontFamily: AppStyle.secondaryFont,
                  fontSize: AppStyle.size16,
                  color: Colors.black,
                  height: 1.5,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15,),
            Text(AppTranslations.of(context)!.text('cetteActionFiniraLaCourse'), style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.grey11Color,fontSize: AppStyle.size14,fontWeight: FontWeight.w400,height: 1.5),),
            Spacer(),
            Container(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),border: Border.all(color: AppColors.grey9Color)),
                        child: Center(child: Text(AppTranslations.of(context)!.text('non'), style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.grey9Color,fontSize: AppStyle.size14,fontWeight: FontWeight.w400),)),),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                      child: AnoirPrimaryButton(text: 'oui', onTap: () async {
                        Get.back();
                        Loader.showLoader(context);
                        ApiResult result = await commandController.endCourse(widget.course.id!);
                        Loader.offLoader(context);
                        if(result.success){
                          Get.off(()=>SuccessEndCourseScreen());
                        }
                        else{
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            FlutterToastr.show(AppTranslations.of(context)!.text('anErrorOccured'), context,backgroundColor: Colors.red,textStyle: TextStyle(color: Colors.white,fontSize: 12),);
                          });
                        }
                      })),
                ],
              ),
            )

          ],
        ),),
      );
    });
  }

}
