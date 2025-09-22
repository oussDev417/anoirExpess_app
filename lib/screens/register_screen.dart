
import 'dart:developer';

import 'package:anoirexpress/components/anoir_input_component.dart';
import 'package:anoirexpress/components/anoir_primary_button.dart';
import 'package:anoirexpress/controllers/AuthController.dart';
import 'package:anoirexpress/models/api_result.dart';
import 'package:anoirexpress/screens/register/verify_email_screen.dart';
import 'package:anoirexpress/screens/success_screen.dart';
import 'package:anoirexpress/style/style.dart';
import 'package:anoirexpress/translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';

import '../models/user.dart';
import '../style/colors.dart';
import '../utils/loader.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();

}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthController authController = Get.put(AuthController());
  final registerFormKey = GlobalKey<FormState>();

  TextEditingController firstnameController =  TextEditingController();
  TextEditingController lastnameController =  TextEditingController();
  TextEditingController usernameController =  TextEditingController();
  TextEditingController emailController =  TextEditingController();
  TextEditingController phoneController =  TextEditingController();
  TextEditingController passwordController =  TextEditingController();
  TextEditingController confirmPasswordController =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back,color: Colors.black.withOpacity(0.9),)),
        centerTitle: true,
        title: Text(AppTranslations.of(context)!.text('bienvenue'),style: TextStyle(color: AppColors.grey3Color,fontSize: AppStyle.size16,fontFamily: AppStyle.secondaryFont),),),
    body: Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppTranslations.of(context)!.text('creezVotreCompte'),
                style: TextStyle(color: AppColors.primaryBlueColor,fontSize: AppStyle.size28,fontFamily: AppStyle.primaryFont,fontWeight: FontWeight.bold),),
              SizedBox(height: 12,),
              Text(AppTranslations.of(context)!.text('veuillezRemplirLesChamps'),textAlign : TextAlign.center, style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.black1Color,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,height: 1.5),),
              Form(
                  key: registerFormKey,
                  child: Column(
                children: [
                  SizedBox(height: 32,),
                  Row(
                    children: [
                      Expanded(child: AnoirInputComponent(label: 'nom',controller: lastnameController,)),
                      SizedBox(width: 15,),
                      Expanded(child: AnoirInputComponent(label: 'prenoms',controller: firstnameController,)),
                    ],
                  ),
                  SizedBox(height: 16,),
                  // AnoirInputComponent(label: 'username',controller: usernameController,),
                  // SizedBox(height: 16,),
                  AnoirInputComponent(label: 'adresseEmail',controller: emailController,isEmail: true,),
                  SizedBox(height: 16,),
                  AnoirInputComponent(label: 'telephone',controller: phoneController,isPhone: true,
                  ),
                  SizedBox(height: 16,),
                  AnoirInputComponent(label: 'definirMdp',isPassword : true,controller : passwordController),
                  SizedBox(height: 16,),
                  AnoirInputComponent(label: 'confirmerMdp',isPassword : true,controller: confirmPasswordController,),
                  SizedBox(height: 30,),
                  AnoirPrimaryButton(text: 'creerMonCompte', onTap: () async{
                    if(confirmPasswordController.text.trim() != passwordController.text.trim() && passwordController.text.trim().isNotEmpty){
                         FlutterToastr.show(AppTranslations.of(context)!.text('valeursNonIdentiques'), context,backgroundColor: Colors.black,textStyle: TextStyle(color: Colors.white,fontSize: 12));
                    }
                    else{
                      if(registerFormKey.currentState!.validate()){
                        Loader.showLoader(context);
                        User user = User(
                            username : 'NONE',
                            email : emailController.text.trim(),
                            firstname : firstnameController.text.trim(),
                            lastname : lastnameController.text.trim(),
                            phone : phoneController.text.trim().startsWith('+229') ? phoneController.text.trim() : '+229'+ phoneController.text.trim(),
                          password : passwordController.text.trim(),
                        );
                        // ApiResult result = await authController.verifyUserEmail(user.email,user.firstname + ' ' + user.lastname);
                        // Loader.offLoader(context);
                          ApiResult result = await authController.registerUser(user);
                          Loader.offLoader(context);
                          if(result.success){
                            Get.to(()=>SuccessScreen());
                          }
                          else{
                            FlutterToastr.show(AppTranslations.of(context)!.text(result.message), context,backgroundColor: Colors.black,textStyle: TextStyle(color: Colors.white));
                          }
                          // Get.to(()=>VerifyEmailScreen(user : user, code: result.data,));

                      }
                    }
                  })
                ],
              )),
              SizedBox(height: 100,),
              Center(child: Image.asset('assets/png/img_logo.png',height: 60,)),
              SizedBox(height: 50,),

            ],
          ),
        ),

      ],
    ),
    );
  }
}
