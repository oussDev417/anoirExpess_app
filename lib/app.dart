import 'dart:developer';

import 'package:anoirexpress/screens/deliver_screens/main_screen/deliver_home_screen.dart';
import 'package:anoirexpress/screens/main_screens/home_screen.dart';
import 'package:anoirexpress/screens/onboarding_screen.dart';
import 'package:anoirexpress/screens/send_package_screen.dart';
import 'package:anoirexpress/screens/splash_screen.dart';
import 'package:anoirexpress/screens/success_screen.dart';
import 'package:anoirexpress/translations.dart';
import 'package:anoirexpress/utils/shared_preferencies.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:upgrader/upgrader.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Déterminer l'écran initial de manière sécurisée
    Widget initialScreen = OnboardingScreen();
    
    if (prefs?.containsKey('token') == true) {
      String? role = prefs?.getString('role');
      if (role == 'CLIENT') {
        initialScreen = UpgradeAlert(
          upgrader: Upgrader(
            debugLogging: true,
            durationUntilAlertAgain: Duration(days: 2),
            debugDisplayAlways: false,
            willDisplayUpgrade: ({required bool display,
              String? installedVersion,
              UpgraderVersionInfo? versionInfo}) {
              log('CHECK ' + display.toString());
              log('CHECK ' + installedVersion.toString());
              log('CHECK ' + versionInfo.toString());
            }
          ),
          showIgnore: true,
          showLater: false,
          showReleaseNotes: false,
          child: HomeScreen()
        );
      } else if (role == 'DELIVER') {
        initialScreen = UpgradeAlert(
          upgrader: Upgrader(
            debugLogging: true,
            durationUntilAlertAgain: Duration(days: 2),
            debugDisplayAlways: false,
            willDisplayUpgrade: ({required bool display,
              String? installedVersion,
              UpgraderVersionInfo? versionInfo}) {
              log('CHECK ' + display.toString());
              log('CHECK ' + installedVersion.toString());
              log('CHECK ' + versionInfo.toString());
            }
          ),
          showIgnore: true,
          showLater: false,
          showReleaseNotes: false,
          child: DeliverHomeScreen()
        );
      }
    }

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ANNOIR EXPRESS',
      theme: ThemeData(
        useMaterial3: false
      ),
      localizationsDelegates: [
        TranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('fr',''),
        Locale('en',''),
      ],
      home: initialScreen
    );
  }
}
