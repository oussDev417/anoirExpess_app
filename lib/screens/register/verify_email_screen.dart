import 'dart:async';
import 'dart:developer';
import 'package:anoirexpress/controllers/AuthController.dart';
import 'package:anoirexpress/models/user.dart';
import 'package:anoirexpress/screens/reset_password/enter_new_password_screen.dart';
import 'package:anoirexpress/screens/success_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../components/anoir_primary_button.dart';
import '../../helpers/helpers.dart';
import '../../models/api_result.dart';
import '../../style/colors.dart';
import '../../style/style.dart';
import '../../translations.dart';
import '../../utils/loader.dart';

class VerifyEmailScreen extends StatefulWidget {
  int code;
  User user;
  VerifyEmailScreen({required this.code, required this.user});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(7),
    ),
  );
  bool codeIsCorrect = false;
  AuthController authController = Get.find();
  Timer? chronoTimer;
  num timeLeft = 29;


  @override
  void initState() {
    log(widget.code.toString());
    launchChrono();
    super.initState();
  }

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
            Text(AppTranslations.of(context)!.text('verificationDemail'),
              style: TextStyle(color: Colors.black,fontSize: AppStyle.size28,fontFamily: AppStyle.primaryFont,fontWeight: FontWeight.bold),),
            SizedBox(height: 12,),
            Text(AppTranslations.of(context)!.text('veuillezEntrerLeCodeRecuSurVotreEmail'),style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.black1Color,fontSize: AppStyle.size16,fontWeight: FontWeight.w400,height: 1.5),),
            SizedBox(height: 50,),
            // SvgPicture.asset('assets/svg/ic_email_envelope.svg',height: 50,),
            // SizedBox(height: 50,),
            Pinput(
              length : 5,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: defaultPinTheme.copyDecorationWith(
                border: Border.all(color: AppColors.primaryBlueColor),
                borderRadius: BorderRadius.circular(7),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                textStyle: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),
                decoration: defaultPinTheme.decoration!.copyWith(
                    color: AppColors.primaryBlueColor,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: Colors.transparent)
                ),
              ),
              onChanged : (str){
                if(str.length != 5 || str != widget.code.toString()){
                  setState(() {
                    codeIsCorrect = false;
                  });
                }
              },
              validator: (s) {
                if(s==widget.code.toString()){
                  setState(() {
                    codeIsCorrect = true;
                  });
                  return null;
                }
                else{
                  setState(() {
                    codeIsCorrect = false;
                  });
                  return 'Code incorrect !';
                }
              },
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onCompleted: (pin) => print(pin),
            ),
            SizedBox(height: 10,),
            buildResendCodeSection(),
            SizedBox(height: 40,),
            SizedBox(height: Helpers.getScreenHeight(context,percent: 0.2),),
            AnoirPrimaryButton(text: 'creerMonCompte', onTap: () async {
                if(codeIsCorrect){
                  Loader.showLoader(context);
                  ApiResult result = await authController.registerUser(widget.user);
                  Loader.offLoader(context);
                  if(result.success){
                    Get.to(()=>SuccessScreen());
                  }
                  else{
                    FlutterToastr.show(AppTranslations.of(context)!.text(result.message), context,backgroundColor: Colors.black,textStyle: TextStyle(color: Colors.white));
                  }
                }
                else{
                  FlutterToastr.show(AppTranslations.of(context)!.text('codeIncorrect'), context,backgroundColor: Colors.red,textStyle: TextStyle(color: Colors.white));
                }

            }),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }

  buildResendCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(AppTranslations.of(context)!.text('aucunCodeRecu'),style: TextStyle(fontFamily: AppStyle.secondaryFont,color: AppColors.black1Color,fontSize: AppStyle.size12,fontWeight: FontWeight.w400,height: 1.5),),
            SizedBox(width: 4,),
            Container(padding: EdgeInsets.symmetric(horizontal: 8,vertical: 3),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: AppColors.primaryRedColor),
            child:   Text(
            '00:${timeLeft.toString().length == 1 ? '0' + timeLeft.toString(): timeLeft}',
            textAlign: TextAlign.center,
            style: TextStyle(
            fontFamily: AppStyle.secondaryFont,
            fontSize: AppStyle.size10,
            color: Colors.white,
            fontWeight: FontWeight.w400),
        )),

          ],
        ),
    SizedBox(height: 5,),
        timeLeft != 0 ? SizedBox() : TextButton(onPressed: () async {
          launchChrono();
          ApiResult result = await authController.verifyUserEmail(widget.user.email,widget.user.firstname + ' ' + widget.user.lastname);
          setState(() {
            widget.code = result.code;
          });
          }, child: Text(
      AppTranslations.of(context)!.text('resend'),
      textAlign: TextAlign.center,
      style: TextStyle(
      fontFamily: AppStyle.secondaryFont,
      fontSize: AppStyle.size12,
      color: Colors.black,
      fontWeight: FontWeight.w400),
      )),
      ],
    );
  }

  void launchChrono() {
    chronoTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft = 30 - timer.tick.seconds.inSeconds;
      });
      if(timeLeft < 0){
        setState(() {
          timeLeft = 0;
        });
        chronoTimer!.cancel();
      }
    });
  }
}
