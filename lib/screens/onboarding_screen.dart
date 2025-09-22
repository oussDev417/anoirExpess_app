import 'dart:async';

import 'package:anoirexpress/components/anoir_primary_button.dart';
import 'package:anoirexpress/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../helpers/helpers.dart';
import '../style/colors.dart';
import '../style/style.dart';
import '../translations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  PageController pageController = PageController();
  // late Timer timer;
  @override
  void initState() {
    // timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   setState(() {
    //     if(currentPage < 2){
    //         currentPage++;
    //     }
    //     else{
    //       currentPage = 0;
    //     }
    //   });
    //   pageController.animateToPage(currentPage, duration: Duration(milliseconds: 500), curve: Curves.linear);
    // });
    super.initState();
  }

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buildButtons = [
      buildOnbd1Buttons(context),
      buildOnbd2Buttons(context),
      buildOnbd3Buttons(context),
    ];

    return Scaffold(
      backgroundColor: AppColors.primaryBlueColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: Helpers.getScreenHeight(context,percent: 0.75),
              child: PageView.builder(
                controller: pageController,
                  itemCount: 3,
                  onPageChanged: (value){
                    setState(() {

                      currentPage = value;
                      pageController.animateToPage(currentPage, duration: Duration(seconds: 1), curve: Curves.linear);
                    });
                  },
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: Helpers.getScreenHeight(context,percent: 0.07),),
                          SvgPicture.asset('assets/svg/onboarding/ic_onbd${index+1}.svg',),
                          SizedBox(height: Helpers.getScreenHeight(context,percent: 0.04),),
                          Text(AppTranslations.of(context)!.text('obdTitle${index+1}'),style: TextStyle(fontFamily: AppStyle.primaryFont,color: Colors.white,fontSize: AppStyle.size28,fontWeight: FontWeight.w700),),
                          SizedBox(height: Helpers.getScreenHeight(context,percent: 0.02),),
                          Text(AppTranslations.of(context)!.text('obdDescription${index+1}'),textAlign:TextAlign.center,style: TextStyle(fontFamily: AppStyle.secondaryFont,color: Colors.white,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,height: 1.5,),),
                        ],
                      ),
                    );
                  }),
            ),
            // SizedBox(height: 20,),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children : List.generate(3, (index) => Container(width: Helpers.getScreenWidth(context,percent: 0.15),height: 5,margin : EdgeInsets.symmetric(horizontal: 5),decoration: BoxDecoration(color: index == currentPage ? AppColors.white1Color.withOpacity(0.2) : Colors.white,borderRadius: BorderRadius.circular(12)))
                )),
            SizedBox(height: Helpers.getScreenHeight(context,percent: 0.1),),
            buildButtons[currentPage],
          ],
        ),
      )
    );
  }

  buildOnbd1Buttons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: AnoirPrimaryButton(text: 'continuer',isWhite: true,rightIcon: 'assets/svg/ic_arrow_right.svg', onTap: () {
        setState(() {
          currentPage++;
          pageController.animateToPage(currentPage, duration: Duration(milliseconds: 500), curve: Curves.linear);
        });
      },),
    );
  }

  buildOnbd2Buttons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              if(currentPage > 0){
                setState(() {
                  currentPage--;
                });
                pageController.animateToPage(currentPage, duration: Duration(milliseconds: 500), curve: Curves.linear);
              }
            },
            child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(child: Text(AppTranslations.of(context)!.text('retour'),textAlign:TextAlign.center,style: TextStyle(fontFamily: AppStyle.secondaryFont,color: Colors.white,fontSize: AppStyle.size16,fontWeight: FontWeight.w500),))),
          ),
          SizedBox(width: 20,),
          Expanded(
            child: AnoirPrimaryButton(text: 'continuer',isWhite: true, onTap: () {
              if(currentPage < 2){
                setState(() {
                  currentPage++;
                  pageController.animateToPage(currentPage, duration: Duration(milliseconds: 500), curve: Curves.linear);
                });
              }
            },),
          ),
        ],
      ),
    );
  }


  buildOnbd3Buttons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: AnoirPrimaryButton(text: 'commencer',isWhite: true,rightIcon: 'assets/svg/ic_nice_arrow_right.svg', onTap: () {
        Get.to(()=>LoginScreen());
      },),
    );
  }
  

 
}
