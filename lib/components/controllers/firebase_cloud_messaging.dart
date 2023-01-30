import 'dart:async';
import 'dart:convert';
import 'package:academy/util/navigator_key.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../screen/community/job/job_hunting_screen.dart';
import '../../screen/community/story/story_main_screen.dart';


Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey('data')) {
    final data = message.data['data'];
  }

  if (message.data.containsKey('notification')) {
    final notification = message.data['notification'];
  }
}

class FCM {
  final navigatorContext = globalNavigatorConnect.navigatorState.currentContext;
  final _firebaseMessaging = FirebaseMessaging.instance;
  var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final streamCtlr = StreamController<String>.broadcast();
  final titleCtlr = StreamController<String>.broadcast();
  final bodyCtlr = StreamController<String>.broadcast();

  var channel = const AndroidNotificationChannel(
    'ClickSoundId', 'fcm',
    description: 'this is fcm channel', // description
    importance: Importance.high,
  );

  setNotifications() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    foregroundNotification();

    backgroundNotification();

    terminateNotification();

    // final token =
    // _firebaseMessaging.getToken().then((value) => print('Token: $value'));
  }

  foregroundNotification() {
    FirebaseMessaging.onMessage.listen(
      (message) async {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);
        if (message.data.containsKey('data')) {
          streamCtlr.sink.add(message.data['data']);
          print('contains--------------3');
        }
        if (message.data.containsKey('notification')) {
          streamCtlr.sink.add(message.data['notification']);
          print('contains--------------4');
        }
        if (message.notification != null) {
          // print('Message also contained a notification: ${message.notification}');
          flutterLocalNotificationsPlugin.show(
              message.hashCode,
              message.notification?.title,
              message.notification?.body,
              NotificationDetails(
                  android: AndroidNotificationDetails(
                    channel.id,
                    channel.name,
                    channelDescription: channel.description,
                    icon: '@mipmap/ic_launcher',
                  ),
                  iOS: const DarwinNotificationDetails( categoryIdentifier: 'ClickSoundId'
                  )),
              payload: '${message.data['which']}');
        }
        print('asoichasohacsoi11 : ${message.notification!.title!}');
        print('asoichasohacsoi22 : ${message.notification!.body!}');
        print('asoichasohacsoi33 : ${message.data['which']}');
        // up.fcmDocId = '${message.data['docId']}';
        titleCtlr.sink.add(message.notification!.title!);
        bodyCtlr.sink.add(message.notification!.body!);
      },
    );
  }

  backgroundNotification() async {
    // final UserProvider up = Provider.of<UserProvider>(navigatorContext!, listen: false);

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        if (message.data.containsKey('data')) {
          streamCtlr.sink.add(message.data['data']);
          print('contains--------------1');
        }
        if (message.data.containsKey('notification')) {
          streamCtlr.sink.add(message.data['notification']);
          print('contains--------------2');
        }
        // if (message.notification != null) {
        //   // print('Message also contained a notification: ${message.notification}');
        //   flutterLocalNotificationsPlugin.show(
        //       message.hashCode,
        //       message.notification?.title,
        //       message.notification?.body,
        //       NotificationDetails(
        //           android: AndroidNotificationDetails(
        //             channel.id,
        //             channel.name,
        //             channelDescription: channel.description,
        //             icon: '@mipmap/ic_launcher',
        //           ),
        //           iOS: const IOSNotificationDetails(
        //             badgeNumber: 1,
        //             subtitle: 'the subtitle',
        //             sound: 'slow_spring_board.aiff',
        //           )),
        //       payload: '${message.data['which']}');
        // }
        print('ㄴㄹㅁㄴㅁㅁㅁㅁ : ${message.notification!.title!}');
        print('ㄴㄹㅁㄴㅁㅁㅁㅁ22 : ${message.notification!.body!}');
        print('ㄴㄹㅁㄴㅁㅁㅁㅁ33 : ${message.data['which']}');
        if(message.data['which'] == 'mystory'){
          Get.to(StoryMainScreen());
          // Navigator.push(navigatorContext!, MaterialPageRoute(builder: (context) => MyStoryDetailScreen(
          //   fcm: '${message.data['docId']}',
          // )));
        }else if(message.data['which'] == 'job'){
          Get.to(JobHuntingScreen());
          // Navigator.push(navigatorContext!, MaterialPageRoute(builder: (context) => MyHospitalStoryDetailScreen(
          //   fcm: '${message.data['docId']}',
          // )));
        }else if(message.data['which'] == 'mypage'){
          // Navigator.push(navigatorContext!, MaterialPageRoute(builder: (context) => QnaDetailScreen(
          //   fcm: '${message.data['docId']}',
          // )));
        }
        // up.fcmDocId = '${message.data['docId']}';
        titleCtlr.sink.add(message.notification!.title!);
        bodyCtlr.sink.add(message.notification!.body!);
      },
    );
  }

  terminateNotification() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      if (initialMessage.data.containsKey('data')) {
        streamCtlr.sink.add(initialMessage.data['data']);
        print('contains--------------5');
      }
      if (initialMessage.data.containsKey('notification')) {
        streamCtlr.sink.add(initialMessage.data['notification']);
        print('contains--------------6');
      }

      print('ㅋㅋㅋㅋㅋ : ${initialMessage.notification!.title!}');
      print('ㅋㅋㅋㅋㅋㅋ22 : ${initialMessage.notification!.body!}');
      print('ㅋㅋㅋㅋㅋㅋ33 : ${initialMessage.data['which']}');

      if(initialMessage.data['which'] == 'mystory'){
        Get.to(StoryMainScreen());
      }else if(initialMessage.data['which'] == 'job'){
        Get.to(JobHuntingScreen());
      }else if(initialMessage.data['which'] == 'mypage'){
        // Navigator.push(navigatorContext!, MaterialPageRoute(builder: (context) => QnaDetailScreen(
        //   fcm: '${initialMessage.data['docId']}',
        // )));
      }
      titleCtlr.sink.add(initialMessage.notification!.title!);
      bodyCtlr.sink.add(initialMessage.notification!.body!);
    }
  }

  dispose() {
    streamCtlr.close();
    bodyCtlr.close();
    titleCtlr.close();
  }
}

