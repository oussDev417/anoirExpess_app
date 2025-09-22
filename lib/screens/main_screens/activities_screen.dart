import 'dart:developer';

import 'package:anoirexpress/components/anoir_bottom_navigation_bar.dart';
import 'package:anoirexpress/components/anoir_primary_appbar.dart';
import 'package:anoirexpress/controllers/CommandController.dart';
import 'package:anoirexpress/helpers/helpers.dart';
import 'package:anoirexpress/models/course.dart';
import 'package:anoirexpress/screens/course_details_screen.dart';
import 'package:anoirexpress/utils/shared_preferencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/deliver/anoir_deliver_bottom_navigation_bar.dart';
import '../../style/colors.dart';
import '../../style/style.dart';
import '../../translations.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  CommandController commandController = Get.put(CommandController());
  List<Course> myCourses = [];
  bool isLoading = true;

  getMyCourses() async {
    setState(() {
      isLoading = true;
    });
    List<Course> c= await commandController.getMyCourses();
    setState(() {
      myCourses = c;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getMyCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primaryBlueColor,
      displacement : 100,
      onRefresh: () async {
        log('refreshing');
        getMyCourses();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0,
          leadingWidth: 0,
          centerTitle: false,
          title: Text(AppTranslations.of(context)!.text('mesActivites') + '(${myCourses.length})', style: TextStyle(fontFamily: AppStyle.primaryFont,fontSize: AppStyle.size28,color : Colors.black, fontWeight: FontWeight.w700,),),
        ),
        bottomNavigationBar: prefs!.getString('role') == 'DELIVER' ? AnoirDeliverBottomNavigationBar() : AnoirBottomNavigationBar(),
        body: isLoading ? Container(height: Helpers.getScreenHeight(context),child: Center(child: CircularProgressIndicator(color: AppColors.primaryBlueColor,),),) : myCourses.length == 0 ? SizedBox(height: 200,child: Center(child: Text(AppTranslations.of(context)!.text('vousNavezEncoreAucuneCourse'))),) :  SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
               ...List.generate(myCourses.length, (index) => GestureDetector(
                 onTap: (){
                   // if(index != 2){
                     Get.to(()=>CourseDetailsScreen(goHome:false,course: myCourses[index]));
                   // }
                 },
                 child: Container(
                   padding: EdgeInsets.all(20),
                   color: Colors.transparent,
                   child: Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Expanded(
                           flex: 2,
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           Text('${myCourses[index].departure}, ${myCourses[index].destination}',style: TextStyle(fontFamily: AppStyle.secondaryFont,fontSize: AppStyle.size16,fontWeight: FontWeight.w500,),),
                           SizedBox(height: 8,),
                           Text('#${myCourses[index].id!.split('-').first}', style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.grey1Color,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,height: 1.5),),
                           SizedBox(height: 10,),
                           Text('${Helpers.formatDate(myCourses[index].createdAt ?? DateTime.now().toString())}',style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.grey1Color,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,height: 1.5),),
                         ],
                       )),
                       Expanded(child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           Container(
                             // height: 40,
                             padding: EdgeInsets.symmetric(
                               horizontal: 5,
                               vertical: 5
                             ),
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(20),
                                 color: getColor(myCourses[index].status)),
                             child: Center(
                               child: Text(
                                 AppTranslations.of(context)!.text( myCourses[index].status == 'CANCELED' ? 'canceled' : myCourses[index].status == 'WAITING' ? 'enAttente' : myCourses[index].status == 'ACCEPTED' ? 'accepted' : myCourses[index].status == 'IN_PROGRESS' ? 'enCours' : 'termine' ),
                                 style: TextStyle(
                                     fontFamily: AppStyle.secondaryFont,
                                     fontSize: AppStyle.size14,
                                     color: Colors.white,
                                     fontWeight: FontWeight.w400),
                               ),
                             ),
                           ),
                           SizedBox(height: 8,),
                           Text('${myCourses[index].price} FCFA',style: TextStyle(fontFamily: AppStyle.secondaryFont,fontSize: AppStyle.size16,fontWeight: FontWeight.w500,),),
                         ],
                       ))
                     ],
                   ),
                 ),
               )),
            ],
          ),
        ),

      ),
    );
  }

  getColor(status){
    switch(status){
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
}
