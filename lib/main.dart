import 'dart:developer';

import 'package:anoirexpress/screens/deliver_screens/main_screen/deliver_home_screen.dart';
import 'package:anoirexpress/screens/main_screens/home_screen.dart';
import 'package:anoirexpress/utils/shared_preferencies.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation SharedPreferences
  prefs = await SharedPreferences.getInstance();

  // Initialisation Firebase sécurisée
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      print('Firebase already initialized, continuing...');
    } else {
      print('Firebase initialization error: $e');
      rethrow;
    }
  }

  // Gestion des messages en arrière-plan
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Gestion quand l'app est ouverte par une notif en background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      log('Background notification tapped');
      if (prefs?.getString('role') == 'DELIVER') {
        Get.to(() => DeliverHomeScreen());
      } else {
        Get.to(() => HomeScreen());
      }
    }
  });

  // Vérifier si l'app est lancée depuis un état "terminé" avec une notif
  await handleInTerminatedState();
  
  runApp(MyApp());
}

handleInTerminatedState() async {
  final RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    log('Launched from terminated state');
    Future.delayed(Duration(seconds: 1), () {
      Get.to(() => HomeScreen());
    });
  }
}