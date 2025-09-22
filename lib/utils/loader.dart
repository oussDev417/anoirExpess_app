import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Loader{
  static offLoader(context){
    Get.back();
  }

  static showLoader(context){
    showDialog(context: context, builder: (context){
      return  AlertDialog(
        content: Container(
          height: 50,
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoActivityIndicator(
                animating: true,
              ),
              Text('Patientez..')
            ],
          ),
        )
      );
    });
  }
}
