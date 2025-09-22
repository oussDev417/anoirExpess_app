import 'dart:developer';
import 'package:anoirexpress/components/anoir_engine_choice.dart';
import 'package:anoirexpress/controllers/CommandController.dart';
import 'package:anoirexpress/controllers/UserController.dart';
import 'package:anoirexpress/models/colis_type.dart';
import 'package:anoirexpress/screens/research_deliver_screen.dart';
import 'package:anoirexpress/style/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';
import '../components/anoir_input_component.dart';
import '../components/anoir_primary_appbar.dart';
import '../components/anoir_primary_button.dart';
import '../helpers/helpers.dart';
import '../models/course.dart';
import '../style/style.dart';
import '../translations.dart';
import '../utils/loader.dart';

class TransportPeopleScreen extends StatefulWidget {
  bool? isReceive;
  TransportPeopleScreen({this.isReceive = false});

  @override
  State<TransportPeopleScreen> createState() => _TransportPeopleScreenState();
}

class _TransportPeopleScreenState extends State<TransportPeopleScreen> {
 CommandController commandController = Get.put(CommandController());
 int currentStep = 0;
 final transportPeopleFormKey = GlobalKey<FormState>();
 TextEditingController departureController = TextEditingController();
 TextEditingController destinationController = TextEditingController();
 TextEditingController passengersNumberController = TextEditingController();
 TextEditingController descriptionController = TextEditingController();
 UserController userController = Get.find();
 List<dynamic> estimations = [];


 // getColisTypes() async {
 //   await commandController.getColisTypes();
 //   setState(() {
 //     colisType = commandController.colisTypes.first;
 //   });
 // }


