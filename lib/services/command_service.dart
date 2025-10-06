import 'dart:convert';
import 'dart:developer';

import 'package:anoirexpress/models/api_result.dart';
import 'package:anoirexpress/models/course.dart';

import '../constants/constants.dart';
import 'package:http/http.dart' as http;

import '../models/colis_type.dart';
import '../utils/shared_preferencies.dart';
class CommandService{
  getEngineTypes(){

  }

  getColisTypes() async {
    try{
      const url = '$API_URL/courses/colis-types';
      var response = await http.get(Uri.parse(url),headers: {
        "Authorization" : "Bearer ${prefs?.getString('token')}"
      });
      List<ColisType> types = [];
      log(response.statusCode.toString());
      log(response.body.toString());
      if(response.statusCode == 200){
        List data = json.decode(response.body);
        for(int i=0;i<data.length;i++){
          types.add(ColisType.fromJson(data[i]));
        }
      }
      return types;
    }
    catch(e){
      log('ERROR ON gettingTypes $e');
      return [];
    }
  }

  Future<List<dynamic>> evaluateCourse(String colisType) async {
    try{
      const url = '$API_URL/courses/estimate-price';
      var response = await http.post(Uri.parse(url),headers: {
        "Authorization" : "Bearer ${prefs?.getString('token')}"
      },body: {
        "colisType" : colisType
      });
      log(response.statusCode.toString());
      log('ESTIMATE COURSE BODY ' + response.body.toString());
      if(response.statusCode == 200){
        List<dynamic> data = json.decode(response.body);
       return data;
      }
      else{
        log('status not 200');
        return [];
      }
    }
    catch(e){
      log('ERROR ON getting estimation $e');
      return [];
    }
  }

  Future<bool> createNewCourse(Course course) async {
    // try{
      const url = '$API_URL/courses';
      var response = await http.post(Uri.parse(url),headers: {
        "Authorization" : "Bearer ${prefs?.getString('token')}",
        "Content-Type" : "application/json"
      },body: json.encode(course.toJson()));
      log(response.statusCode.toString());
      log(response.body.toString());
      if(response.statusCode == 201){
        return true;
      }
      else{
        return false;
      }
    // }
    // catch(e){
    //   log('ERROR ON create course $e');
    //   return false;
    // }
  }

  Future<List<Course>> getMyCourses() async {
    try{
      var response = null;
      if(prefs?.getString('role') == 'CLIENT'){
        var url = '$API_URL/courses/mine';
        response = await http.get(Uri.parse(url),headers: {
          "Authorization" : "Bearer ${prefs?.getString('token')}"
        });
      }
      else{
        var url = '$API_URL/courses/deliver/mine';
        response = await http.post(Uri.parse(url),headers: {
          "Authorization" : "Bearer ${prefs?.getString('token')}"
        },
        body: {
          "deliverId" : prefs?.getString('deliverId') ?? '' ?? ''
        });
      }
      log(response.statusCode.toString());
      log(response.body.toString());
      if([200,201].contains(response.statusCode)){
        List data = json.decode(response.body);
        List<Course> courses = [];
        for(int i=0; i<data.length; i++){
          courses.add(Course.fromJson(data[i]));
        }
        return courses;
      }
      else{
        return [];
      }
    }
    catch(e){
      log('ERROR ON getting my courses $e');
      return [];
    }
  }

  Future<List<Course>> getAvailableCourses() async {
    try{
      const url = '$API_URL/courses';
      var response = await http.get(Uri.parse(url),headers: {
        "Authorization" : "Bearer ${prefs?.getString('token')}"
      });
      log(response.statusCode.toString());
      log(response.body.toString());
      if(response.statusCode == 200){
        List data = json.decode(response.body);
        List<Course> courses = [];
        for(int i=0; i<data.length; i++){
          courses.add(Course.fromJson(data[i]));
        }
        return courses;
      }
      else{
        return [];
      }
    }
    catch(e){
      log('ERROR ON getting available courses $e');
      return [];
    }
  }

