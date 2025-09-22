import 'dart:developer';

import 'package:anoirexpress/models/api_result.dart';
import 'package:anoirexpress/models/colis_type.dart';
import 'package:anoirexpress/models/course.dart';
import 'package:anoirexpress/services/command_service.dart';
import 'package:get/get.dart';

class CommandController extends GetxController{
  CommandService commandService = CommandService();
  String engineChoice = 'MOTO';
  List<ColisType> colisTypes = [];
  List<dynamic> enginesAssets = [
    {
      'type': 'moto',
      'asset': 'assets/svg/engines/ic_moto.svg',
      'price' : 1
    },
    {
      'type': 'taxi-tricycle',
      'asset': 'assets/svg/engines/ic_taxi-tricycle.svg',
      'price' : 1
    },
    {
      'type': 'tricycle',
      'asset': 'assets/svg/engines/ic_tricycle.svg',
      'price' : 1
    },
    {
      'type': 'voiture',
      'asset': 'assets/svg/engines/ic_voiture.svg',
      'price' : 1

    },
    {
      'type': 'bus',
      'asset': 'assets/svg/engines/ic_bus.svg',
      'price' : 1
    },
    {
      'type': 'camion',
      'asset': 'assets/svg/engines/ic_camion.svg',
      'price' : 1
    },
  ] ;
  List<Course> availableCourses = [];
  List<Course>? myLastAcceptedCourses;
  bool isLoading = false;

  getColisTypes() async {
    log('message');
    isLoading = true;
    log('message--');
    colisTypes = await commandService.getColisTypes();
    log('message');
    try{
      log('message');


      colisTypes.removeWhere((element) => element.name == 'TRANSPORT DE PERSONNES' );
      colisTypes.sort((a,b)=>a.name.compareTo(b.name));
      try{
        ColisType? autre = colisTypes.where((element) => element.name == 'AUTRES').toList().first;
        if(autre!=null){
          colisTypes.add(autre);
        }
      }
      catch(e){

      }
    }
    catch(e){
      log('ERROR getting colis types $e');
    }
    isLoading = false;
    update();
  }

  getEngineTypes() async {

  }
  updateEngineChoice(value,price){
    engineChoice = value;
    enginesAssets.firstWhere((element) => element['type'].toString().toUpperCase() == engineChoice)['price'] = price;
    update();
  }

  Future<List<dynamic>> evaluateCourse(String colisType) async{
    List<dynamic> eval = await commandService.evaluateCourse(colisType);
    log('message');
    return eval;
  }

  Future<bool> createCourse(Course course) async {
    log('ENGINE TYPE ' + course.engineType);
    return await commandService.createNewCourse(course);
  }

  Future<List<Course>> getMyCourses() async {
    List<Course> courses = await commandService.getMyCourses();
    return courses;
  }

  getAvailableCourses() async {
    if(availableCourses.length > 0){
      availableCourses.clear();
      update();
    }
    availableCourses = await commandService.getAvailableCourses();
    update();
  }

  getMyLastAcceptedCourse() async {
    myLastAcceptedCourses = [];
    List<dynamic> courses = await commandService.getMyLastAcceptedCourse();
    log('ACTIVE COURSE FROM DB $courses');

    if(courses.length > 0){
      for(int i=0; i<courses.length; i++){
        myLastAcceptedCourses!.add(Course.fromJson(courses[i]));
      }
    }
    log('ACTIVE COURSE $myLastAcceptedCourses');
    update();
  }

  void ignoreThisCourse(Course course) {
    availableCourses.remove(course);
    update();
  }

  Future<ApiResult> acceptCourse(String courseId, String startEstimation) async {
    return await commandService.acceptCourse(courseId,startEstimation);
  }

  startCourse(Course course) async {
    return await commandService.startCourse(course);
  }

  Future<ApiResult> endCourse(String courseId) async {
    return await commandService.endCourse(courseId);
  }

  Future<List<Course>> getMyActiveCourses() async {
    List<Course> courses = await commandService.getMyActiveCourses();
    return courses;
  }
}