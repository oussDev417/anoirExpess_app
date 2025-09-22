import 'package:anoirexpress/components/anoir_primary_appbar.dart';
import 'package:anoirexpress/controllers/UserController.dart';
import 'package:anoirexpress/helpers/helpers.dart';
import 'package:anoirexpress/models/api_result.dart';
import 'package:anoirexpress/screens/login_screen.dart';
import 'package:anoirexpress/screens/onboarding_screen.dart';
import 'package:anoirexpress/screens/profile_screen.dart';
import 'package:anoirexpress/style/colors.dart';
import 'package:anoirexpress/utils/shared_preferencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/anoir_bottom_navigation_bar.dart';
import '../../components/deliver/anoir_deliver_bottom_navigation_bar.dart';
import '../../style/style.dart';
import '../../translations.dart';
import '../../utils/loader.dart';
import '../deliver_screens/main_screen/deliver_notes_screen.dart';
import '../webview/anoir_webview_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (userController) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white10,
            elevation: 0,
            leadingWidth: 0,
            centerTitle: false,
            title: Text(AppTranslations.of(context)!.text('profile'), style: TextStyle(fontFamily: AppStyle.primaryFont,fontSize: AppStyle.size24,color : AppColors.black2Color, fontWeight: FontWeight.w700,),),

          ),
          bottomNavigationBar: prefs!.getString('role') == 'DELIVER' ? AnoirDeliverBottomNavigationBar() : AnoirBottomNavigationBar(),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children : [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(9),gradient: LinearGradient(colors: [
                    AppColors.primaryBlueColor,
                    AppColors.blue1Color,
                  ])),
                  child:  Row(
                    children: [
                  CircleAvatar(child: Icon(Icons.person,color: AppColors.primaryBlueColor,size: 50,),radius: 40,backgroundColor: Colors.white,),
        // CircleAvatar(backgroundImage: AssetImage('assets/png/img_profile.png'),radius: 40,),
                      SizedBox(width: 20,),
                      Text(userController.currentUser == null ? '' : userController.currentUser!.firstname + " " + userController.currentUser!.lastname,textAlign : TextAlign.center, style: TextStyle(fontFamily: AppStyle.secondaryFont,color: Colors.white,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis),)
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    Get.to(()=>ProfileScreen());
                  },
                  child: ListTile(
                    horizontalTitleGap: 10,
                    contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: 5),
                    leading: SvgPicture.asset('assets/svg/ic_profile.svg',),
                    trailing: SvgPicture.asset('assets/svg/ic_arrow_right2.svg',),
                    title : Text(AppTranslations.of(context)!.text('personalInformations'), style: TextStyle(fontFamily: AppStyle.secondaryFont,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis),)
                  ),
                ),
                prefs!.getString('role') == 'DELIVER' ? InkWell(
                  onTap: (){
                    Get.to(()=>DeliverNotesScreen());
                  },
                  child: ListTile(
                      horizontalTitleGap: 10,
                      contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: 3),
                      leading: SvgPicture.asset('assets/svg/ic_cgu.svg',),
                      trailing: SvgPicture.asset('assets/svg/ic_arrow_right2.svg',),
                      title : Text(AppTranslations.of(context)!.text('notesEtAvis'), style: TextStyle(fontFamily: AppStyle.secondaryFont,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis),)
                  ),
                ) : SizedBox(),
                InkWell(
                  onTap: (){
                    Get.to(()=>AnoirWebviewScreen(url: 'https://anoirexpress.com/cgu',));
                  },
                  child: ListTile(
                      horizontalTitleGap: 10,
                      contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: 3),
                      leading: SvgPicture.asset('assets/svg/ic_cgu.svg',),
                      trailing: SvgPicture.asset('assets/svg/ic_arrow_right2.svg',),
                      title : Text(AppTranslations.of(context)!.text('cgu'), style: TextStyle(fontFamily: AppStyle.secondaryFont,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis),)
                  ),
                ),
                InkWell(
                  onTap: (){
                    Get.to(()=>AnoirWebviewScreen(url: 'https://anoirexpress.com/cgu',));
                  },
                  child: ListTile(
                      horizontalTitleGap: 10,
                      contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: 3),
                      leading: SvgPicture.asset('assets/svg/ic_info_circle.svg',),
                      trailing: SvgPicture.asset('assets/svg/ic_arrow_right2.svg',),
                      title : Text(AppTranslations.of(context)!.text('mentionsLegales'), style: TextStyle(fontFamily: AppStyle.secondaryFont,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis),)
                  ),
                ),
                InkWell(
                  onTap: () async {
                     try{
                       await launchUrl(Uri.parse('mailto:contact@anoirexpress.com'));
                     }
                     catch(e){}
                  },
                  child: ListTile(
                      horizontalTitleGap: 10,
                      contentPadding: EdgeInsets.symmetric(horizontal: 2,vertical: 3),
                      leading: SvgPicture.asset('assets/svg/ic_support.svg',),
                      trailing: SvgPicture.asset('assets/svg/ic_arrow_right2.svg',),
                      title : Text(AppTranslations.of(context)!.text('supportAide'), style: TextStyle(fontFamily: AppStyle.secondaryFont,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis),)
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: () async {
                       Loader.showLoader(context);
                       await prefs!.clear();
                       await Get.deleteAll();
                       Future.delayed(Duration(seconds: 2),() async {
                         Loader.offLoader(context);
                         await Get.offAll(()=>OnboardingScreen());
                       });
                  },
                  child : Container(
                    width: Helpers.getScreenWidth(context),
                     height: 40,
                      color: Colors.transparent,
                      child: Text(AppTranslations.of(context)!.text('seDeconnecter'), style: TextStyle(fontFamily: AppStyle.secondaryFont,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis,color: AppColors.grey9Color),))
                ),
                SizedBox(height: 50,),
                InkWell(
                    onTap: () async {
                      showDeleteMyAccountAlert();
                    },
                    child : Container(
                        width: Helpers.getScreenWidth(context),
                        height: 40,
                        color: Colors.transparent,
                        child: Text(AppTranslations.of(context)!.text('supprimerMonCompte'), style: TextStyle(fontFamily: AppStyle.secondaryFont,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis,color: Colors.red),))
                ),
                SizedBox(height: 40,),
              ]

            ),
          ),

        );
      }
    );
  }

  void showDeleteMyAccountAlert() {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(horizontal: 13,vertical: 12),
        content: Container(
          height: 200,
          // padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                AppTranslations.of(context)!.text('supprimerMonCompte'),
                style:  TextStyle(
                  color: Colors.black,
                  fontSize: AppStyle.size20,
                  fontFamily: AppStyle.primaryFont,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Text(
                  AppTranslations.of(context)!.text('confirmDeleteAccount'),
                  textAlign : TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    height: 1.5,
                    fontSize: AppStyle.size14,
                    fontFamily: AppStyle.primaryFont,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child:  Text(
                    AppTranslations.of(context)!.text('annuler'),
                    style:  TextStyle(
                      color: AppColors.primaryBlueColor,
                      fontSize: AppStyle.size14,
                      fontFamily: AppStyle.primaryFont,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                  TextButton(onPressed: () async {
                    Navigator.pop(context);
                    Loader.showLoader(context);
                    ApiResult result = await userController.deleteUserAccount();
                    Loader.offLoader(context);
                    if(result.success){
                      Future.delayed(Duration.zero,(){
                        if(prefs != null){
                          prefs!.clear();
                        }
                      });
                      Get.offAll(()=>OnboardingScreen());
                    }
                    else{
                      FlutterToastr.show(AppTranslations.of(context)!.text('anErrorOccured'), context,backgroundColor: Colors.red,textStyle: TextStyle(color: Colors.white,fontSize: 12),);
                    }
                  },
                      child:  Text(
                        AppTranslations.of(context)!.text('supprimer'),
                        style:  TextStyle(
                          color: Colors.red,
                          fontSize: AppStyle.size14,
                          fontFamily: AppStyle.primaryFont,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ],
              )
            ],
          ),
        ),

      );
    });
  }


}
