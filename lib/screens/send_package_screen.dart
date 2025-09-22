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
/*
class SendPackageScreen extends StatefulWidget {
  bool? isReceive;
  SendPackageScreen({this.isReceive = false});

  @override
  State<SendPackageScreen> createState() => _SendPackageScreenState();
}

class _SendPackageScreenState extends State<SendPackageScreen> {
 CommandController commandController = Get.put(CommandController());
 int currentStep = 0;
 final sendPackageFormKey = GlobalKey<FormState>();
 TextEditingController departureController = TextEditingController();
 TextEditingController destinationController = TextEditingController();
 TextEditingController recipientPhoneController = TextEditingController();
 TextEditingController descriptionController = TextEditingController();
 ColisType? colisType;
 UserController userController = Get.find();
 List<dynamic> estimations = [];
 bool colisIsFragile = false;


 getColisTypes() async {
   await commandController.getColisTypes();
   setState(() {
     colisType = commandController.colisTypes.first;
   });
 }


 @override
  void initState() {
   getColisTypes();
   super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommandController>(
      builder: (commandController) {
        return Scaffold(
          appBar: AnoirPrimaryAppbar(
            showSteps: true,
            currentStep: currentStep + 1,
            totalSteps: 2,
            title: widget.isReceive! ? 'recevoirUnColis' : 'envoyerUnColis',
            onPop : (){
              if(currentStep == 1){
                setState(() {
                  currentStep--;
                });
              }
              else{
                Get.back();
              }
            }
          ),
          body: commandController.isLoading   ? Container(height: Helpers.getScreenHeight(context),child: Center(
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
        key: sendPackageFormKey,
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
              label: 'lieuDeDepartDuColis',
              controller: departureController,
            ),
            SizedBox(
              height: 16,
            ),
            AnoirInputComponent(
              label: 'lieuDarriveeDuColis',
              controller: destinationController,
            ),
            SizedBox(
              height: 16,
            ),
            AnoirInputComponent(
              label: 'numeroDuDestinataire',
              controller: recipientPhoneController,
              isPhone: true,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              AppTranslations.of(context)!.text('colis'),
              style: TextStyle(
                  fontFamily: AppStyle.primaryFont,
                  fontSize: AppStyle.size22,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 20,
            ),
            Container(height: 50,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),border: Border.all(color: AppColors.grey4Color)),
            child: Center(
              child: DropdownButton<ColisType>(
                isExpanded: true,
                underline: SizedBox(),
                value: colisType,
                items: [
                  ...List.generate(commandController.colisTypes.length, (index) =>
                      DropdownMenuItem(child: Text(commandController.colisTypes[index].name),
                        value: commandController.colisTypes[index],
                        onTap: (){
                        setState(() {
                          colisType = commandController.colisTypes[index];
                        });
                      },)
                      ),
                ],
               onChanged: (ColisType? value) {
                setState(() {
                    colisType = value!;
                });
              },
              ),
            ),),
            SizedBox(
              height: 16,
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.grey2Color
              ),
              child: Row(
                children: [
                  Expanded(child: Text(AppTranslations.of(context)!.text('leColisEstIlFragile'),style: TextStyle(color: Colors.black,fontSize: AppStyle.size14,fontWeight: FontWeight.w600,fontFamily: AppStyle.primaryFont),)),
                  SizedBox(width: 20,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        colisIsFragile = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: !colisIsFragile ? Colors.black : Colors.white,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                      child: Text(AppTranslations.of(context)!.text('non'),style: TextStyle(color: !colisIsFragile ? Colors.white : Colors.black,fontSize: AppStyle.size12,fontWeight: FontWeight.w600,fontFamily: AppStyle.primaryFont),),
                    ),
                  ),
                  SizedBox(width: 6,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        colisIsFragile = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: colisIsFragile ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                      child: Text(AppTranslations.of(context)!.text('oui'),style: TextStyle(color: colisIsFragile ? Colors.white : Colors.black,fontSize: AppStyle.size12,fontWeight: FontWeight.w600,fontFamily: AppStyle.primaryFont),),
                    ),
                  ),
                ],
              ),
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
                  if(sendPackageFormKey.currentState!.validate() && colisType != null){
                    Loader.showLoader(context);
                    estimations = await commandController.evaluateCourse(colisType!.name);
                    setState(() {});
                    // List<Map<String,dynamic>> estimations  = json.decode(estim);
                    log('----');
                    log('ESTIMATIONS $estimations');
                    if(estimations.isEmpty){
                      estimations = await commandController.evaluateCourse(colisType!.name);
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
            ),]
        )));
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
                AppTranslations.of(context)!.text('typeDeColis'),
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size16,
                    color: AppColors.black1Color,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10,),
              Text(
                colisType!.name + ' (${colisIsFragile ? 'FRAGILE' : 'NON FRAGILE'})',
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
                    AppTranslations.of(context)!.text('numeroDuDestinataire'),
                    style: TextStyle(
                        fontFamily: AppStyle.secondaryFont,
                        fontSize: AppStyle.size16,
                        color: AppColors.black1Color,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    recipientPhoneController.text.trim(),
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



              // colisType: colisType!.name,
              // authorId: userController.currentUser!.id!,
              // type : widget.isReceive != null &&  widget.isReceive! ? 'RECEPTION' : 'DELIVERY',
              // description: descriptionController.text.trim(),
              // price: estimations.firstWhere((element) => element['engin'].toString().toUpperCase() == commandController.engineChoice.toUpperCase())['estimation'],
              // departure: departureController.text.trim(), destination: destinationController.text.trim(),
              // engineType: commandController.engineChoice,
              // recipientPhone: recipientPhoneController.text.trim()
              // SizedBox(
              //   height: 20,
              // ),


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
              SizedBox(width: 20,),
              Expanded(
                child: AnoirPrimaryButton(text: 'rechercherUnLivreur', onTap: () async {
                  try{
                    if(userController.currentUser == null){
                      log('USR NULL');
                    }
                    log(userController.currentUser != null ? userController.currentUser!.id! : 'nullii');
                    log(colisType.toString());
                    log('GET ESTIMATIONS $estimations');
                    Course course = Course(colisType: colisType!.name,
                        authorId: userController.currentUser!.id ?? '',
                        type : widget.isReceive != null &&  widget.isReceive! ? 'RECEPTION' : 'DELIVERY',
                        description: descriptionController.text.trim(),
                        isFragile: colisIsFragile,
                        price: estimations.firstWhere((element) => element['engin'].toString().toUpperCase() == commandController.engineChoice.toUpperCase())['estimation'],
                        departure: departureController.text.trim(), destination: destinationController.text.trim(),
                        engineType: commandController.engineChoice,
                        recipientPhone: recipientPhoneController.text.trim());
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

*/


