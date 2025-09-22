import 'package:anoirexpress/controllers/UserController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../components/deliver/anoir_deliver_bottom_navigation_bar.dart';
import '../../../helpers/helpers.dart';
import '../../../models/note.dart';
import '../../../style/colors.dart';
import '../../../style/style.dart';
import '../../../translations.dart';

class DeliverNotesScreen extends StatefulWidget {

  @override
  State<DeliverNotesScreen> createState() => _DeliverNotesScreenState();
}

class _DeliverNotesScreenState extends State<DeliverNotesScreen> {
  bool isLoading = true;
  List<Note> userNotes = [];
  UserController userController = Get.find();

  getUserNotes() async {
    setState(() {
      isLoading = true;
    });
    try{
      List<Note> n = await userController.getUserNotes();
      setState(() {
        userNotes = n;
        isLoading = false;
        isLoading = false;
      });
    }
    catch(e){
      setState(() {
        isLoading = false;
      });
    }

  }

  @override
  void initState() {
    getUserNotes();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        centerTitle: false,
        title: Text(AppTranslations.of(context)!.text('notesEtAvis'), style: TextStyle(fontFamily: AppStyle.primaryFont,fontSize: AppStyle.size16,color : AppColors.grey3Color, fontWeight: FontWeight.w400,),),
        leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Icon(Icons.arrow_back,color: Colors.black.withOpacity(0.9),)),
      ),
      body: isLoading ? Container(height: 100,child: Center(child: CircularProgressIndicator(color: AppColors.primaryBlueColor,),),) : userNotes.length == 0 ? Container(
        height: 200,
        child: Center(child: Text(AppTranslations.of(context)!.text('aucuneNoteDisponible'))),
      ): SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text('${userNotes.length} ' + AppTranslations.of(context)!.text('notesEtAvis'), style: TextStyle(fontFamily: AppStyle.primaryFont,fontSize: AppStyle.size16,color : Colors.black54, fontWeight: FontWeight.w400,),),
           SizedBox(height: 20,),
            ...List.generate(userNotes.length, (index) => Container(
              padding: EdgeInsets.all(15),
             margin: EdgeInsets.only(bottom: 20),
             decoration: BoxDecoration(
               color: Colors.white,
                 boxShadow: [
                   BoxShadow(color: Colors.black.withOpacity(0.1),blurRadius: 1,spreadRadius: 0.2),
                 ],
                 borderRadius: BorderRadius.circular(8),border: Border.all(color: AppColors.grey3Color.withOpacity(0.13))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userNotes[index].user.firstname + ' ' + userNotes[index].user.lastname, style: TextStyle(fontFamily: AppStyle.primaryFont,fontSize: AppStyle.size16,color : Colors.black, fontWeight: FontWeight.w600,),),
              SizedBox(height: 10,),
              Text(userNotes[index].note, style: TextStyle(fontFamily: AppStyle.primaryFont,fontSize: AppStyle.size14,color : Colors.black54, fontWeight: FontWeight.w400,),),
              SizedBox(height: 10,),
              Row(
                children: [
                  Spacer(),
                  Text(Helpers.formatDate(userNotes[index].createdAt), style: TextStyle(fontFamily: AppStyle.primaryFont,fontSize: AppStyle.size12,color : Colors.black, fontWeight: FontWeight.w400,),),
                ],
              ),

            ],
          ),
             ))
          ],
        ),
      ),

    );
  }
}
