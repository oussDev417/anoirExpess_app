import 'dart:developer';
import 'dart:io';

import 'package:anoirexpress/controllers/CommandController.dart';
import 'package:anoirexpress/controllers/DeliverHomeScreenController.dart';
import 'package:anoirexpress/style/colors.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../components/active_command_component.dart';
import '../../../components/new_command_component.dart';
import '../../../components/deliver/anoir_deliver_bottom_navigation_bar.dart';
import '../../../controllers/UserController.dart';
import '../../../helpers/helpers.dart';
import '../../../style/style.dart';
import '../../../translations.dart';
import '../../main_screens/account_screen.dart';
import '../../main_screens/activities_screen.dart';
import '../../notifications_screen.dart';
import '../../profile_screen.dart';


class DeliverHomeScreen extends StatefulWidget {
  @override
  State<DeliverHomeScreen> createState() => _DeliverHomeScreenState();
}

class _DeliverHomeScreenState extends State<DeliverHomeScreen> {
  DeliverHomeScreenController deliverHomeScreenController = Get.put(DeliverHomeScreenController());
  UserController userController = Get.put(UserController());
  CommandController commandController = Get.put(CommandController());
  bool hasActiveCommand = false;
  bool isLoading = true;
  int currentIndex = 0;

  getTrackingAuthorization() async {
    if(Platform.isIOS){
      final status = await AppTrackingTransparency.requestTrackingAuthorization();
      print("seeee-tracking-status");
      print(status);
    }
  }

  getCurrentUser() async {
    await userController.getCurrentUser();
  }

