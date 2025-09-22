import 'package:anoirexpress/screens/deliver_screens/main_screen/deliver_home_screen.dart';
import 'package:anoirexpress/screens/main_screens/home_screen.dart';
import 'package:anoirexpress/style/colors.dart';
import 'package:anoirexpress/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/DeliverHomeScreenController.dart';

class AnoirDeliverBottomNavigationBar extends StatelessWidget {
  DeliverHomeScreenController homeScreenController = Get.put(DeliverHomeScreenController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliverHomeScreenController>(
      builder: (homeScreenController) {
        return BottomNavigationBar(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedItemColor: AppColors.primaryRedColor,
            currentIndex: homeScreenController.currentScreen,
            onTap: (index){
              homeScreenController.updateCurrentScreen(index);
            },
            items: [
          BottomNavigationBarItem(icon: SvgPicture.asset('assets/svg/ic_home.svg',color: homeScreenController.currentScreen == 0 ? AppColors.primaryRedColor : AppColors.grey8Color,),label: AppTranslations.of(context)!.text('home')),
          BottomNavigationBarItem(icon: SvgPicture.asset('assets/svg/ic_activities.svg',color: homeScreenController.currentScreen == 1 ? AppColors.primaryRedColor : AppColors.grey8Color,),label: AppTranslations.of(context)!.text('activities')),
          BottomNavigationBarItem(icon: SvgPicture.asset('assets/svg/ic_account.svg',color: homeScreenController.currentScreen == 2 ? AppColors.primaryRedColor : AppColors.grey8Color,),label: AppTranslations.of(context)!.text('account')),
        ]);
      }
    );
  }
}
