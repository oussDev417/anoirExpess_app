import 'package:anoirexpress/components/anoir_input_component.dart';
import 'package:anoirexpress/components/anoir_primary_button.dart';
import 'package:anoirexpress/controllers/UserController.dart';
import 'package:anoirexpress/helpers/helpers.dart';
import 'package:anoirexpress/models/api_result.dart';
import 'package:anoirexpress/screens/reset_password/reset_confirmation_code_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';

import '../../style/colors.dart';
import '../../style/style.dart';
import '../../translations.dart';
import '../../utils/loader.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController phoneController = TextEditingController();
  final phoneKey = GlobalKey<FormState>();
  UserController userController = Get.put(UserController());

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
            Text(AppTranslations.of(context)!.text('motDePasseOublie'),
              style: TextStyle(color: Colors.black,fontSize: AppStyle.size28,fontFamily: AppStyle.primaryFont,fontWeight: FontWeight.bold),),
            SizedBox(height: 12,),
            Text(AppTranslations.of(context)!.text('enterPhoneToReceiveCode'),style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.black1Color,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,height: 1.5),),
            SizedBox(height: 50,),
            SvgPicture.asset('assets/svg/ic_email_envelope.svg'),
            SizedBox(height: 40,),
            Form(
              key: phoneKey,
              child: AnoirInputComponent(isPhone: true,label: 'telephone',controller: phoneController,),),
            SizedBox(height: Helpers.getScreenHeight(context,percent: 0.2),),
            AnoirPrimaryButton(text: 'continuer', onTap: () async {
              if(phoneKey.currentState!.validate()){
                Loader.showLoader(context);
                ApiResult result = await userController.getResetPasswordCode(phoneController.text.trim());
                Loader.offLoader(context);
                if(result.success){
                  FlutterToastr.show(AppTranslations.of(context)!.text('unCodeVousAeteEnvoyeParEmail'), context,backgroundColor: Colors.green,textStyle: TextStyle(color: Colors.white,fontSize: 12));
                  Future.delayed(Duration(seconds: 1),(){
                  Get.to(()=>ResetConfirmationCodeScreen(code : result.data,phone : '+229' + phoneController.text.trim()));
                  });
                }
                else if(result.code == 403){
                    FlutterToastr.show(AppTranslations.of(context)!.text('numeroDeTelephoneIntrouvable'), context,backgroundColor: Colors.red,textStyle: TextStyle(color: Colors.white,fontSize: 12));
                }
                else{
                  FlutterToastr.show(AppTranslations.of(context)!.text('anErrorOccured'), context,backgroundColor: Colors.red,textStyle: TextStyle(color: Colors.white,fontSize: 12));
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