  getAvailableCourses() async {
    setState(() {
      isLoading = true;
    });
    await commandController.getAvailableCourses();
    await commandController.getMyLastAcceptedCourse();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
      getTrackingAuthorization();
      getCurrentUser();
      getAvailableCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<DeliverHomeScreenController>(
        builder: (deliverHomeScreenController) {
          return IndexedStack(
            index: deliverHomeScreenController.currentScreen,
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
          margin: EdgeInsets.symmetric(horizontal: 20),
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
        Positioned(
            right: 10,
            child: IconButton(icon: Icon(Icons.refresh,color: AppColors.primaryBlueColor,), onPressed: () {
               getAvailableCourses();
        },))
      ],
    );
  }

  buildHome(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primaryBlueColor,
        displacement : 100,
          onRefresh: () async {
            getAvailableCourses();
          },
      child: Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: AppBar(backgroundColor: AppColors.primaryBlueColor,)),
              bottomNavigationBar: AnoirDeliverBottomNavigationBar(),
              body: Column(
                children: [
                  GetBuilder<CommandController>(
                    builder: (commandController) {
                      return Container(
                        height: 95,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: AppColors.primaryBlueColor,
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(16),bottomLeft: Radius.circular(16))
                        ),
                        child: Column(
                          children: [
                            Row(
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

                                    GetBuilder<UserController>(
                                      builder: (userController) {
                                        return Text(userController.currentUser == null ? '' : userController.currentUser!.firstname + " " + userController.currentUser!.lastname,textAlign : TextAlign.center, style: TextStyle(fontFamily: AppStyle.secondaryFont,color: Colors.white,fontSize: AppStyle.size16,fontWeight: FontWeight.w400),);
                                      }
                                    )
                                  ],
                                ),
                                Spacer(),
                                GestureDetector(
                                    onTap : (){
                                      Get.to(()=>ProfileScreen());
                                    },
                                    child: CircleAvatar(radius: 18,backgroundColor: Colors.white,child: Icon(Icons.person,color: AppColors.primaryBlueColor,),)),
                                // child: CircleAvatar(radius: 18,backgroundColor: Colors.white,child: Image.asset('assets/png/img_profile.png'),)),
                                SizedBox(width: 18,),
                                GestureDetector(
                                    onTap : (){
                                      Get.to(()=>NotificationsScreen());
                                    },
                                    child: CircleAvatar(radius: 18,backgroundColor: Colors.white,child: SvgPicture.asset('assets/svg/ic_notif_bing.svg'),)),
                              ],
                            ),
                            // SizedBox(height: 10,),
                            // GetBuilder<CommandController>(
                            //   builder: (commandController) {
                            //     return Text(commandController.availableCourses.length.toString() + ' '+ AppTranslations.of(context)!.text('demandesEnAttente'),textAlign : TextAlign.center, style: TextStyle(fontFamily: AppStyle.secondaryFont,color: Colors.white,fontSize: AppStyle.size14,fontWeight: FontWeight.w400),);
                            //   }
                            // )
                          ],
                        ),
                      );
                    }
                  ),
                  isLoading ? Container(
                    height: 100,
                    child: Center(child: CircularProgressIndicator(color: AppColors.primaryBlueColor,)),
                  ) :
                     Expanded(
                       child: Column(
                         children: [
                           SizedBox(height: 20,),
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 20.0),
                             child: GetBuilder<CommandController>(
                               builder: (commandController) {
                                 return Container(
                                   padding: EdgeInsets.all(3),
                                   decoration: BoxDecoration(color:  AppColors.grey13Color, borderRadius: BorderRadius.circular(100)),
                                   child: Row(
                                     children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                currentIndex = 0;
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                                              decoration: BoxDecoration(color:  currentIndex == 0 ? AppColors.red1Color : Colors.transparent, border: Border.all(color:  currentIndex == 0 ? AppColors.primaryRedColor : Colors.transparent),borderRadius: BorderRadius.circular(100)),
                                              child: Text(AppTranslations.of(context)!.text('toutes') + ' (${commandController.availableCourses!.length})',textAlign : TextAlign.center, style: TextStyle(fontFamily: AppStyle.secondaryFont,color: currentIndex == 0 ? AppColors.primaryRedColor : AppColors.black1Color,fontSize: AppStyle.size14,fontWeight: currentIndex == 0 ?  FontWeight.w400 : FontWeight.w400),),
                                            ),
                                          ),
                                        ),
                                       SizedBox(width: 10,),
                                       Expanded(
                                         child: GestureDetector(
                                           onTap: (){
                                             setState(() {
                                               currentIndex = 1;
                                             });
                                           },
                                           child: Container(
                                             padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                                             decoration: BoxDecoration(color:  currentIndex == 1 ? AppColors.red1Color : Colors.transparent, border: Border.all(color:  currentIndex == 1 ? AppColors.primaryRedColor : Colors.transparent),borderRadius: BorderRadius.circular(100)),
                                             child: Text(AppTranslations.of(context)!.text('mesCourses') + ' (${commandController.myLastAcceptedCourses!.length})',textAlign : TextAlign.center, style: TextStyle(fontFamily: AppStyle.secondaryFont,color: currentIndex == 1 ? AppColors.primaryRedColor : AppColors.black1Color,fontSize: AppStyle.size14,fontWeight: currentIndex == 1 ?  FontWeight.w400 : FontWeight.w400),),
                                           ),
                                         ),
                                       )
                                     ],
                                   ),
                                 );
                               }
                             ),
                           ),
                           SizedBox(height: 5,),
                           Expanded(child:
                           currentIndex == 0 ? buildAllAvailableCourses() : buildMyAcceptedCourses()
                           ),
                         ],
                       ),
                     ),
                ],
              ),
            ),
    );

  }

  buildActivities(BuildContext context) {
    return ActivitiesScreen();
  }

  buildAccount(BuildContext context) {
    return AccountScreen();
  }

  buildHasActiveCommand() {
    return GetBuilder<CommandController>(
      builder: (commandController) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ...List.generate(commandController.myLastAcceptedCourses!.length, (index){
                return ActiveCommandComponent(course : commandController.myLastAcceptedCourses![index]);
              }),
            ],
          ),
        );
      }
    );
  }

  buildAllAvailableCourses() {
    return commandController.availableCourses.length > 0 ?
    GetBuilder<CommandController>(
        builder: (commandController) {
          return  SingleChildScrollView(
            padding: EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                ...List.generate(commandController.availableCourses.length, (index) => NewCommandComponent(course : commandController.availableCourses[index], onIgnore: () {
                  commandController.ignoreThisCourse(commandController.availableCourses[index]);
                },)),
              ],
            ),
          );
        }
    ) : Container(child: buildNoDelivery(context),);
  }

  buildMyAcceptedCourses() {
    return commandController.myLastAcceptedCourses!.length > 0 ? buildHasActiveCommand() :
      Container(child: buildNoDelivery(context),);
  }
}
