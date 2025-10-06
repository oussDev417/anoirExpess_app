import 'dart:async';
import 'dart:developer';

import 'package:anoirexpress/components/anoir_engine_choice.dart';
import 'package:anoirexpress/components/anoir_primary_button.dart';
import 'package:anoirexpress/controllers/CommandController.dart';
import 'package:anoirexpress/models/course.dart';
import 'package:anoirexpress/screens/main_screens/home_screen.dart';
import 'package:anoirexpress/screens/research_deliver_result.dart';
import 'package:anoirexpress/services/command_service.dart';
import 'package:anoirexpress/style/colors.dart';
import 'package:anoirexpress/translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../helpers/helpers.dart';
import '../style/style.dart';

class ResearchDeliverScreen extends StatefulWidget {
 Course course;
 ResearchDeliverScreen({required this.course});
  @override
  State<ResearchDeliverScreen> createState() => _ResearchDeliverScreenState();
}

class _ResearchDeliverScreenState extends State<ResearchDeliverScreen> {
  CommandController commandController = Get.find();
  bool researchIsOver = false;
  num timeLeft = 9;
  Timer? chronoTimer;
  Timer? checkTimer;

  checkStatus(){
    checkTimer = Timer.periodic(Duration(seconds: 4),(timer) async {
      CommandService commandService = CommandService();
      Course? c = await commandService.getCourseById(widget.course.id);
      if(c != null){
        if(c!.status == 'ACCEPTED'){
          Get.offAll(()=>ResearchDeliverResult(course : widget.course));
        }
      }
    });
  }

  startChrono(){
    if(mounted) {
      Future.delayed(Duration(seconds: 15),(){
        setState(() {
          researchIsOver = true;
        });
        //WAIT 10S
        chronoTimer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            timeLeft = 10 - timer.tick.seconds.inSeconds;
          });
          if(timeLeft == 0){
            Get.offAll(()=>HomeScreen());
          }
          else if(timeLeft < 0){
            setState(() {
              timeLeft = 0;
            });
          }
        });
      });
    }
  }

  @override
  void initState() {
    log('--- in researchDeliverScreen - ');
    startChrono();
    log('--- chrono started- ');
    checkStatus();
    log('--- check status- ');
    super.initState();
  }

  @override
  void dispose() {
    chronoTimer!.cancel();
    checkTimer!.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommandController>(
      builder: (commandController) {
        return PopScope(
          canPop: false,
            onPopInvoked : (wantPop){
              log('WANT POP');
            },
          child: Scaffold(
            backgroundColor: AppColors.primaryBlueColor,
            appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0,leading: SizedBox(),),
            // appBar: AppBar(leading: SizedBox(),backgroundColor: Colors.white10,elevation: 0,),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppTranslations.of(context)!.text('researchInProgress'),
                  style: TextStyle(
                      fontFamily: AppStyle.secondaryFont,
                      fontSize: AppStyle.size14,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 50,),
                Center(
                  child: GestureDetector(
                    onTap: (){
                      Get.offAll(()=>ResearchDeliverResult(course : widget.course));
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primaryBlueColor.withOpacity(0.04),
                          child: SvgPicture.asset('assets/svg/ic_deliver.svg'),
                        ),
                        Container(
                            height : 120,
                            width : 120, child: CircularProgressIndicator(color: Colors.white,)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Helpers.getScreenHeight(context,percent: 0.25),),
                researchIsOver ? buildResearchIsOver(context) : buildResearchInProgress(context)
              ],
            ),
          ),
          ),
        );
      }
    );
  }

  void cancelResearchAlert(BuildContext context) {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context){
      return AlertDialog(
        actionsPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
        alignment: Alignment.center,
        content: Container(
          height: 120,
          child: Column(
            children: [
              Text(
                AppTranslations.of(context)!.text('confirmerAnnuler'),
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size14,
                    height: 1.5,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 35,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: (){
                      Get.offAll(()=>HomeScreen());
                    },
                    child: Container(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                        color: AppColors.primaryRedColor.withOpacity(0.9),
                      ),
                      child: Text(
                        AppTranslations.of(context)!.text('cancel'),
                        style: TextStyle(
                            fontFamily: AppStyle.secondaryFont,
                            color: Colors.white,
                            fontSize: AppStyle.size14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Get.back();
                    },
                    child: Container(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                        color: AppColors.primaryBlueColor.withOpacity(0.9),
                      ),
                      child: Text(
                        AppTranslations.of(context)!.text('continuer'),
                        style: TextStyle(
                            fontFamily: AppStyle.secondaryFont,
                            fontSize: AppStyle.size14,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
      );
    });
  }

  buildResearchInProgress(context){
    return Column(
      children: [
        Container(padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),width: Helpers.getScreenWidth(context),
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),color: AppColors.blue2Color),
          child:  Center(
            child: Text(
              AppTranslations.of(context)!.text('livraisonPar'),
              style: TextStyle(
                  fontFamily: AppStyle.secondaryFont,
                  fontSize: AppStyle.size16,
                  color: AppColors.primaryBlueColor,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        Container(padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),width: Helpers.getScreenWidth(context),
          decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),color: Colors.white),
          child: AnoirEngineChoice(
            engineType: widget.course.engineType,
            price: widget.course.price,
            canChoose: false,),
        ),
        SizedBox(height: 50,),
        GestureDetector(
          onTap: (){
            cancelResearchAlert(context);
          },
          child: Container(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
              color: Colors.white.withOpacity(0.06),
            ),
            child: Text(
              AppTranslations.of(context)!.text('cancelResearch'),
              style: TextStyle(
                  fontFamily: AppStyle.secondaryFont,
                  fontSize: AppStyle.size14,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }
  buildResearchIsOver(context){
    return Column(
      children: [
        Container(padding: EdgeInsets.all(20),width: Helpers.getScreenWidth(context),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
          child: Column(
            children: [
              Text(
                AppTranslations.of(context)!.text('laRechercheEstEnCoursVousSerezNotifiez'),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size14,
                    height: 1.5,
                    color: AppColors.black2Color,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 30,),
              AnoirPrimaryButton(text: 'daccord', onTap: (){
                Get.offAll(()=>HomeScreen());
              }),
            ],
          ),
        ),
        SizedBox(height: 30,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppTranslations.of(context)!.text('backToHomeIn'),
              style: TextStyle(
                  fontFamily: AppStyle.secondaryFont,
                  fontSize: AppStyle.size14,
                  height: 1.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(width: 10,),
            Container(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: AppColors.primaryRedColor),
              child:   Text(
                 '00:0${timeLeft}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size12,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
            ),

          ],
        ),
      ],
    );
  }
}
