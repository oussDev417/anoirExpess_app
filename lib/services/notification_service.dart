import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:anoirexpress/services/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../screens/deliver_screens/main_screen/deliver_home_screen.dart';
import '../screens/main_screens/home_screen.dart';
import '../utils/shared_preferencies.dart';

class NotificationService{
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  init() async {
    await getApnsToken();
    await manageTokenRefresh();
    await initLocalNotifications();
    await listenForegroundMessage();
  }

  getApnsToken() async {
    // You may set the permission requests to "provisional" which allows the user to choose what type
// of notifications they would like to receive once the user receives a notification.
//     final notificationSettings = await firebaseMessaging.requestPermission(provisional: true);
      await requestPermission();
// For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
    final apnsToken = await firebaseMessaging.getAPNSToken();
    log('APNS TOKEN  == $apnsToken');

    if (apnsToken != null) {
      // APNS token is available, make FCM plugin API requests...
      final fcmToken = await firebaseMessaging.getToken();
      log('FCM TOKEN ON IOS == $fcmToken');
      await saveUserFcmToken(fcmToken);
    }
    else{
      final fcmToken = await firebaseMessaging.getToken();
      log('FCM TOKEN ON ANDROID == $fcmToken');
      await saveUserFcmToken(fcmToken);
    }
  }

  saveUserFcmToken(fcmToken) async {
    if(prefs?.containsKey('token') ?? false){//on login
      UserService userService = UserService();
      try{
        await userService.updateMessagingToken(fcmToken);
      }
      catch(e){
        log('ERROR $e');
      }
    }
  }

  manageTokenRefresh(){
    //MANAGE TOKEN REFRESH
    firebaseMessaging.onTokenRefresh
        .listen((fcmToken) {
      // TODO: If necessary send token to application server.

      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
    })
        .onError((err) {
      // Error getting token.
    });
  }

  Future listenForegroundMessage() async {
    //LISTEN MESSAGE
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        String payloadData = json.encode(message.data);
        print('Message also contained a notification: ${message.notification}');
        await showSimpleMessage(message.notification!.title!, message.notification!.body!, payloadData);
      }
    });
  }



  requestPermission() async {
    //REQUEST PERMISSION
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  initLocalNotifications() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    if(Platform.isAndroid) {
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
    }

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/app_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    // onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );

    final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onDidReceiveNotificationResponse: onLocalNotificationTapped,onDidReceiveBackgroundNotificationResponse: onLocalNotificationTapped);
    await createNotificationChannels();
  }

  static onLocalNotificationTapped(NotificationResponse message){
    if(prefs?.getString('role') == 'DELIVER'){
      Get.offAll(()=>DeliverHomeScreen());
    }
    else{
      Get.offAll(()=>HomeScreen());
    }
  }

  Future<void> createNotificationChannels() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    const AndroidNotificationChannel callChannel = AndroidNotificationChannel(
      'anoir_notifications_channel', // channel ID
      'Anoir App Notifications', // channel name
      description: 'Incoming call notifications for Anoir app',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(callChannel);
  }

  static Future showSimpleMessage(String title, String body, String payload) async{
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails('rema_notifications_channel', 'Rema App Notifications',
        channelDescription: 'Incoming call notifications for REMA app',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails,
        payload: payload);
  }
}




