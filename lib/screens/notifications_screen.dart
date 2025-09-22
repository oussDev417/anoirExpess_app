import 'dart:developer';

import 'package:anoirexpress/models/course.dart';
import 'package:anoirexpress/screens/course_details_screen.dart';
import 'package:anoirexpress/screens/deliver_screens/main_screen/deliver_notes_screen.dart';
import 'package:anoirexpress/screens/note_screen.dart';
import 'package:anoirexpress/services/command_service.dart';
import 'package:anoirexpress/style/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../controllers/UserController.dart';
import '../helpers/helpers.dart';
import '../style/style.dart';
import '../translations.dart';
import '../utils/loader.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> allNotifs = [];
  bool isLoading = true;
  UserController userController = Get.find();

  getNotifs() async {
    List<dynamic> notifs = await userController.getUserNotifs();
    setState(() {
      allNotifs = notifs;
      isLoading = false;
    });
  }

  @override
  void initState() {
    getNotifs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back,color: Colors.black.withOpacity(0.9),)),
        centerTitle: false,
        title: Text(AppTranslations.of(context)!.text('notifications'), style: TextStyle(fontFamily: AppStyle.primaryFont,fontSize: AppStyle.size28,color : Colors.black, fontWeight: FontWeight.w700,),),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator(color: AppColors.primaryBlueColor,),) : allNotifs.length == 0 ? Container(
        height: 200,
        child: Center(child: Text(AppTranslations.of(context)!.text('aucuneNotification')),),
      ) : SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ...List.generate(allNotifs.length, (index) =>
                GestureDetector(
                  onTap: () async {
                    Loader.showLoader(context);
                    if(allNotifs[index]['data']['TARGET_COURSE_ID'] != null){
                      log(allNotifs[index]['data']['TARGET_COURSE_ID']);
                      CommandService commandService = CommandService();
                      Course? course = await commandService.getCourseById(allNotifs[index]['data']['TARGET_COURSE_ID']);
                      Loader.offLoader(context);
                      if(course != null){
                        Get.to(()=>CourseDetailsScreen(course: course!));
                      }
                      else{
                        FlutterToastr.show(AppTranslations.of(context)!.text('courseNonAccessible'), context,backgroundColor: Colors.red,textStyle: TextStyle(color: Colors.white,fontSize: 12));
                      }
                    }
                    else if(allNotifs[index]['data']['TARGET_NOTE_ID'] != null){
                      Loader.offLoader(context);
                      Get.to(()=>DeliverNotesScreen());
                    }
                    else{
                      log(allNotifs[index].toString());
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    color: Colors.transparent,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      CircleAvatar(radius: 18,backgroundColor: Colors.white,child: SvgPicture.asset('assets/svg/ic_notif_bing.svg'),),
                      SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('${allNotifs[index]['title']}',style: TextStyle(fontFamily: AppStyle.secondaryFont,fontSize: AppStyle.size16,fontWeight: FontWeight.w500,),),
                                Spacer(),
                                Text('${Helpers.formatDate(allNotifs[index]['createdAt'] ?? DateTime.now().toString())}',style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.grey1Color,fontSize: AppStyle.size8,fontWeight: FontWeight.w400,),),
                              ],
                            ),
                            SizedBox(height: 8,),
                            Text('${allNotifs[index]['body']}', style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.grey1Color,fontSize: AppStyle.size14,fontWeight: FontWeight.w400),),
                            SizedBox(height: 10,),

                          ],
                                              ),
                        )
                            ],
                    ),
                  ),
                )
            )],
        ),
      ),
    );
  }
}
