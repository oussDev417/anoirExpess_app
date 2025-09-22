import 'dart:developer';

import 'package:anoirexpress/models/api_result.dart';
import 'package:get/get.dart';

import '../models/user.dart';
import '../services/user_service.dart';

class UserController extends GetxController{
  UserService userService = UserService();
  User? currentUser;

  getCurrentUser() async {
      try{
        currentUser = await userService.getUserProfile();
        log(currentUser!.lastname.toString());
        update();
      }
      catch(e){
        log('error $e');
      }
  }

  getUserNotes() async {
      return await userService.getUserNotes();
  }

  Future<ApiResult> getResetPasswordCode(String userPhone) async {
    ApiResult result = await userService.getResetPasswordCode(userPhone);
    return result;
 }

  Future<ApiResult> resetPassword(String userPhone, String password) async {
    ApiResult result = await userService.resetPassword(userPhone, password);
    return result;
  }

  Future<bool> updateProfile(String firstname, String lastname) async {
    bool result = await userService.updateProfile(firstname, lastname);
    return result;
  }

  refreshUserProfile() async {
    await getCurrentUser();
  }

  Future<ApiResult> updatePassword(String oldPassword, String newPassword) async {
    ApiResult result = await userService.updatePassword(oldPassword, newPassword);
    return result;
  }

  Future<List<dynamic>> getUserNotifs() async {
    List<dynamic> notifs = await userService.getUserNotifs();
    return notifs;
  }

  Future<ApiResult> deleteUserAccount() async {
    ApiResult result = await userService.deleteUserAccount();
    return result;
  }
}