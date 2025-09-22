import 'package:get/get.dart';

class HomeScreenController extends GetxController{
  int currentScreen = 0;

  updateCurrentScreen(index){
    currentScreen = index;
    update();
  }
}