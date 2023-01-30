// import 'dart:ui';
//
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../screen/community/job/job_hunting_screen.dart';
// import '../../screen/community/job_hunting_screen.dart';
//
// class NotificationController extends GetxController{
//   static void initioalizeNotificationService() {
//     AwesomeNotifications().initialize(null,
//         [
//           NotificationChannel(
//               channelGroupKey: 'basic_channel_group',
//               channelKey: 'basic_channel',
//               channelName: 'Basic notifications',
//               channelDescription: 'Notification channel for basic tests',
//               defaultColor: Color(0xFF9D50DD),
//               ledColor: Colors.white,
//               channelShowBadge: true,
//               enableVibration: true
//           ),
//         ],
//         channelGroups: [
//           NotificationChannelGroup(
//               channelGroupKey: 'basic_channel_group',
//               channelGroupName: 'Basic group')
//         ],
//         debug: true);
//   }
//
//   @pragma("vm:entry-point")
//   static Future <void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
//     // Your code goes here
//   }
//
//   /// Use this method to detect every time that a new notification is displayed
//   @pragma("vm:entry-point")
//   static Future <void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
//     // Your code goes here
//   }
//
//   /// Use this method to detect if the user dismissed a notification
//   @pragma("vm:entry-point")
//   static Future <void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
//     // Your code goes here
//   }
//
//   /// Use this method to detect when the user taps on a notification or action button
//   @pragma("vm:entry-point")
//   static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
//     // Your code goes here
//
//     /// Handles regular notification taps.
//     if(receivedAction.actionType == ActionType.Default || receivedAction.actionType == ActionType.SilentAction){
//       // print('receivedAction~~ ${receivedAction}');
//       Get.to(() => JobHuntingScreen());
//       if(receivedAction.id == 0){
//         if(receivedAction.buttonKeyPressed == 'accept') {
//           print('accept');
//         }
//         if(receivedAction.buttonKeyPressed == 'reject') {
//           print('reject');
//         }
//         if(receivedAction.buttonKeyPressed == '11') {
//           print('11');
//         }
//         if(receivedAction.buttonKeyPressed == 'REPLY') {
//           print('REPLY');
//           print('butoninpt: ${receivedAction.buttonKeyInput}');
//         }
//         print('액션이야~~');
//       }
//     }
//   }
//
// }