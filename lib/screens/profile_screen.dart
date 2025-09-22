import 'package:anoirexpress/controllers/UserController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';

import '../components/anoir_input_component.dart';
import '../components/anoir_primary_button.dart';
import '../helpers/helpers.dart';
import '../style/colors.dart';
import '../style/style.dart';
import '../translations.dart';
import '../utils/loader.dart';
import 'change_password/change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserController userController = Get.find();
  TextEditingController firstnameController =  TextEditingController();
  TextEditingController lastnameController =  TextEditingController();
  TextEditingController usernameController =  TextEditingController();
  TextEditingController emailController =  TextEditingController();
  TextEditingController phoneController =  TextEditingController();
  TextEditingController passwordController =  TextEditingController();
  TextEditingController confirmPasswordController =  TextEditingController();
  final profileFormKey = GlobalKey<FormState>();

  initProfile(){
    if(userController.currentUser != null){
      setState(() {
        firstnameController.text =  userController.currentUser!.firstname!;
        lastnameController.text =  userController.currentUser!.lastname!;
        usernameController.text =  userController.currentUser!.username!;
        emailController.text =  userController.currentUser!.email!;
        phoneController.text =  userController.currentUser!.phone!;
      });
    }
 }

  @override
  void initState() {
    initProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (userController) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white10,
            elevation: 0,
            leading: GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: Icon(Icons.arrow_back,color: Colors.black.withOpacity(0.9),)),
            centerTitle: false,
            title: Text(AppTranslations.of(context)!.text('personalInformations'), style: TextStyle(fontFamily: AppStyle.primaryFont,fontSize: AppStyle.size16,color : AppColors.grey3Color, fontWeight: FontWeight.w400,),),
          ),
          body: userController.currentUser == null ? Container(height: Helpers.getScreenHeight(context),child: Center(child: CircularProgressIndicator(color: AppColors.primaryBlueColor,),),) : SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Center(child: Container(
                        padding: EdgeInsets.all(13),
                        child:
                        CircleAvatar(child: Icon(Icons.person,color: AppColors.primaryBlueColor,size: 50,),radius: 50,backgroundColor: AppColors.primaryBlueColor.withOpacity(0.05),)),),
                     Align(
                         alignment: Alignment.bottomCenter,
                         child: SvgPicture.asset('assets/svg/ic_edit.svg')),
                  ],
                ),
                SizedBox(height: 30,),
                Form(
                    key: profileFormKey,
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
                        AnoirInputComponent(label: 'adresseEmail',controller: emailController,isEmail: true,isReadOnly : true),
                        SizedBox(height: 16,),
                        AnoirInputComponent(label: 'telephone',controller: phoneController,isPhone: true,isReadOnly : true),
                        SizedBox(height: 16,),
                        GestureDetector(
                          onTap: (){
                            Get.to(()=>ChangePasswordScreen());
                          },
                          child: Container(
                            width: Helpers.getScreenWidth(context),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: AppColors.grey10Color),
                            padding: EdgeInsets.all(20),
                            child: Text(AppTranslations.of(context)!.text('changerDeMdp'), textAlign : TextAlign.start,style: TextStyle(fontFamily: AppStyle.primaryFont,fontSize: AppStyle.size14, fontWeight: FontWeight.w400,),),
                          ),
                        ),
                        SizedBox(height: 30,),
                        AnoirPrimaryButton(text: 'enregistrerLaModif', onTap: () async{
                           Loader.showLoader(context);
                           bool result = await userController.updateProfile(firstnameController.text.trim(),lastnameController.text.trim());
                           Loader.offLoader(context);
                           if(result){
                             FlutterToastr.show(AppTranslations.of(context)!.text('miseAjourReussie'), context,backgroundColor: Colors.green,textStyle: TextStyle(color: Colors.white,fontSize: 12));
                             await userController.refreshUserProfile();
                           }
                           else{
                             FlutterToastr.show(AppTranslations.of(context)!.text('anErrorOccured'), context,backgroundColor: Colors.red,textStyle: TextStyle(color: Colors.white,fontSize: 12));
                           }
                        }),
                        SizedBox(height: 80,)
                      ],
                    )),
              ],
            ),
          ),
        );
      }
    );
  }
}