class FCMController {
  final String _serverKey =
      "AAAA6RlPOZ0:APA91bHl4TNWSQH8O9s83Qbof11BZgLGrBH3AdM0zZiM4C_152I19xwVS_V8pDQ3aJmw3s88V07pGf9sHy41NsGtuFtJqqkB6rrGPjDlXjHG4U_y3fjfQFqacWW4ppIrVJPbjASu38mp";

  Future<void> sendMessage({
    required String userToken,
    required String title,
    required String body,
  }) async {
    http.Response response;

    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    try {
      response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'key=$_serverKey'},
          body: jsonEncode({
            'notification': {'title': title, 'body': body, 'sound': 'true'},
            'ttl': '60s',
            "content_available": true,
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              "action": 'clickSound',
            },
            // 'topic': 'community',
            // 상대방 토큰 값, to -> 단일, registration_ids -> 여러명
            'to': userToken
            // 'registration_ids': tokenList
          }));
    } catch (e) {
      print('error $e');
    }
  }
}

class FcmCommunityComment {
  final String _serverKey =
      "AAAA6RlPOZ0:APA91bHl4TNWSQH8O9s83Qbof11BZgLGrBH3AdM0zZiM4C_152I19xwVS_V8pDQ3aJmw3s88V07pGf9sHy41NsGtuFtJqqkB6rrGPjDlXjHG4U_y3fjfQFqacWW4ppIrVJPbjASu38mp";

  // final navigatorContext = globalNavigatorConnect.navigatorState.currentContext;
  Future<void> sendMessage({
    required String userToken,
    required String title,
    required String body,
    required String which,
    required String docId,
  }) async {
    http.Response response;

    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // final UserProvider up = Provider.of<UserProvider>(navigatorContext!,listen: false);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    try {
      // up.messageInt = 1;
      response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'key=$_serverKey'},
          body: jsonEncode({
            'notification': {'title': title, 'body': body, 'sound': 'true'},
            // 'ttl': '60s',
            // "content_available": true,
            "data": {
              "which": "$which",
              "docId" : "$docId",
              "click_action": "FLUTTER_NOTIFICATION_CLICK"
            },

            // 'to': '/topics/community',
            // "registration_ids": userToken,
            // 상대방 토큰 값, to -> 단일, registration_ids -> 여러명
            'to': userToken,

            // 'registration_ids': [userToken]
          }));
    } catch (e) {
      print('error $e');
    }
  }
}
