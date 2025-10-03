import 'package:anoirexpress/components/anoir_primary_button.dart';
import 'package:anoirexpress/helpers/helpers.dart';
import 'package:anoirexpress/models/api_result.dart';
import 'package:anoirexpress/screens/deliver_screens/main_screen/deliver_home_screen.dart';
import 'package:anoirexpress/screens/main_screens/home_screen.dart';
import 'package:anoirexpress/screens/register_screen.dart';
import 'package:anoirexpress/screens/reset_password/reset_password_screen.dart';
import 'package:anoirexpress/style/colors.dart';
import 'package:anoirexpress/translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';

import '../components/anoir_input_component.dart';
import '../controllers/AuthController.dart';
import '../style/style.dart';
import '../utils/loader.dart';
import '../utils/shared_preferencies.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authController = Get.put(AuthController());
  final loginFormKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: SizedBox(),backgroundColor: Colors.white10,elevation: 0,),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
              key: loginFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: Image.asset('assets/png/img_logo.png',height: 60,)),
                  SizedBox(height: 40,),
                  Text(AppTranslations.of(context)!.text('enterUsernameOrEmail'),textAlign : TextAlign.center, style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.black1Color,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,height: 1.5),),
                  SizedBox(height: 40,),
                  AnoirInputComponent(label: 'emailOrUsername',controller: usernameController,),
                  SizedBox(height: 20,),
                  AnoirInputComponent(label: 'motDePasse',isPassword:true,controller: passwordController,),
                  SizedBox(height: 12,),
                  Row(
                    children: [
                      Spacer(),
                      GestureDetector(
                        onTap: (){
                          Get.to(()=>ResetPasswordScreen());
                        },
                        child: Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                            child: Center(child: Text(AppTranslations.of(context)!.text('motDePasseOublie'),textAlign : TextAlign.center, style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.black1Color,fontSize: AppStyle.size12,fontWeight: FontWeight.w400,decoration: TextDecoration.underline),))),
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  AnoirPrimaryButton(text: 'jeMeConnecte', rightIcon: 'assets/svg/ic_arrow_right.svg', iconColor : Colors.white, onTap: () async {
                    if(loginFormKey.currentState!.validate()){
                      Loader.showLoader(context);
                      ApiResult result = await authController.loginUser(usernameController.text.trim(),passwordController.text.trim());
                      Loader.offLoader(context);
                      if(result.success){
                        if(prefs?.getString('role') == 'DELIVER'){
                          Get.offAll(()=>DeliverHomeScreen());
                        }
                        else{
                          Get.offAll(()=>HomeScreen());
                        }
                      }
                      else{
                        FlutterToastr.show(AppTranslations.of(context)!.text('identifiantsIncorrects'), context,backgroundColor: Colors.black,textStyle: TextStyle(color: Colors.white,fontSize: 12));
                      }
                    }
                  }),
                  SizedBox(height: 100,),
                ],
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: (){
                  Get.to(()=> RegisterScreen());
                },
                child: Container(height: 80,
                  width: Helpers.getScreenWidth(context),
                  child: Center(
                    child: RichText(
                      text: TextSpan(text: AppTranslations.of(context)!.text('vousNavezPasDeCompte') + ' ',style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.grey1Color,fontSize: AppStyle.size14,fontWeight: FontWeight.w500,),
                      children: [
                         TextSpan(
                           text: AppTranslations.of(context)!.text('creezVotreCompte'),
                           recognizer: TapGestureRecognizer()..onTap = (){
                             Get.to(()=> RegisterScreen());
                           },
                           style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.primaryBlueColor,fontSize: AppStyle.size14,fontWeight: FontWeight.w500,decoration: TextDecoration.underline,),
                         )]),

                    ),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white2Color,
                    // boxShadow: [BoxShadow(blurRadius: 2,spreadRadius: 1,color: Colors.grey.withOpacity(0.1))]
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
