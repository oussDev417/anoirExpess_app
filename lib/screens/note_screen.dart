import 'package:anoirexpress/components/anoir_primary_appbar.dart';
import 'package:anoirexpress/components/anoir_primary_button.dart';
import 'package:anoirexpress/screens/main_screens/home_screen.dart';
import 'package:anoirexpress/utils/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:get/get.dart';

import '../models/course.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../style/colors.dart';
import '../style/style.dart';
import '../translations.dart';

class NoteScreen extends StatefulWidget {
  Course course;
  NoteScreen({required this.course});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  TextEditingController noteController = TextEditingController();
  final noteKey = GlobalKey<FormState>();
  UserService userService = UserService();
  User? deliver;
  getDeliver() async {
    User? u = await userService.getUserById(widget.course.deliverId!);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        deliver = u;
      });
    });
  }

  @override
  void initState() {
    if(widget.course.deliverId != null){
      getDeliver();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AnoirPrimaryAppbar(title: 'noteEtAvis',goBackType:1),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primaryRedColor.withOpacity(0.08),
                  child: SvgPicture.asset('assets/svg/ic_deliver.svg'),
                ),
                SizedBox(height: 20,),
                Text(
                  AppTranslations.of(context)!.text('notezVotreLivreur'),
                  style: TextStyle(
                      fontFamily: AppStyle.secondaryFont,
                      fontSize: AppStyle.size16,
                      color: AppColors.grey6Color,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10,),
                Text(
                  deliver == null ? '' : deliver!.firstname + ' ' + deliver!.lastname,
                  style: TextStyle(
                      fontFamily: AppStyle.secondaryFont,
                      fontSize: AppStyle.size18,
                      color: AppColors.black2Color,
                      fontWeight: FontWeight.w400),
                ),
                // SizedBox(height: 20,),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     ...List.generate(4, (index) => SvgPicture.asset('assets/svg/ic_star_noted.svg')),
                //     ...List.generate(1, (index) => SvgPicture.asset('assets/svg/ic_star_not_noted.svg')),
                //   ],
                // ),
              ],
            ),
            SizedBox(height: 25,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppTranslations.of(context)!.text('ditesNousUnPeuPlus'),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: AppStyle.secondaryFont,
                      fontSize: AppStyle.size12,
                      color: AppColors.black2Color,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            SizedBox(height: 8,),

            Form(
              key: noteKey,
              child: TextFormField(
                textInputAction: TextInputAction.done,
                controller: noteController,
                maxLines: 5,
                validator: (value){
                  if(value!.trim().isEmpty){
                    return AppTranslations.of(context)!.text('champsRequis');
                  }
                },
                cursorColor: AppColors.primaryBlueColor,
                decoration: InputDecoration(
                    filled: true,
                    hintText: '...',
                    hintStyle: TextStyle(color: AppColors.grey1Color),
                    floatingLabelStyle: TextStyle(color: AppColors.grey1Color,),
                    contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 8),
                    fillColor: AppColors.grey2Color,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.primaryBlueColor),
                        borderRadius: BorderRadius.circular(8)
                    )
                ),
              ),
            ),
            SizedBox(height: 25,),
            AnoirPrimaryButton(text: 'envoyer', onTap: () async {
                 if(noteKey.currentState!.validate()){
                   Loader.showLoader(context);
                   bool result = await userService.noteDeliver(noteController.text.trim(),widget.course.deliverId);
                   Loader.offLoader(context);
                   if(result){
                     FlutterToastr.show(AppTranslations.of(context)!.text('deliverNoted'), context,backgroundColor: Colors.green,textStyle: TextStyle(color: Colors.white,fontSize: 12),);
                     Get.offAll(()=>HomeScreen());
                   }else{
                     FlutterToastr.show(AppTranslations.of(context)!.text('anErrorOccured'), context,backgroundColor: Colors.red,textStyle: TextStyle(color: Colors.white,fontSize: 12),);
                     Get.back();
                   }
                 }
            })
          ],
        ),
      ),
    );
  }
}
