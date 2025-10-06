import 'dart:developer';
import 'dart:io';

import 'package:anoirexpress/components/active_command_component.dart';
import 'package:anoirexpress/components/anoir_bottom_navigation_bar.dart';
import 'package:anoirexpress/controllers/CommandController.dart';
import 'package:anoirexpress/controllers/HomeScreenController.dart';
import 'package:anoirexpress/screens/notifications_screen.dart';
import 'package:anoirexpress/screens/profile_screen.dart';
import 'package:anoirexpress/style/colors.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../controllers/UserController.dart';
import '../../helpers/helpers.dart';
import '../../models/course.dart';
import '../../style/style.dart';
import '../../translations.dart';
import '../send_package_screen.dart';
import '../transport_people_screen.dart';
import 'account_screen.dart';
import 'activities_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

getTrackingAuthorization() async {
  if(Platform.isIOS){
    final status = await AppTrackingTransparency.requestTrackingAuthorization();
    print("seeee-tracking-status");
    print(status);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  UserController userController = Get.put(UserController());
  CommandController commandController = Get.put(CommandController());
  List<Course>? myCourses;

  getCurrentUser() async {
    await userController.getCurrentUser();
  }

  getMyCourses() async {
    List<Course> c= await commandController.getMyActiveCourses();
      setState(() {
        myCourses = c ;
      });
      log('MY COURSES $myCourses');
  }

  @override
  void initState() {
    getTrackingAuthorization();
    getCurrentUser();
    getMyCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<HomeScreenController>(
      builder: (homeScreenController) {
        return IndexedStack(
          index: homeScreenController.currentScreen,
          children: [
            buildHome(context),
            buildActivities(context),
            buildAccount(context)
          ],

        );
      }
    );
  }

  buildNoDelivery(context) {
    return Stack(
      children: [
        Container(
          width: Helpers.getScreenWidth(context),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
          decoration: BoxDecoration(color: AppColors.primaryBlueColor.withOpacity(0.1),borderRadius: BorderRadius.circular(7)),
          child: Column(
            children: [
              SvgPicture.asset('assets/svg/ic_no_delivery.svg',),
              SizedBox(height: 10,),
              Text(AppTranslations.of(context)!.text('noDelivery'), style: TextStyle(fontFamily: AppStyle.primaryFont,fontSize: AppStyle.size16,fontWeight: FontWeight.w500),),
            ],
          ),
        ),
        Positioned(child: IconButton(icon: Icon(Icons.refresh,color: AppColors.primaryBlueColor,), onPressed: () {
          getMyCourses();
        },))
      ],
    );
  }

  buildHome(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (userController) {
        return RefreshIndicator(
          color: AppColors.primaryBlueColor,
          displacement : 100,
          onRefresh: () async {
            getMyCourses();
          },
          child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(0),
                child: AppBar(backgroundColor: AppColors.primaryBlueColor,)),
            bottomNavigationBar: AnoirBottomNavigationBar(),
            body: Column(
              children: [
                Container(
                  height: 88,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: AppColors.primaryBlueColor,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(16),bottomLeft: Radius.circular(16))
                  ),
                  child: Row( 
                    children: [
                      CircleAvatar(child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Image.asset('assets/png/img_logo.png'),
                      ),radius: 24,backgroundColor: Colors.white,),
                      SizedBox(width: 13,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppTranslations.of(context)!.text('bienvenue'), style: TextStyle(fontFamily: AppStyle.primaryFont,color: Colors.white,fontSize: AppStyle.size20,fontWeight: FontWeight.w700,),),
                          SizedBox(height: 4,),

                          Text(userController.currentUser == null ? '' : userController.currentUser!.firstname + " " + userController.currentUser!.lastname,textAlign : TextAlign.center, style: TextStyle(fontFamily: AppStyle.secondaryFont,color: Colors.white,fontSize: AppStyle.size16,fontWeight: FontWeight.w400),)
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                          onTap: (){
                            Get.to(()=>ProfileScreen());
                          },
                          child: CircleAvatar(radius: 18,backgroundColor: Colors.white,child: Icon(Icons.person,color: AppColors.primaryBlueColor,),)),
                      SizedBox(width: 18,),
                      GestureDetector(
                          onTap: (){
                            Get.to(()=>NotificationsScreen());
                          },
                          child: CircleAvatar(radius: 18,backgroundColor: Colors.white,child: SvgPicture.asset('assets/svg/ic_notif_bing.svg'),)),
                    ],
                  ),
                ),
                SizedBox(height: 5,),
                myCourses != null  && myCourses!.length > 0 ?
                Column(
                  children: [
                    SizedBox(height: 5,),
                    Row(
                      // mainAxisSize: MainAxisSize.min,
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Get.to(()=>SendPackageScreen());
                          },
                          child: Expanded(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10,10,10,0),
                              margin: EdgeInsets.fromLTRB(20, 20, 10, 5),
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.primaryRedColor.withOpacity(0.08)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset('assets/svg/ic_send_package.svg'),
                                  //  SizedBox(
                                  //    width: 20,
                                  //  ),
                                  //  Text(
                                  //   AppTranslations.of(context)!
                                  //       .text('envoyerUnColis'),
                                  //    textAlign: TextAlign.center,
                                  //    style: TextStyle(
                                  //       fontFamily: AppStyle.secondaryFont,
                                  //        fontSize: AppStyle.size16,
                                  //       fontWeight: FontWeight.w500),
                                  // ),
                                  //  Spacer(),
                                  Icon(Icons.arrow_forward_ios,color: Colors.black,size: 15,)
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Get.to(()=>SendPackageScreen(isReceive : true));
                          },
                          child: Expanded(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10,10,10,0),
                              height: 45,
                              margin: EdgeInsets.fromLTRB(10, 20, 20, 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.primaryRedColor.withOpacity(0.08)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset('assets/svg/ic_receive_package.svg'),
                                  // SizedBox(
                                  //   width: 20,
                                  // ),
                                  // Text(
                                  //   AppTranslations.of(context)!
                                  //       .text('recevoirUnColis'),
                                  //   textAlign: TextAlign.center,
                                  //   style: TextStyle(
                                  //       fontFamily: AppStyle.secondaryFont,
                                  //       fontSize: AppStyle.size16,
                                  //       fontWeight: FontWeight.w500),
                                  // ),
                                  // Spacer(),
                                  Icon(Icons.arrow_forward_ios,color: Colors.black,size: 15,)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                    child:     GestureDetector(
                      onTap: (){
                        Get.to(()=>TransportPeopleScreen());
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20,10,20,5),
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.primaryBlueColor.withOpacity(0.8)),
                        child: Row(
                          children: [
                            Image.asset('assets/png/img_people.png',height: 60,width: 50,),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              AppTranslations.of(context)!
                                  .text('transportDePersonnes'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: AppStyle.secondaryFont,
                                  fontSize: AppStyle.size16,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios,color: Colors.white,size: 15,)
                          ],
                        ),
                      ),
                    ),)
                  ],
                ) : SizedBox(), 
                myCourses == null ? Container(height: 200,child: Center(child: CircularProgressIndicator(color: AppColors.primaryBlueColor,),),) : Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        myCourses!.length == 0 ? buildNoDelivery(context) :
                            Column(
                              children: [
                                ...List.generate(myCourses!.length, (index) => ActiveCommandComponent(course: myCourses![index])),
                              ],
                            ),
                        SizedBox(height: 20,),
                        myCourses != null && myCourses!.length > 0 ? SizedBox() : GestureDetector(
                          onTap: (){
                            Get.to(()=>SendPackageScreen());
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20,20,20,0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.primaryRedColor.withOpacity(0.08)),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/svg/ic_send_package.svg'),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  AppTranslations.of(context)!
                                      .text('envoyerUnColis'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: AppStyle.secondaryFont,
                                      fontSize: AppStyle.size16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios,color: Colors.black,size: 15,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 18,),
                        myCourses != null && myCourses!.length > 0 ? SizedBox() : GestureDetector(
                          onTap: (){
                            Get.to(()=>SendPackageScreen(isReceive : true));
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20,20,20,0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.primaryRedColor.withOpacity(0.08)),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/svg/ic_receive_package.svg'),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  AppTranslations.of(context)!
                                      .text('recevoirUnColis'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: AppStyle.secondaryFont,
                                      fontSize: AppStyle.size16,
                                      fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios,color: Colors.black,size: 15,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 18,),
                        myCourses != null && myCourses!.length > 0 ? SizedBox() : GestureDetector(
                          onTap: (){
                            Get.to(()=>TransportPeopleScreen());
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20,20,20,0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.primaryBlueColor.withOpacity(0.8)),
                            child: Row(
                              children: [
                                Image.asset('assets/png/img_people.png',height: 60,width: 50,),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  AppTranslations.of(context)!
                                      .text('transportDePersonnes'),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: AppStyle.secondaryFont,
                                      fontSize: AppStyle.size16,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios,color: Colors.white,size: 15,)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 50,),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  buildActivities(BuildContext context) {
    return ActivitiesScreen();
  }

  buildAccount(BuildContext context) {
    return AccountScreen();
  }
}