  Future<ApiResult> acceptCourse(String courseId, String startEstimation) async {
    try{
    log('COURSE ID = $courseId');
    log('START  = $startEstimation');
    log("DELIVER_ID  ="  + (prefs?.getString('deliverId') ?? ''));
      const url = '$API_URL/courses/accept';
      var response = await http.post(Uri.parse(url),headers: {
        "Authorization" : "Bearer ${prefs?.getString('token')}"
      },
      body: {
        "deliverId" : prefs?.getString('deliverId') ?? '',
        "courseId" : courseId,
        "startEstimation" : startEstimation
      });
      log(response.statusCode.toString());
      log(response.body.toString());
      var data = json.decode(response.body);
      return ApiResult(code: response.statusCode, message: data['message'] ?? '', success:  data['success'] ?? false);
    }
    catch(e){
      log('ERROR reserving course $e');
      return ApiResult(code: 400, message: 'Error' ?? '', success:  false);
    }
  }

  Future<dynamic> getMyLastAcceptedCourse() async {
    try{
      const url = '$API_URL/courses/my-last-accepted';
      var response = await http.post(Uri.parse(url),headers: {
        "Authorization" : "Bearer ${prefs?.getString('token')}"
      },
        body: {
          "deliverId" : prefs?.getString('deliverId') ?? '' ?? '',
        });
      log(response.statusCode.toString());
      log('ACTIVE COURSE BODY ' + response.body.toString());
      var data = json.decode(response.body);
      return data ?? [];
    }
    catch(e){
      return [];
    }
  }

  startCourse(Course course) async {
    try{
      const url = '$API_URL/courses/start';
      var body = {
        "courseId" : course.id,
        "courseCode" : course.courseCode,
      };
      var response = await http.post(Uri.parse(url),headers: {
        "Content-Type": "application/json",
        "Authorization" : "Bearer ${prefs?.getString('token')}"
      },
          body: jsonEncode(body));
      log(response.statusCode.toString());
      log(response.body.toString());
      var data = json.decode(response.body);
      return ApiResult(code: response.statusCode, message: data['message'] ?? '', success:  data['success'] ?? false);
    }
    catch(e){
      log('ERROR starting course $e');
      return ApiResult(code: 400, message: 'Big Error' ?? '', success:  false);
    }
  }

  Future<ApiResult> endCourse(String courseId) async {
    try{
      const url = '$API_URL/courses/end';
      var body = {
        "courseId" : courseId,
        "deliverId" : prefs?.getString('deliverId') ?? '',
      };
      var response = await http.post(Uri.parse(url),headers: {
        "Content-Type": "application/json",
        "Authorization" : "Bearer ${prefs?.getString('token')}"
      },
          body: jsonEncode(body));
      log(response.statusCode.toString());
      log(response.body.toString());
      var data = json.decode(response.body);
      return ApiResult(code: response.statusCode, message: data['message'] ?? '', success:  data['success'] ?? false);
    }
    catch(e){
      log('ERROR starting course $e');
      return ApiResult(code: 400, message: 'Big Error' ?? '', success:  false);
    }
  }

  Future<Course?> getCourseById(String? courseId) async {
    try{
      const url = '$API_URL/courses/get-course-by-id';
      var response = await http.post(Uri.parse(url),headers: {
        "Authorization" : "Bearer ${prefs?.getString('token')}"
      },
          body: {
            "courseId" : courseId,
          });
      log(response.statusCode.toString());
      log(response.body.toString());
      var data = json.decode(response.body);

      return Course.fromJson(data);
    }
    catch(e){
      return null;
    }
  }

  Future<List<Course>>getMyActiveCourses() async {
    try{
      const url = '$API_URL/courses/get-client-active-courses';
      var response = await http.get(Uri.parse(url),headers: {
        "Authorization" : "Bearer ${prefs?.getString('token')}"
      },);
      log(response.statusCode.toString());
      log(response.body.toString());
      var data = json.decode(response.body);
      List<Course> result = [];
      for(int i = 0; i< data.length ; i++){
        result.add(Course.fromJson(data[i]));
      }
      return result;
    }
    catch(e){
      return [];
    }
  }
}