import 'dart:developer';

import 'package:anoirexpress/components/anoir_primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../helpers/helpers.dart';
import '../models/course.dart';
import '../screens/note_screen.dart';
import '../style/colors.dart';
import '../style/style.dart';
import '../translations.dart';

class CourseProgressComponent extends StatelessWidget {
  Course course;
  CourseProgressComponent({required this.course});

  @override
  Widget build(BuildContext context) {
    return   Container(
      padding: EdgeInsets.all(20),
      width: Helpers.getScreenHeight(context),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.primaryRedColor.withOpacity(0.08)),
      child:     course.status == 'DONE' ? buildNoteDeliver(context): course.status == 'WAITING' ?  Center(
        child: Text(
          AppTranslations.of(context)!
              .text('enAttenteDeConfirmationDunLivreur'),
          style: TextStyle(
              fontFamily: AppStyle.secondaryFont,
              fontSize: AppStyle.size12,
              fontWeight: FontWeight.w400),
        ),
      ) :  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment : CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  course.status == 'ACCEPTED' ? Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: SvgPicture.asset('assets/svg/ic_in_progress.svg'),
                  ) : SvgPicture.asset('assets/svg/ic_done.svg'),
                  Container(
                    height: 50,
                    width: 1,
                    color: course.status == 'ACCEPTED' ? AppColors.grey5Color : AppColors.primaryRedColor,
                    margin: EdgeInsets.only(bottom: 5),
                  )
                ],
              ),
              SizedBox(width: 8,),
              Expanded(
                child: Text(
                  AppTranslations.of(context)!
                      .text('votreLivreurEstEnCoursDeRoute'),
                  style: TextStyle(
                      fontFamily: AppStyle.secondaryFont,
                      fontSize: AppStyle.size14,
                      height: 1.3,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
          course.status != 'IN_PROGRESS' ? SizedBox() : Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Row(
              crossAxisAlignment : CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    course.status == 'IN_PROGRESS' ? Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: SvgPicture.asset('assets/svg/ic_in_progress.svg'),
                    ) : SvgPicture.asset('assets/svg/ic_done.svg'),
                    Container(
                      height: 50,
                      width: 1,
                      color: course.status == 'IN_PROGRESS' ? AppColors.grey5Color : AppColors.primaryRedColor,
                      margin: EdgeInsets.only(bottom: 5),
                    )
                  ],
                ),
                SizedBox(width: 8,),
                Expanded(
                  child: Text(
                    AppTranslations.of(context)!
                        .text('livraisonEnCours'),
                    style: TextStyle(
                        fontFamily: AppStyle.secondaryFont,
                        fontSize: AppStyle.size14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
          course.status != 'DONE' ? SizedBox() : Row(
            crossAxisAlignment : CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  course.status == 'DONE' ? SvgPicture.asset('assets/svg/ic_done.svg') : Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: SvgPicture.asset('assets/svg/ic_in_progress.svg'),
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
                          .text('leLivreurEstArriveAdestination'),
                      style: TextStyle(
                          fontFamily: AppStyle.secondaryFont,
                          fontSize: AppStyle.size14,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
      Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Text(
                AppTranslations.of(context)!
                    .text( course.status == 'ACCEPTED' ? 'dureeDattenteEstimee' : 'dureeDeLivraisonEstimee'),
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size12,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 5,),
              Text(
                course.status == 'ACCEPTED' ?  '15 min' : getComingTime() + ' min',
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size14,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buildNoteDeliver(BuildContext context) {
    return Container(
        height: 40,
        margin: EdgeInsets.only(top: 20),
        child: AnoirPrimaryButton(text: 'noterLeLivreur', onTap: (){
          Get.to(()=>NoteScreen(course : course));
        }));
  }

  getComingTime() {
    DateTime time1 = DateTime.parse(course.startEstimation!);
    log(time1.toString());
    log(DateTime.now().toString());
    String time2=  DateTime.now().difference(time1).toString();
    log(time2.toString());
    if(time2[0] == '0'){
      return '0';
    }
    else{
      String result = time2.split('.')[0].split(':')[1];
      log(result.toString());
      return result;
    }
  }
}
