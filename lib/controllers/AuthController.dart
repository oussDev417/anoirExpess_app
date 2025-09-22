import 'dart:developer';

import 'package:anoirexpress/models/api_result.dart';
import 'package:anoirexpress/models/user.dart';
import 'package:anoirexpress/translations.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../services/user_service.dart';

class AuthController extends GetxController{
  UserService userService = UserService();
  Future<ApiResult> registerUser(User user) async {
    try{
       return await userService.registerUser(user);
    }
    catch(e){
      log('error $e');
      return ApiResult(code: 400, message: 'anErrorOccured', success: false);
    }
  }

  Future<ApiResult> loginUser(String username, String password) async {
    try{
      return await userService.loginUser(username,password);
    }
    catch(e){
      log('error $e');
      return ApiResult(code: 400, message: 'anErrorOccured', success: false);
    }
  }

  verifyUserEmail(String email, String name) async {
    try{
      return await userService.verifyUserEmail(email,name);
    }
    catch(e){
      log('error $e');
      return ApiResult(code: 400, message: 'anErrorOccured', success: false);
    }
  }
}