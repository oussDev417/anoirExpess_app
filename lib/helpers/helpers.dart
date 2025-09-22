import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:shared_preferences/shared_preferences.dart';


class Helpers {
  static hideSystemUiBottomOverlay(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(systemNavigationBarColor: Colors.white));
    SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
      log(systemOverlaysAreVisible.toString());
      // if(systemOverlaysAreVisible){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
      log(systemOverlaysAreVisible.toString());
      // }
    });
  }
  static showSystemUiOverlay(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top,SystemUiOverlay.bottom]);
  }

  static getScreenHeight(context,{double percent=1.0}){
    return MediaQuery.of(context)!.size.height*percent;
  }

  static getScreenWidth(context,{double percent=1.0}){
    return MediaQuery.of(context)!.size.width*percent;
  }

  static formatDatetimeToDMY(String date){
    return date.split(' ').reversed.toList()[1].split('-').reversed.join('/');
  }

  static bool isValidEmail(String email) {
    const String _emailRegex =
        r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    final RegExp regex = RegExp(_emailRegex);
    return regex.hasMatch(email.trim());
  }

  static String getFileSize(File? file) {
    if (file != null) {
      int fileSizeInBytes = file.lengthSync();
      double fileSizeInKB = fileSizeInBytes / 1024;
      return fileSizeInKB.toStringAsFixed(2) + ' KB';
    } else {
      return '...';
    }
  }

  // static Future<File> compressImage(File file) async {
  //   Uint8List? compressedFile = await FlutterImageCompress.compressWithFile(
  //     file.path,
  //     quality: 80,
  //     // percentage: 50,
  //       autoCorrectionAngle : true
  //   );
  //   return File.fromRawPath(compressedFile!);
  //   // setState(() {
  //   //   file3Compressed = compressedFile;
  //   // });
  //   //
  //   // print("FINAL TAILLE");
  //   // String fileSize = await getFileSize(file3Compressed);
  //   //
  //   // if (file3Compressed != null) {
  //   //   print("Tout est OK");
  //   //   if (fileSize.contains("KB")) {
  //   //     // Vérifiez si la taille est en kilo-octets (KB)
  //   //     double sizeInKB = double.parse(
  //   //         fileSize.split(" ")[0]); // Extrait la partie numérique de la taille
  //   //     if (sizeInKB > 4000) {
  //   //       // Si la taille dépasse 300KB, informez l'utilisateur
  //   //       Fluttertoast.showToast(
  //   //           msg: "La photo est trop lourde",
  //   //           toastLength: Toast.LENGTH_LONG,
  //   //           gravity: ToastGravity.BOTTOM,
  //   //           timeInSecForIosWeb: 1,
  //   //           backgroundColor: Colors.black,
  //   //           textColor: Colors.white,
  //   //           fontSize: 16.0);
  //   //       setState(() {
  //   //         _imageRevenu = null;
  //   //       });
  //   //     } else {
  //   //       // Si la taille est inférieure ou égale à 300KB, poursuivez avec le traitement.
  //   //       //toUnitList(fileCompressed);
  //   //     }
  //   //   } else if (fileSize.contains("MB")) {
  //   //     Fluttertoast.showToast(
  //   //         msg: "La photo t trop lourde",
  //   //         toastLength: Toast.LENGTH_LONG,
  //   //         gravity: ToastGravity.BOTTOM,
  //   //         timeInSecForIosWeb: 1,
  //   //         backgroundColor: Colors.black,
  //   //         textColor: Colors.white,
  //   //         fontSize: 16.0);
  //   //     setState(() {
  //   //       _imageRevenu = null;
  //   //     });
  //   //   } else {
  //   //     // toUnitList(fileCompressed);
  //   //   }
  //   // }
  // }

  // Future<String?> getCurrentUserToken() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String? r = sharedPreferences.getString('token');
  //   log('TTTOKEN $r');
  //   return r;
  // }

  static formatDate(String date, {String? divider}){
    List refDate = date.split(divider ?? 'T');
    var hour = refDate[1].split('.')[0];
    var rDate = refDate[0].split('-').reversed;
    var reversedDate = List.from(rDate);
    var d = reversedDate[0] + '/' + reversedDate[1] + '/' + reversedDate[2];
    return d + ',' + hour;
  }

  String getMatchedString(String text) {
    if (text.length > 80) {
      return text.substring(0, 80) + "...";
    } else {
      return text;
    }
  }


}