 @override
  void initState() {
   // getColisTypes();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommandController>(
      builder: (commandController) {
        return Scaffold(
          appBar: AnoirPrimaryAppbar(
            title: 'transportDePersonnes' ,
            onPop : (){
                Get.back();
            }
          ),
          body: commandController.isLoading ? Container(height: Helpers.getScreenHeight(context),child: Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlueColor,),
          ),) :  IndexedStack(
            index: currentStep,
            children: [
              buildStep1Form() ,
              buildStep2Form(),
            ],
          )
        );
      }
    );
  }


  showEngineChoiceModal(List estimations, Function() onUpdate) async {
    showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(minHeight: Helpers.getScreenHeight(context,percent: 0.6),maxHeight: Helpers.getScreenHeight(context,percent: 0.85)),
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        builder: (context) {
          return GetBuilder<CommandController>(
            builder: (commandController) {
              return StatefulBuilder(
                builder: (BuildContext context2, void Function(void Function()) setState) {
                  return Container(
                    padding: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                AppTranslations.of(context)!.text('moyenDeTransport'),
                                style: TextStyle(
                                    fontFamily: AppStyle.primaryFont,
                                    fontSize: AppStyle.size22,
                                    fontWeight: FontWeight.w700),
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            AppTranslations.of(context)!
                                .text('choisissezUnMoyenDeTransport'),
                            style: TextStyle(
                                fontFamily: AppStyle.secondaryFont,
                                color: AppColors.black1Color,
                                fontSize: AppStyle.size16,
                                fontWeight: FontWeight.w400,
                                height: 1.5),
                          ),
                          SizedBox(height: 20,),
                          ...List.generate(commandController.enginesAssets.length, (index) =>

                   estimations.firstWhereOrNull((element) => element['engin'].toString().toUpperCase() == (commandController.enginesAssets[index]['type'].toString().toUpperCase())) == null ? SizedBox() :
                              GestureDetector(
                            onTap: (){
                              // log(commandController.enginesAssets[index]['type']);
                              commandController.updateEngineChoice(commandController.enginesAssets[index]['type'].toString().toUpperCase(),(estimations.firstWhere((element) => element['engin'].toString().toUpperCase() == (commandController.enginesAssets[index]['type'].toString().toUpperCase())))['estimation']);
                            },
                            child: AnoirEngineChoice(engineType: commandController.enginesAssets[index]['type'].toString().toUpperCase(), price: (estimations.firstWhere((element) => element['engin'].toString().toUpperCase() == (commandController.enginesAssets[index]['type'].toString().toUpperCase())))['estimation'],),
                          )),
                          SizedBox(height: 20,),
                          AnoirPrimaryButton(text: 'continuer', onTap: () {
                              onUpdate();
                          }),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          );
        });
  }

  buildStep1Form() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Form(
        key: transportPeopleFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppTranslations.of(context)!.text('detailsDeLaCourse'),
              style: TextStyle(
                  fontFamily: AppStyle.primaryFont,
                  fontSize: AppStyle.size22,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 20,
            ),
            AnoirInputComponent(
              label: 'lieuDeDepart',
              controller: departureController,
            ),
            SizedBox(
              height: 16,
            ),
            AnoirInputComponent(
              label: 'lieuDarrivee',
              controller: destinationController,
            ),
            SizedBox(
              height: 16,
            ),
            AnoirInputComponent(
              label: 'nombreDePassagers',
              controller: passengersNumberController,
              isNumber: true,
            ),
            SizedBox(
              height: 16,
            ),
            AnoirInputComponent(
                label: 'ajouterPlusDePrecisions',
                isDescription: true,
                isRequired : false,
                controller: descriptionController,
            ),
            SizedBox(
              height: 40,
            ),
            AnoirPrimaryButton(
                text: 'continuer',
                onTap: () async {
                  if(transportPeopleFormKey.currentState!.validate()){
                    Loader.showLoader(context);
                    estimations = await commandController.evaluateCourse('TRANSPORT DE PERSONNES');
                    setState(() {});
                    // List<Map<String,dynamic>> estimations  = json.decode(estim);
                    log('----');
                    log('ESTIMATIONS $estimations');
                    if(estimations.isEmpty){
                      estimations = await commandController.evaluateCourse('TRANSPORT DE PERSONNES');
                      setState(() {});
                    }
                    Loader.offLoader(context);
                    showEngineChoiceModal(estimations,(){
                      if(currentStep < 1){
                        setState(() {
                          currentStep = currentStep + 1;
                        });
                        Get.back();
                      }
                    });
                  }
                }
                ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  buildStep2Form() {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTranslations.of(context)!.text('confirmerLaCourse'),
                style: TextStyle(
                    fontFamily: AppStyle.primaryFont,
                    fontSize: AppStyle.size22,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                AppTranslations.of(context)!.text('lieuDeDepart'),
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size16,
                    color: AppColors.black1Color,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10,),
              Text(
                departureController.text.trim(),
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size16,
                    color: AppColors.black1Color,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                AppTranslations.of(context)!.text('lieuDarrivee'),
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size16,
                    color: AppColors.black1Color,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10,),
              Text(
                destinationController.text.trim(),
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size16,
                    color: AppColors.black1Color,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                AppTranslations.of(context)!.text('moyenDeTransport'),
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size16,
                    color: AppColors.black1Color,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10,),
              Text(
                commandController.engineChoice,
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size16,
                    color: AppColors.black1Color,
                    fontWeight: FontWeight.w400),
              ),

              SizedBox(
                height: 20,
              ),
              Text(
                AppTranslations.of(context)!.text('prix'),
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size16,
                    color: AppColors.black1Color,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10,),
              Text(
                estimations.length == 0 ? '' : estimations.firstWhere((element) => element['engin'].toString().toUpperCase() == commandController.engineChoice.toUpperCase())['estimation'].toString() + 'FCFA',
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size16,
                    color: AppColors.black1Color,
                    fontWeight: FontWeight.w400),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppTranslations.of(context)!.text('nombreDePassagers'),
                    style: TextStyle(
                        fontFamily: AppStyle.secondaryFont,
                        fontSize: AppStyle.size16,
                        color: AppColors.black1Color,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    passengersNumberController.text.trim(),
                    style: TextStyle(
                        fontFamily: AppStyle.secondaryFont,
                        fontSize: AppStyle.size16,
                        color: AppColors.black1Color,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              descriptionController.text.trim().length > 0 ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppTranslations.of(context)!.text('description'),
                    style: TextStyle(
                        fontFamily: AppStyle.secondaryFont,
                        fontSize: AppStyle.size16,
                        color: AppColors.black1Color,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    descriptionController.text.trim(),
                    style: TextStyle(
                        fontFamily: AppStyle.secondaryFont,
                        fontSize: AppStyle.size16,
                        color: AppColors.black1Color,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ) : SizedBox()


              //----------------------
              // Text(
              //   AppTranslations.of(context)!.text('intantanementOuProgramme'),
              //   style: TextStyle(
              //       fontFamily: AppStyle.secondaryFont,
              //       fontSize: AppStyle.size16,
              //       height: 1.5,
              //       color: AppColors.black1Color,
              //       fontWeight: FontWeight.w400),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   padding: EdgeInsets.all(10),
              //   decoration: BoxDecoration(border: Border.all(color: AppColors.primaryRedColor,),borderRadius: BorderRadius.circular(8)),
              //  child: Row(
              //    children: [
              //      SvgPicture.asset('assets/svg/ic_map.svg'),
              //      SizedBox(width: 20,),
              //      Text(
              //        AppTranslations.of(context)!.text('intantane'),
              //        style: TextStyle(
              //            fontFamily: AppStyle.secondaryFont,
              //            fontSize: AppStyle.size16,
              //            color: AppColors.black1Color,
              //            fontWeight: FontWeight.w400),
              //      ),
              //      Spacer(),
              //      SvgPicture.asset('assets/svg/ic_radio_checked.svg')
              //
              //    ],
              //  ),
              // )
              //----------------------
            ],
          ),
        ),
        Align(alignment: Alignment.bottomCenter,child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 100,
          width: Helpers.getScreenWidth(context),
          child:  Row(
            children: [
              GestureDetector(
                onTap: (){
                  setState(() {
                    currentStep--;
                  });
                },
                child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(child: Text(AppTranslations.of(context)!.text('retour'),textAlign:TextAlign.center,style: TextStyle(fontFamily: AppStyle.secondaryFont,fontSize: AppStyle.size16,fontWeight: FontWeight.w500),))),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: AnoirPrimaryButton(text: 'rechercherUnConducteur',
                  textStyle: TextStyle(fontSize: AppStyle.size14,color: Colors.white,fontFamily: AppStyle.primaryFont,fontWeight: FontWeight.bold),
                  onTap: () async {
                  try{
                    if(userController.currentUser == null){
                      log('USR NULL');
                    }
                    log(userController.currentUser != null ? userController.currentUser!.id! : 'nullii');
                    log('GET ESTIMATIONS $estimations');
                    Course course = Course(colisType: 'TRANSPORT DE PERSONNES',
                        authorId: userController.currentUser!.id!,
                        type : 'PERSON_TRANSPORTATION',
                        description: descriptionController.text.trim(),
                        price: estimations.firstWhere((element) => element['engin'].toString().toUpperCase() == commandController.engineChoice.toUpperCase())['estimation'],
                        departure: departureController.text.trim(), destination: destinationController.text.trim(),
                        engineType: commandController.engineChoice,
                        passengersNumber: int.parse(passengersNumberController.text.trim()));
                    log(course.toJson().toString());
                    Loader.showLoader(context);
                    bool result = await commandController.createCourse(course);
                    if(result){
                      Loader.offLoader(context);
                      FlutterToastr.show(AppTranslations.of(context)!.text('courseEnregistree'), context,backgroundColor: AppColors.primaryBlueColor,textStyle: TextStyle(color: Colors.white,fontSize: 12));
                      Get.to(()=>ResearchDeliverScreen(course : course));
                    }
                    else{
                      Loader.offLoader(context);
                      FlutterToastr.show(AppTranslations.of(context)!.text('impossibleDenregistrerLaCourse'), context,backgroundColor: Colors.black,textStyle: TextStyle(color: Colors.white,fontSize: 12));
                    }
                  }
                  catch(e){
                    log(e.toString());
                  }
                },),
              ),
            ],
          ),
        ),)
      ],
    );
  }

}