class SendPackageScreen extends StatefulWidget {
  final bool? isReceive;
  SendPackageScreen({this.isReceive = false});

  @override
  State<SendPackageScreen> createState() => _SendPackageScreenState();
}

class _SendPackageScreenState extends State<SendPackageScreen> {
  CommandController commandController = Get.put(CommandController());
  UserController userController = Get.find();

  int currentStep = 0;
  final sendPackageFormKey = GlobalKey<FormState>();

  TextEditingController departureController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController recipientPhoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  ColisType? colisType;
  List<dynamic> estimations = [];
  bool colisIsFragile = false;

  @override
  void initState() {
    super.initState();
    getColisTypes();
  }

  getColisTypes() async {
    await commandController.getColisTypes();
    if (commandController.colisTypes.isNotEmpty) {
      setState(() {
        colisType = commandController.colisTypes.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommandController>(
      builder: (_) {
        return Scaffold(
          appBar: AnoirPrimaryAppbar(
            showSteps: true,
            currentStep: currentStep + 1,
            totalSteps: 2,
            title: widget.isReceive == true
                ? 'recevoirUnColis'
                : 'envoyerUnColis',
            onPop: () {
              if (currentStep > 0) {
                setState(() => currentStep--);
              } else {
                Get.back();
              }
            },
          ),
          body: commandController.isLoading
              ? Container(
            height: Helpers.getScreenHeight(context),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryBlueColor,
              ),
            ),
          )
              : IndexedStack(
            index: currentStep,
            children: [
              buildStep1Form(),
              buildStep2Form(),
            ],
          ),
        );
      },
    );
  }

  showEngineChoiceModal(List estimations, Function() onUpdate) async {
    showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
        minHeight: Helpers.getScreenHeight(context, percent: 0.6),
        maxHeight: Helpers.getScreenHeight(context, percent: 0.85),
      ),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context2, setModalState) {
            return Container(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          AppTranslations.of(context)!
                              .text('moyenDeTransport'),
                          style: TextStyle(
                              fontFamily: AppStyle.primaryFont,
                              fontSize: AppStyle.size22,
                              fontWeight: FontWeight.w700),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(Icons.close))
                      ],
                    ),
                    SizedBox(height: 12),
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
                    SizedBox(height: 20),
                    ...List.generate(commandController.enginesAssets.length,
                            (index) {
                          final engineType = commandController.enginesAssets[index]
                          ['type']
                              .toString()
                              .toUpperCase();
                          final estimation = estimations.firstWhereOrNull(
                                  (e) => e['engin'].toString().toUpperCase() == engineType);

                          if (estimation == null) return SizedBox();
                          return GestureDetector(
                            onTap: () {
                              commandController.updateEngineChoice(
                                  engineType, estimation['estimation']);
                            },
                            child: AnoirEngineChoice(
                              engineType: engineType,
                              price: estimation['estimation'],
                            ),
                          );
                        }),
                    SizedBox(height: 20),
                    AnoirPrimaryButton(
                      text: 'continuer',
                      onTap: onUpdate,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  buildStep1Form() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Form(
        key: sendPackageFormKey,
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
            SizedBox(height: 20),
            AnoirInputComponent(
              label: 'lieuDeDepartDuColis',
              controller: departureController,
            ),
            SizedBox(height: 16),
            AnoirInputComponent(
              label: 'lieuDarriveeDuColis',
              controller: destinationController,
            ),
            SizedBox(height: 16),
            AnoirInputComponent(
              label: 'numeroDuDestinataire',
              controller: recipientPhoneController,
              isPhone: true,
            ),
            SizedBox(height: 40),
            Text(
              AppTranslations.of(context)!.text('colis'),
              style: TextStyle(
                  fontFamily: AppStyle.primaryFont,
                  fontSize: AppStyle.size22,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 20),
            if (commandController.colisTypes.isNotEmpty)
              Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.grey4Color)),
                child: Center(
                  child: DropdownButton<ColisType>(
                    isExpanded: true,
                    underline: SizedBox(),
                    value: colisType,
                    items: commandController.colisTypes
                        .map((c) => DropdownMenuItem<ColisType>(
                      value: c,
                      child: Text(c.name),
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        colisType = value;
                      });
                    },
                  ),
                ),
              ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.grey2Color),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppTranslations.of(context)!
                          .text('leColisEstIlFragile'),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: AppStyle.size14,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppStyle.primaryFont),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () => setState(() => colisIsFragile = false),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: !colisIsFragile ? Colors.black : Colors.white,
                      ),
                      padding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: Text(
                        AppTranslations.of(context)!.text('non'),
                        style: TextStyle(
                            color: !colisIsFragile ? Colors.white : Colors.black,
                            fontSize: AppStyle.size12,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppStyle.primaryFont),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => setState(() => colisIsFragile = true),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colisIsFragile ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      child: Text(
                        AppTranslations.of(context)!.text('oui'),
                        style: TextStyle(
                            color: colisIsFragile ? Colors.white : Colors.black,
                            fontSize: AppStyle.size12,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppStyle.primaryFont),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            AnoirInputComponent(
              label: 'ajouterPlusDePrecisions',
              isDescription: true,
              isRequired: false,
              controller: descriptionController,
            ),
            SizedBox(height: 40),
            AnoirPrimaryButton(
              text: 'continuer',
              onTap: () async {
                if (sendPackageFormKey.currentState?.validate() == true &&
                    colisType != null) {
                  Loader.showLoader(context);
                  estimations = await commandController.evaluateCourse(
                      colisType!.name);
                  Loader.offLoader(context);
                  showEngineChoiceModal(estimations, () {
                    if (currentStep < 1) {
                      setState(() => currentStep++);
                      Get.back();
                    }
                  });
                }
              },
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  buildStep2Form() {
    final selectedColisType = colisType;
    final currentUserId = userController.currentUser?.id ?? '';

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
              SizedBox(height: 20),
              if (selectedColisType != null)
                Text(
                  '${selectedColisType.name} (${colisIsFragile ? 'FRAGILE' : 'NON FRAGILE'})',
                  style: TextStyle(
                      fontFamily: AppStyle.secondaryFont,
                      fontSize: AppStyle.size16,
                      color: AppColors.black1Color,
                      fontWeight: FontWeight.w400),
                ),
              SizedBox(height: 20),
              Text(
                AppTranslations.of(context)!.text('moyenDeTransport'),
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size16,
                    color: AppColors.black1Color,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Text(
                commandController.engineChoice,
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size16,
                    color: AppColors.black1Color,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 20),
              Text(
                AppTranslations.of(context)!.text('prix'),
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size16,
                    color: AppColors.black1Color,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),
              Text(
                estimations.isEmpty
                    ? ''
                    : estimations
                    .firstWhereOrNull((e) =>
                e['engin'].toString().toUpperCase() ==
                    commandController.engineChoice.toUpperCase())?['estimation']
                    ?.toString() ??
                    '',
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size16,
                    color: AppColors.black1Color,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 20),
              Text(
                recipientPhoneController.text.trim(),
                style: TextStyle(
                    fontFamily: AppStyle.secondaryFont,
                    fontSize: AppStyle.size16,
                    color: AppColors.black1Color,
                    fontWeight: FontWeight.w400),
              ),
              if (descriptionController.text.trim().isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      descriptionController.text.trim(),
                      style: TextStyle(
                          fontFamily: AppStyle.secondaryFont,
                          fontSize: AppStyle.size16,
                          color: AppColors.black1Color,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 100,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentStep--;
                    });
                  },
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                        child: Text(
                          AppTranslations.of(context)!.text('retour'),
                          style: TextStyle(
                              fontFamily: AppStyle.secondaryFont,
                              fontSize: AppStyle.size16,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: AnoirPrimaryButton(
                    text: 'rechercherUnLivreur',
                    onTap: () async {
                      if (selectedColisType == null) return;
                      Loader.showLoader(context);
                      try {
                        Course course = Course(
                          colisType: selectedColisType.name,
                          authorId: currentUserId,
                          type: widget.isReceive == true
                              ? 'RECEPTION'
                              : 'DELIVERY',
                          description: descriptionController.text.trim(),
                          isFragile: colisIsFragile,
                          price: estimations
                              .firstWhereOrNull((e) =>
                          e['engin'].toString().toUpperCase() ==
                              commandController.engineChoice.toUpperCase())?['estimation'] ??
                              0,
                          departure: departureController.text.trim(),
                          destination: destinationController.text.trim(),
                          engineType: commandController.engineChoice,
                          recipientPhone: recipientPhoneController.text.trim(),
                        );
                        bool result = await commandController.createCourse(course);
                        Loader.offLoader(context);
                        if (result) {
                          FlutterToastr.show(
                              AppTranslations.of(context)!
                                  .text('courseEnregistree'),
                              context,
                              backgroundColor: AppColors.primaryBlueColor,
                              textStyle:
                              TextStyle(color: Colors.white, fontSize: 12));
                          Get.to(() => ResearchDeliverScreen(course: course));
                        } else {
                          FlutterToastr.show(
                              AppTranslations.of(context)!
                                  .text('impossibleDenregistrerLaCourse'),
                              context,
                              backgroundColor: Colors.black,
                              textStyle:
                              TextStyle(color: Colors.white, fontSize: 12));
                        }
                      } catch (e) {
                        log(e.toString());
                      } finally {
                        Loader.offLoader(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