// class AnoirAllNotificationsService {
//   DatabaseService databaseService = DatabaseService();
//
//
//
//   //SAVE NOTIF IN DATABASE AND SEND IT
//   void sendNotification(String receiverUid, RemaNotification notification) async{
//     notification.timestampString = DateTime.now().toString();
//     if (notification.metadatas == null) {
//       notification.metadatas = Map();
//     }
//     notification.metadatas!.putIfAbsent("AUTHOR_UID", () => prefs?.getString('token'));
//
//     log('MESSAGE ID ${notification.key}');
//     databaseService.getNotifRef().doc(receiverUid).set({
//       notification.key.toString() : {
//         "type": notification.type,
//         "title": notification.title,
//         "body": notification.body,
//         "action": notification.action,
//         "treated": notification.treated,
//         "metadatas": notification.metadatas,
//         "timestampString": notification.timestampString,
//         "isCliked": notification.isCliked,
//         "dateTimeTimestamp": notification.dateTimeTimestamp,
//         "key" : notification.key
//       },
//     },SetOptions(merge: true));
//   }
//
//   notifyApiToSendNotifs(List<dynamic> receivers, RemaNotification notification) async {
//     log('in notify api service');
//     log(' RECEIVERS == ' + receivers.toString());
//     log(' RECEIVERS == ' + receivers.length.toString());
//     String rec = '';
//     for(int i=0; i<receivers.length;i++){
//       rec += receivers[i] + ',';
//     }
//     rec = rec.substring(0,rec.length -1);
//     var body = jsonEncode({
//       "ids" :   rec,
//       "title" : notification.title,
//       "content" : notification.body,
//       "meta" :    notification.toJson()
//     });
//     log('BODY $body');
//     var response = await http.post(Uri.parse(sendNotifToUsersUrl),headers: {
//       'x-api-key' : X_API_KEY,
//       "Content-Type": "application/json"
//     },body: body);
//     log(response.toString());
//     log('NOTIF RESPONSE STATUS ${response.statusCode}');
//     log('NOTIF RESPONSE BODY ${response.body}');
//   }
//
//   createNewPostNotification(RemaFeed feed) async {
//       var currentUser = await Session().getCurrentUser();
//       var notification = RemaNotification.simple();
//       notification.metadatas!.putIfAbsent("SEE_TARGET_POST", () => feed.key);
//       notification.type = "NEW_POST";
//       notification.isCliked = false;
//       notification.treated = false;
//       notification.action = "SEE_TARGET_POST";
//       notification.title = "Du Nouveau sur REMA";
//       notification.body = currentUser!.fullname! + " a fait une nouvelle publication";
//       if (currentUser!.followers != null && currentUser.followers!.isNotEmpty) {
//         // log('USE THIS FOLLOWER TO TEST NOTIF ${currentUser!.followers!.first}');
//         // log('USE THIS FOLLOWER TO TEST NOTIF ${currentUser!.followers![2]}');
//
//         //TEST FOR 2 PERSON
//         // sendNotification(currentUser!.followers!.first, notification);
//         // sendNotification(currentUser!.followers![2], notification);
//
//         for (var i = 0; i < currentUser!.followers!.length; i++) {
//           if (currentUser!.followers![i] != currentUser.uid) {
//             if (feed.taggedUsers != null) {
//               if (!feed.taggedUsers!.contains(currentUser!.followers![i])) {
//                 sendNotification(currentUser.followers![i], notification);
//               }
//             } else {
//               sendNotification(currentUser!.followers![i], notification);
//             }
//           }
//         }
//       }
//       if (feed.taggedUsers != null && feed.taggedUsers!.length > 0) {
//         createPublicationTagNotification(feed);
//       } else {
//
//       }
//
//       ///NOTIF API
//       try{
//         List<dynamic> receivers = [];
//         if(currentUser.followers!.length > 0){
//           currentUser.followers!.remove(currentUser.uid);
//           receivers.addAll(currentUser.followers!.toList());
//         }
//         if (feed.taggedUsers != null && feed.taggedUsers!.length > 0) {
//           receivers.addAll(feed.taggedUsers!.toList());
//         }
//         await notifyApiToSendNotifs(receivers,notification);
//       }
//       catch(e){
//         log('ERROR SENDING NOTIFS TO API $e');
//       }
//     ///END NOTIF API
//
//   }
//
//   createCommentNotification(RemaFeed feed) async {
//     var currentUser = await Session().getCurrentUser();
//     var notification = RemaNotification.simple();
//     notification.metadatas!.putIfAbsent("SEE_TARGET_COMMENT", () => feed.key);
//     notification.type = "NEW_COMMENT";
//     notification.isCliked = false;
//     notification.treated = false;
//     notification.action = "SEE_TARGET_COMMENT";
//     notification.title = "Du Nouveau sur REMA";
//     notification.body = currentUser!.fullname! + " a commenté votre publication";
//     if (feed.author != currentUser.uid) {
//       sendNotification(feed!.author!, notification);
//     }
//
//     ///NOTIF API
//     try{
//       List<dynamic> receivers = [];
//       if (feed.author != currentUser.uid) {
//         receivers.add(feed!.author.toString());
//         await notifyApiToSendNotifs(receivers,notification);
//       }
//     }
//     catch(e){
//       log('ERROR SENDING NOTIFS TO API $e');
//     }
//     ///END NOTIF API
//   }
//
//   createCommentLikeNotification(RemaFeed feed, String authorUid) async {
//     var currentUser = await Session().getCurrentUser();
//     var notification = RemaNotification.simple();
//     notification.metadatas!.putIfAbsent("SEE_TARGET_COMMENT", () => feed.key);
//     notification.type = "NEW_COMMENT";
//     notification.isCliked = false;
//     notification.treated = false;
//     notification.action = "SEE_TARGET_COMMENT";
//     notification.title = "Du Nouveau sur REMA";
//     notification.body = currentUser!.fullname! + " aime votre commentaire";
//     if (authorUid != currentUser.uid) {
//       sendNotification(authorUid, notification);
//       ///NOTIF API
//       try{
//         List<dynamic> receivers = [];
//           receivers.add(authorUid.toString());
//           await notifyApiToSendNotifs(receivers,notification);
//       }
//       catch(e){
//         log('ERROR SENDING NOTIFS TO API $e');
//       }
//       ///END NOTIF API
//     }
//   }
//
//   createCommentReplyNotification(RemaFeed feed, String authorUid) async {
//     var currentUser = await Session().getCurrentUser();
//     var notification = RemaNotification.simple();
//     notification.metadatas!.putIfAbsent("SEE_TARGET_COMMENT", () => feed.key);
//     notification.type = "NEW_SUB_COMMENT";
//     notification.isCliked = false;
//     notification.treated = false;
//     notification.action = "SEE_TARGET_COMMENT";
//     notification.title = "Du Nouveau sur REMA";
//     notification.body = currentUser!.fullname! + " a répondu à votre commentaire";
//     print('Meeee' + currentUser!.uid!);
//     if (authorUid != currentUser.uid) {
//       sendNotification(authorUid, notification);
//       ///NOTIF API
//       try{
//         List<dynamic> receivers = [];
//         receivers.add(authorUid.toString());
//         await notifyApiToSendNotifs(receivers,notification);
//       }
//       catch(e){
//         log('ERROR SENDING NOTIFS TO API $e');
//       }
//       ///END NOTIF API
//     }
//   }
//
//   createCommentTagNotification(RemaFeed feed, List<dynamic> authorsUid) async {
//     var currentUser = await Session().getCurrentUser();
//     var notification = RemaNotification.simple();
//     notification.metadatas!.putIfAbsent("SEE_TARGET_COMMENT", () => feed.key);
//     notification.type = "NEW_COMMENT";
//     notification.isCliked = false;
//     notification.treated = false;
//     notification.action = "SEE_TARGET_COMMENT";
//     notification.title = "Du Nouveau sur REMA";
//     notification.body = currentUser!.fullname! + " vous a identifié dans un commentaire";
//     authorsUid.forEach((element) {
//       sendNotification(element, notification);
//     });
//     ///NOTIF API
//     try{
//       List<dynamic> receivers = [];
//         receivers.addAll(authorsUid);
//         await notifyApiToSendNotifs(receivers,notification);
//     }
//     catch(e){
//       log('ERROR SENDING NOTIFS TO API $e');
//     }
//     ///END NOTIF API
//   }
//
//   createCommentNotificationForPrevious(RemaFeed feed) async {
//     var currentUser = await Session().getCurrentUser();
//     var notification = RemaNotification.simple();
//     notification.metadatas!.putIfAbsent("SEE_TARGET_COMMENT", () => feed.key);
//     notification.type = "NEW_COMMENT";
//     notification.isCliked = false;
//     notification.treated = false;
//     notification.action = "SEE_TARGET_COMMENT";
//     notification.title = "Du Nouveau sur REMA";
//     notification.body = currentUser!.fullname! + " a commenté une publication à laquelle vous avez reagi";
//     List<dynamic> receivers = [];
//     if (feed.comments!.length != 0) {
//       feed.comments!.forEach((element) {
//         if(element.authorUid != currentUser.uid) {
//           sendNotification(element!.authorUid!, notification);
//           try{
//             receivers.add(element!.authorUid!);
//           }
//           catch(e){
//
//           }
//         }
//       });
//     }
//     ///NOTIF API
//     if (feed.comments!.length != 0) {
//       try{
//         await notifyApiToSendNotifs(receivers,notification);
//       }
//       catch(e){
//         log('ERROR SENDING NOTIFS TO API $e');
//       }
//     }
//     ///END NOTIF API
//   }
//
//   createNewFollowingNotification(RemaUser friend) async {
//     var currentUser = await Session().getCurrentUser();
//     var notification = RemaNotification.simple();
//     notification.metadatas!.putIfAbsent("SEE_USER_PROFIL", () => currentUser?.uid!);
//     notification.type = "NEW_FOLLOWING";
//     notification.isCliked = false;
//     notification.treated = false;
//     notification.action = "SEE_USER_PROFIL";
//     notification.title = "Un nouvel ami sur REMA";
//     notification.body = currentUser!.fullname! + " vous suit désormais";
//     sendNotification(friend!.uid!, notification);
//     ///NOTIF API
//     try{
//       List<dynamic> receivers = [];
//       receivers.add(friend!.uid.toString());
//       await notifyApiToSendNotifs(receivers,notification);
//     }
//     catch(e){
//       log('ERROR SENDING NOTIFS TO API $e');
//     }
//     ///END NOTIF API
//   }
//
//   createNewMessageNotification(RemaUser friend, {RemaFeed? feed}) async{
//     var currentUser = await Session().getCurrentUser();
//     var notification = RemaNotification.simple();
//     notification.metadatas!.putIfAbsent("openchat", () => currentUser!.uid!);
//     notification.type = "CHAT";
//     notification.isCliked = false;
//     notification.treated = false;
//     notification.action = "OPEN_CHAT";
//     notification.title = "Nouveau Messages";
//     notification.body = currentUser!.putIfAbsent("SEE_TARGET_POST", () => feed!.key!);
//     notification.type = "NEW_LIKE";
//     notification.isCliked = false;
//     notification.treated = false;
//     notification.action = "SEE_TARGET_POST";
//     notification.title = "Du Nouveau sur REMA";
//     notification.body = currentUser!.fullname! + " a réagi à votre publication";
//     if (friend!.uid! != feed!.author! && feed!.author! != currentUser!.uid!) {
//       sendNotification(feed!.author!, notification);
//       ///NOTIF API
//       try{
//         List<dynamic> receivers = [];
//         receivers.add(feed!.author!.toString());
//         await notifyApiToSendNotifs(receivers,notification);
//       }
//       catch(e){
//         log('ERROR SENDING NOTIFS TO API $e');
//       }
//       ///END NOTIF API
//     }
//   }
//
//   createFeedLikeNotification (RemaUser friend, RemaFeed feed) async{
//     var currentUser = await Session().getCurrentUser();
//     var notification = RemaNotification.simple();
//     notification.metadatas!.putIfAbsent("SEE_TARGET_POST", () => feed.key);
//     notification.type = "NEW_LIKE";
//     notification.isCliked = false;
//     notification.treated = false;
//     notification.action = "SEE_TARGET_POST";
//     notification.title = "Du Nouveau sur REMA";
//     notification.body = currentUser!.fullname! + " a réagi à votre publication";
//     if (feed.author != currentUser!.uid) {
//       log('can send notif');
//       sendNotification(feed!.author!, notification);
//       ///NOTIF API
//       try{
//         log('in try send notif');
//         List<dynamic> receivers = [];
//         receivers.add(feed!.author);
//         await notifyApiToSendNotifs(receivers,notification);
//       }
//       catch(e){
//         log('ERROR SENDING NOTIFS TO API $e');
//       }
//       ///END NOTIF API
//     }
//     else{
//       log('cant send');
//     }
//   }
//
//
//   createPublicationTagNotification(RemaFeed feed) async {
//     var currentUser = await Session().getCurrentUser();
//     var notification = RemaNotification.simple();
//     notification.metadatas!.putIfAbsent("SEE_TARGET_POST", () => feed.key);
//     notification.type = "NEW_POST";
//     notification.isCliked = false;
//     notification.treated = false;
//     notification.action = "SEE_TARGET_POST";
//     notification.title = "Du Nouveau sur REMA";
//     notification.body = currentUser!.fullname! + " vous a identifié dans une publication";
//     feed.taggedUsers!.forEach((element) {
//       sendNotification(element, notification);
//     });
//
//     if(feed.taggedUsers != null && feed.taggedUsers!.length > 0){
//       ///NOTIF API
//       try{
//         List<dynamic> receivers = [];
//         receivers.addAll(feed.taggedUsers!);
//         await notifyApiToSendNotifs(receivers,notification);
//       }
//       catch(e){
//         log('ERROR SENDING NOTIFS TO API $e');
//       }
//       ///END NOTIF API
//     }
//   }
// }