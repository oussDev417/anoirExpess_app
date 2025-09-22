import 'package:get/get.dart';

class DeliverHomeScreenController extends GetxController{
  int currentScreen = 0;

  updateCurrentScreen(index){
    currentScreen = index;
    update();
  }
}