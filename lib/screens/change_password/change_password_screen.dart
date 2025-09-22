
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../components/anoir_input_component.dart';
import '../../components/anoir_primary_button.dart';
import '../../controllers/UserController.dart';
import '../../helpers/helpers.dart';
import '../../models/api_result.dart';
import '../../style/colors.dart';
import '../../style/style.dart';
import '../../translations.dart';
import '../../utils/loader.dart';

class ChangePasswordScreen extends StatelessWidget {

  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final passKey = GlobalKey<FormState>();
  UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back,color: Colors.black.withOpacity(0.9),)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppTranslations.of(context)!.text('changerMotDePasse'),
              style: TextStyle(color: Colors.black,fontSize: AppStyle.size28,fontFamily: AppStyle.primaryFont,fontWeight: FontWeight.bold),),
            SizedBox(height: 12,),
            Text(AppTranslations.of(context)!.text('recreerVotreNouveauMotDePasse'),style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.black1Color,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,height: 1.5),),
            SizedBox(height: 50,),
            Form(
              key: passKey,
              child: Column(
                children: [
                  AnoirInputComponent(isPassword: true,label: 'motDePasseActuel',controller: passwordController,),
                  SizedBox(height: 16,),
                  AnoirInputComponent(isPassword: true,label: 'definirNouveauMotDePasse',controller: newPasswordController,),
                  SizedBox(height: 16,),
                  AnoirInputComponent(isPassword: true,label: 'confirmerNouveauMotDePasse',controller: confirmPasswordController,),
                ],
              ),),
            SizedBox(height: Helpers.getScreenHeight(context,percent: 0.2),),
            AnoirPrimaryButton(text: 'enregistrer', onTap: () async {
              if(passKey.currentState!.validate()){
                if(confirmPasswordController.text.trim().isNotEmpty && newPasswordController.text.trim() == confirmPasswordController.text.trim()){
                  Loader.showLoader(context);
                  ApiResult result = await userController.updatePassword(passwordController.text.trim(),newPasswordController.text.trim());
                  Loader.offLoader(context);
                  if(result.success){
                    FlutterToastr.show(AppTranslations.of(context)!.text('miseAjourReussie'), context,backgroundColor: Colors.green,textStyle: TextStyle(color: Colors.white,fontSize: 12));
                    Get.back();
                  }
                  else{
                    if(result.code == 400){
                      FlutterToastr.show(AppTranslations.of(context)!.text('mauvaisMotDePasseActuel'), context,backgroundColor: Colors.red,textStyle: TextStyle(color: Colors.white,fontSize: 12));
                    }
                    else{
                      FlutterToastr.show(AppTranslations.of(context)!.text('anErrorOccured'), context,backgroundColor: Colors.red,textStyle: TextStyle(color: Colors.white,fontSize: 12));
                    }
                  }
                }
                else{
                  FlutterToastr.show(AppTranslations.of(context)!.text('valeursNonIdentiques'), context,backgroundColor: Colors.red,textStyle: TextStyle(color: Colors.white,fontSize: 12));
                }
              }
            }),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}