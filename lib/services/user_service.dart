import 'dart:convert';
import 'dart:developer';

import 'package:anoirexpress/services/notification_service.dart';
import 'package:pinput/pinput.dart';

import '../constants/constants.dart';
import '../models/api_result.dart';
import '../models/note.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

import '../utils/shared_preferencies.dart';

class UserService{
  registerUser(User user) async {
    try{
      const url = '$API_URL/auth/signup';
      var us = user.toJson();
      log('user $us');
      var response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",  // 🔹 on force JSON
        },
        body: jsonEncode(us), // 🔹 on encode en JSON
      );
      log(response.statusCode.toString());
      print(response.body.toString());
      if(response.statusCode == 201){
        return ApiResult(code: 201, message: 'registerSuccessfully',success: true);
      }
      else{
          return ApiResult(code: response.statusCode, message: response.statusCode == 403 ? 'identifiantsDejaUtilises' : 'anErrorOccured',success: false);
      }
    }
    catch(e){
      log('ERROR ON REGISTER $e');
      print('ERROR ON REGISTER $e');
      return ApiResult(code: 400, message: 'anErrorOccured',success: false);
    }

  }

  loginUser(String username, String password) async {
    try{
      const url = '$API_URL/auth/login';

      var response = await http.post(Uri.parse(url),
          body: {"email" : username, "password" : password});
      log(response.statusCode.toString());
      log(response.body.toString());
      var data = json.decode(response.body);
      if([200,201].contains(response.statusCode)){
        prefs?.setString('token',data['token']);
        prefs?.setString('role',data['role']);
        prefs?.setString('userId',data['id']);
        if(data['deliverId'] != null){
          prefs?.setString('deliverId',data['deliverId']);
        }
        NotificationService().init();
        return ApiResult(code: 200, message: 'loginSuccessfully',success: true);
      }
      else{
        return ApiResult(code: response.statusCode, message: response.statusCode == 403 ? 'identifiantsIncorrects' : 'anErrorOccured',success: false);
      }
    }
    catch(e){
      log('ERROR ON Login $e');
      return ApiResult(code: 400, message: 'anErrorOccured',success: false);
    }
  }

  Future<User?> getUserProfile() async {
    try{
      log('🔍 UserService: Starting getUserProfile...');
      const url = '$API_URL/users/profile';
      String? token = prefs?.getString('token');
      log('🔑 UserService: Token found: ${token != null ? 'YES' : 'NO'}');
      if(token == null) {
        log('❌ UserService: No token found for profile request');
        return null;
      }
      log('🌐 UserService: Making request to: $url');
      var response = await http.get(Uri.parse(url),headers: {
        "Authorization" : "Bearer $token"
      });
      log('📡 UserService: Response status: ${response.statusCode}');
      log('📄 UserService: Response body: ${response.body}');
      if([200].contains(response.statusCode)){
        User user = User.fromMap(json.decode(response.body));
        log('✅ UserService: User parsed successfully - ${user.firstname} ${user.lastname}');
        return user;
      }
      else{
        log('❌ UserService: API returned status ${response.statusCode}');
        return null;
      }
    }
    catch(e){
      log('❌ UserService: ERROR ON profile $e');
      return null;
    }
  }

  Future<User?> getUserById(String userId) async {
    try{
      const url = '$API_URL/users/get-a-user-profile';
      String? token = prefs?.getString('token');
      if(token == null) {
        log('No token found for getUserById request');
        return null;
      }
      var response = await http.post(Uri.parse(url),headers: {
        "Authorization" : "Bearer $token",
      },
      body : {
        "userId" : userId
      });
      log(response.statusCode.toString());
      log(response.body.toString());
      if([200,201].contains(response.statusCode)){
        return User.fromMap(json.decode(response.body));
      }
      else{
        return null;
      }
    }
    catch(e){
      log('ERROR ON profile $e');
      return null;
    }
  }

  getUserNotes() async {
    try{
      const url = '$API_URL/users/get-deliver-notes';
      String? token = prefs?.getString('token');
      if(token == null) {
        log('No token found for getUserNotes request');
        return [];
      }
      var response = await http.post(Uri.parse(url),headers: {
        "Authorization" : "Bearer $token",
      },
          body : {
            "deliverId" : prefs?.getString('deliverId') ?? ''
          });

      log(response.statusCode.toString());
      log(response.body.toString());
      var body = json.decode(response.body);
      List<Note> data = [];
      if([200,201].contains(response.statusCode)){
        for(int i=0; i<body.length;i++){
          data.add(Note.fromMap(json.decode(response.body)[i]));
        }
        return data;
      }
      else{
        return [];
      }
    }
    catch(e){
      log('ERROR ON getting notes $e');
      return [];
    }
  }

  noteDeliver(String note, String? deliverId) async {
    try{
      const url = '$API_URL/users/note-a-deliver';
      String? token = prefs?.getString('token');
      if(token == null) {
        log('No token found for noteDeliver request');
        return ApiResult(code: 401, message: 'No token', success: false);
      }
      var response = await http.post(Uri.parse(url),headers: {
        "Authorization" : "Bearer $token",
      },
          body : {
            "deliverId" : deliverId,
            "note" : note
          });

      log(response.statusCode.toString());
      log(response.body.toString());
      if([200,201].contains(response.statusCode)){
        return true;
      }
      else{
        return false;
      }
    }
    catch(e){
      return false;
    }
  }

  updateMessagingToken(String fcmToken) async {
    try{
      const url = '$API_URL/users/update-notif-token';
      String? token = prefs?.getString('token');
      if(token == null) {
        log('No token found for updateMessagingToken request');
        return false;
      }
      var response = await http.post(Uri.parse(url),headers: {
        "Authorization" : "Bearer $token",
      },
          body : {
            "userId" : prefs?.getString('userId') ?? '',
            "token" : fcmToken
          });

      log(response.statusCode.toString());
      log(response.body.toString());
      if([200,201].contains(response.statusCode)){
        return true;
      }
      else{
        return false;
      }
    }
    catch(e){
      return false;
    }
  }

   getResetPasswordCode(String userPhone) async{
     try{
       log('f' + userPhone);
       const url = '$API_URL/users/generate-reset-password-code';
       var response = await http.post(Uri.parse(url),
           body : {
             "phone" : '+229'+userPhone
           });
       log(response.statusCode.toString());
       log(response.body.toString());
         return ApiResult(code: response.statusCode, message: '', success: [200,201].contains(response.statusCode) ? true : false, data : json.decode(response.body)['code'] ?? null);
     }
     catch(e){
       return ApiResult(code: 500, message: '', success: false);
     }
  }

  resetPassword(String userPhone,String newPassword) async{
    try{
      const url = '$API_URL/users/reset-password';
      var response = await http.post(Uri.parse(url),
          body : {
            "phone" : userPhone,
            "password" : newPassword,
          });
      log(response.statusCode.toString());
      log(response.body.toString());
      return ApiResult(code: response.statusCode, message: '', success: [200,201].contains(response.statusCode) ? true : false);
    }
    catch(e){
      return ApiResult(code: 500, message: '', success: false);
    }
  }


  updateProfile(String firstname,String lastname) async{
    try{
      const url = '$API_URL/users/update-user-profile';
      String? token = prefs?.getString('token');
      if(token == null) {
        log('No token found for updateProfile request');
        return false;
      }
      var response = await http.post(Uri.parse(url),
          headers: {
            "Authorization" : "Bearer $token",
          },
          body : {
            "firstname" : firstname,
            "lastname" : lastname,
          });
      log(response.statusCode.toString());
      log(response.body.toString());
      if([200,201].contains(response.statusCode)){
        return true;
      }
      else{
        return false;
      }
    }
    catch(e){
      log('Error updating profile ' + e.toString());
      return false;
    }
  }

  Future<ApiResult> updatePassword(String oldPassword, String newPassword) async {
    try{
      const url = '$API_URL/users/update-password';
      String? token = prefs?.getString('token');
      if(token == null) {
        log('No token found for updatePassword request');
        return ApiResult(code: 401, message: 'No token', success: false);
      }
      var response = await http.post(Uri.parse(url),
          headers: {
            "Authorization" : "Bearer $token",
          },
          body : {
            "current" : oldPassword,
            "new" : newPassword,
          });
      log(response.statusCode.toString());
      log(response.body.toString());
      return ApiResult(code: response.statusCode, message: '', success: [200,201].contains(response.statusCode) ? true : false);
    }
    catch(e){
      return ApiResult(code: 500, message: '', success: false);
    }
  }

  verifyUserEmail(String email, String name) async {
    try{
      const url = '$API_URL/auth/verify-email';
      var response = await http.post(Uri.parse(url),
          body : {
            "email" : email,
            "name" : name,
          });
      log(response.statusCode.toString());
      log(response.body.toString());
      return ApiResult(code: response.statusCode, message: '', success: [200,201].contains(response.statusCode) ? true : false, data : json.decode(response.body)['code'] ?? null);
    }
    catch(e){
      return ApiResult(code: 500, message: '', success: false);
    }
  }


  Future<List<dynamic>> getUserNotifs() async {
    try{
      const url = '$API_URL/users/get-user-notifs';
      String? token = prefs?.getString('token');
      if(token == null) {
        log('No token found for getUserNotifs request');
        return [];
      }
      var response = await http.get(Uri.parse(url),headers: {
        "Authorization" : "Bearer $token"
      });
      log(response.statusCode.toString());
      log(response.body.toString());
      if([200].contains(response.statusCode)){
        return json.decode(response.body);
      }
      else{
        return [];
      }
    }
    catch(e){
      log('ERROR ON profile $e');
      return [];
    }
  }

  deleteUserAccount() async {
    try{
      const url = '$API_URL/users/delete-account';
      String? token = prefs?.getString('token');
      if(token == null) {
        log('No token found for deleteUserAccount request');
        return ApiResult(code: 401, message: 'No token', success: false);
      }
      var response = await http.delete(Uri.parse(url),
          headers: {
            "Authorization" : "Bearer $token",
          },
          body : {
            "id" : prefs?.getString('userId') ?? '',
          });
      log(response.statusCode.toString());
      log(response.body.toString());
      return ApiResult(code: response.statusCode, message: '', success: [200,201].contains(response.statusCode) ? true : false);
    }
    catch(e){
      return ApiResult(code: 500, message: '', success: false);
    }
  }


}