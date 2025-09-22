import 'package:anoirexpress/screens/main_screens/home_screen.dart';
import 'package:anoirexpress/screens/onboarding_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../style/colors.dart';
import '../utils/shared_preferencies.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2),(){
      Get.off(()=> prefs!.containsKey('token') ? HomeScreen() : OnboardingScreen());
    });
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
        child: Center(
        child: Image.asset('assets/png/img_logo.png'),
      ),
    )
    );
  }
}
