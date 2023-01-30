import 'dart:typed_data';
import 'package:academy/util/navigator_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../screen/community/job/job_hunting_screen.dart';
import '../../screen/community/story/story_main_screen.dart';

class LocalNotifyCation {
  final navigatorContext = globalNavigatorConnect.navigatorState.currentContext;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //initialized
  Future<void> initializeNotification() async {
    tz.initializeTimeZones();
    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    notificationCategories: darwinNotificationCategories);

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // <- default icon name is @mipmap/ic_launcher

    final InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );


    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground);
  }

  notificationTapBackground(NotificationResponse notificationResponse) {
    // handle action
  }

  Future onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    print('test notification print');
  }

  final List<DarwinNotificationCategory> darwinNotificationCategories =
  <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      'ClickSoundId',
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      'plain',
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          'id_3',
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];

  displayNotification({required String title, required String body}) async {
    print("display notification here");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails('ClickSoundId', 'ClickSoundChannel',
        channelDescription: 'Click Sound Description', importance: Importance.max, priority: Priority.high);

    var iOSPlatformChannelSpecifics = DarwinNotificationDetails( categoryIdentifier: 'ClickSoundId',);
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_sound',
    );
  }

  displayCommunityNotification({required String title, required String body}) async {
    print("display community notification here");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'ClickSoundCommunityId', 'ClickSoundCommunityChannel',
        channelDescription: 'Click Sound Community Description', importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new DarwinNotificationDetails( categoryIdentifier: 'plain',);
    var platformChannelSpecifics =
        new NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_sound',
    );
  }

  // scheduledNotification() async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'daily scheduled notification title',
  //       'daily scheduled notification body',
  //       _nextInstanceOfTenAM(),
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails('daily notification channel id',
  //             'daily notification channel name',
  //             channelDescription: 'daily notification description'),
  //       ),
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //       UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time);
  // }

  scheduleDailyTenPMNotification(int hour, int minutes) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        '${hour}시$minutes분이 되었습니다',
        '턱 관절 운동 시작하세요',
        setPmTime(hour, minutes),
        const NotificationDetails(
          android: AndroidNotificationDetails('ClickSoundId', 'ClickSoundChannel',
              channelDescription: 'Click Sound Description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  scheduleDailyTenAMNotification(int hour, int minutes) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        '${hour}시$minutes분이 되었습니다',
        '턱 관절 운동 시작하세요',
        setTime(hour, minutes),
        const NotificationDetails(
          android: AndroidNotificationDetails('ClickSoundId', 'ClickSoundChannel',
              channelDescription: 'Click Sound Description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  scheduleDailyFirstNotification(int hour, int minutes, String notiString, String payload, bool isSound) async {
    final Int64List vibrationPattern = Int64List(2);
    print('----first noti in -----');

    vibrationPattern[0] = 0;
    vibrationPattern[1] = 2000;
    // vibrationPattern[2] = 15000;
    // vibrationPattern[3] = 2000;
    await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        '${hour}시$minutes분이 되었습니다',
        '같이\n$notiString해볼까요?',
        setFirstTime(hour, minutes),
        NotificationDetails(
          android: AndroidNotificationDetails('ClickSoundId', 'healthNotification',
              channelDescription: 'Click Sound Description',
              vibrationPattern: vibrationPattern,
              styleInformation: BigTextStyleInformation(''),
          ),
        ),
        // NotificationDetails(
        //   android: AndroidNotificationDetails('ClickSoundId2', 'healthNotificationisMuted',
        //       channelDescription: 'Click Sound Description',
        //       playSound: false,
        //       // vibrationPattern: vibrationPattern,
        //       enableVibration: false,
        //       styleInformation: BigTextStyleInformation('')),
        // ),
        androidAllowWhileIdle: true,
        payload: payload,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  scheduleDailySecondNotification(int hour, int minutes, String notiString, String payload, bool isSound) async {
    final Int64List vibrationPattern = Int64List(2);

    vibrationPattern[0] = 0;
    vibrationPattern[1] = 2000;
    await flutterLocalNotificationsPlugin.zonedSchedule(
        2,
        '${hour}시$minutes분이 되었습니다',
        '같이\n$notiString해볼까요?',
        setSecondTime(hour, minutes),
        NotificationDetails(
          android: AndroidNotificationDetails('ClickSoundId', 'healthNotification',
              channelDescription: 'Click Sound Description',
              vibrationPattern: vibrationPattern,
              styleInformation: BigTextStyleInformation('')),
        ),
        // NotificationDetails(
        //   android: AndroidNotificationDetails('ClickSoundId2', 'healthNotificationisMuted',
        //       channelDescription: 'Click Sound Description',
        //       playSound: false,
        //       // vibrationPattern: vibrationPattern,
        //       enableVibration: false,
        //       styleInformation: BigTextStyleInformation('')),
        // ),
        androidAllowWhileIdle: true,
        payload: payload,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  scheduleDailyThirdNotification(int hour, int minutes, String notiString, String payload, bool isSound) async {
    final Int64List vibrationPattern = Int64List(2);

    vibrationPattern[0] = 0;
    vibrationPattern[1] = 2000;

    await flutterLocalNotificationsPlugin.zonedSchedule(
        3,
        '${hour}시$minutes분이 되었습니다',
        '같이\n$notiString해볼까요?',
        setThirdTime(hour, minutes),
        NotificationDetails(
          android: AndroidNotificationDetails('ClickSoundId', 'healthNotification',
              channelDescription: 'Click Sound Description',
              vibrationPattern: vibrationPattern,
              styleInformation: BigTextStyleInformation('')),
        ),
        // NotificationDetails(
        //   android: AndroidNotificationDetails('ClickSoundId2', 'healthNotificationisMuted',
        //       channelDescription: 'Click Sound Description',
        //       playSound: false,
        //       // vibrationPattern: vibrationPattern,
        //       enableVibration: false,
        //       styleInformation: BigTextStyleInformation('')),
        // ),
        androidAllowWhileIdle: true,
        payload: payload,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  scheduleDailyFourthNotification(int hour, int minutes, String notiString, String payload, bool isSound) async {
    final Int64List vibrationPattern = Int64List(2);

    vibrationPattern[0] = 0;
    vibrationPattern[1] = 2000;

    await flutterLocalNotificationsPlugin.zonedSchedule(
        4,
        '${hour}시$minutes분이 되었습니다',
        '같이\n$notiString해볼까요?',
        setFourthTime(hour, minutes),
        NotificationDetails(
          android: AndroidNotificationDetails('ClickSoundId', 'healthNotification',
              channelDescription: 'Click Sound Description',
              vibrationPattern: vibrationPattern,
              styleInformation: BigTextStyleInformation('')),
        ),
        // ) :
        // NotificationDetails(
        //   android: AndroidNotificationDetails('ClickSoundId2', 'healthNotificationisMuted',
        //       channelDescription: 'Click Sound Description',
        //       playSound: false,
        //       // vibrationPattern: vibrationPattern,
        //       enableVibration: false,
        //       styleInformation: BigTextStyleInformation('')),
        // ),
        androidAllowWhileIdle: true,
        payload: payload,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  scheduleDailyFifthNotification(int hour, int minutes, String notiString, String payload, bool isSound) async {
    final Int64List vibrationPattern = Int64List(2);

    vibrationPattern[0] = 0;
    vibrationPattern[1] = 2000;

    await flutterLocalNotificationsPlugin.zonedSchedule(
        5,
        '${hour}시$minutes분이 되었습니다',
        '같이\n$notiString해볼까요?',
        setFifthTime(hour, minutes),
        NotificationDetails(
          android: AndroidNotificationDetails('ClickSoundId', 'healthNotification',
              channelDescription: 'Click Sound Description',
              vibrationPattern: vibrationPattern,
              styleInformation: BigTextStyleInformation('')),
        ),
        // ) :
        // NotificationDetails(
        //   android: AndroidNotificationDetails('ClickSoundId2', 'healthNotificationisMuted',
        //       channelDescription: 'Click Sound Description',
        //       playSound: false,
        //       // vibrationPattern: vibrationPattern,
        //       enableVibration: false,
        //       styleInformation: BigTextStyleInformation('')),
        // ),
        androidAllowWhileIdle: true,
        payload: payload,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  scheduleDailySixthNotification(int hour, int minutes, String notiString, String payload, bool isSound) async {
    final Int64List vibrationPattern = Int64List(2);

    vibrationPattern[0] = 0;
    vibrationPattern[1] = 2000;
    await flutterLocalNotificationsPlugin.zonedSchedule(
        6,
        '${hour}시$minutes분이 되었습니다',
        '같이\n$notiString해볼까요?',
        setSixthTime(hour, minutes),
        NotificationDetails(
          android: AndroidNotificationDetails('ClickSoundId', 'healthNotification',
              channelDescription: 'Click Sound Description',
              vibrationPattern: vibrationPattern,
              styleInformation: BigTextStyleInformation('')),
        ),
        // ) :
        // NotificationDetails(
        //   android: AndroidNotificationDetails('ClickSoundId2', 'healthNotificationisMuted',
        //       channelDescription: 'Click Sound Description',
        //       playSound: false,
        //       // vibrationPattern: vibrationPattern,
        //       enableVibration: false,
        //       styleInformation: BigTextStyleInformation('')),
        // ),
        androidAllowWhileIdle: true,
        payload: payload,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  scheduleDailyDrugNotification(String body, int hour, int minutes, String payload, int index) async {
    final Int64List vibrationPattern = Int64List(2);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 2000;
    await flutterLocalNotificationsPlugin.zonedSchedule(
        index,
        '${hour > 12 ? '오후' : '오전'}'
            '${hour > 12 ? hour - 12 < 10 ? '0${hour - 12}' : '${hour - 12}' : '${hour}'}' //hour < 10 ? '0${hour}' : '${hour}'
            ':${minutes < 10 ? '0${minutes}' : '${minutes}'} 설정된 약 복용시간입니다',
        body,
        setSixthTime(hour, minutes),
        NotificationDetails(
          android: AndroidNotificationDetails('ClickSoundId2', 'DrugNotification',
              channelDescription: 'Click Sound Drug List Description',
              vibrationPattern: vibrationPattern,
              styleInformation: BigTextStyleInformation(''),
              largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
              importance: Importance.max, priority: Priority.high),
        ),
        // ) :
        // NotificationDetails(
        //   android: AndroidNotificationDetails('ClickSoundId2', 'healthNotificationisMuted',
        //       channelDescription: 'Click Sound Description',
        //       playSound: false,
        //       // vibrationPattern: vibrationPattern,
        //       enableVibration: false,
        //       styleInformation: BigTextStyleInformation('')),
        // ),
        androidAllowWhileIdle: true,
        payload: payload,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future<void> cancelHealthId() async {
    print('cancel health notification');

    await FlutterLocalNotificationsPlugin().cancel(1);
    await FlutterLocalNotificationsPlugin().cancel(2);
    await FlutterLocalNotificationsPlugin().cancel(3);
    await FlutterLocalNotificationsPlugin().cancel(4);
    await FlutterLocalNotificationsPlugin().cancel(5);
    await FlutterLocalNotificationsPlugin().cancel(6);
  }

  Future<void> deletingAll() async {
    print('deleting all notification');
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      print('notification payload333333: $payload');

      switch (payload) {
        case 'mystory' :
          Get.to(StoryMainScreen());
          //Navigator.push(navigatorContext!, MaterialPageRoute(builder: (context) => ChinStretchScreen()));
          break;
        case 'job' :
          Get.to(JobHuntingScreen());
          break;
        case 'mypage' :
          break;
        // case 'myhospital' :
        //   await Navigator.push(navigatorContext!, MaterialPageRoute(builder: (context) => MyHospitalStoryDetailScreen(
        //     fcm: '${up.fcmDocId}',
        //   )));
        //   break;
      }
    }
  }

  Future<void> CallNoti(String notiString, String payload) async {
    await LocalNotifyCation().scheduleDailyFirstNotification(int.parse('${DateTime.now().hour}'),
        int.parse('${DateTime.now().minute}'), notiString, payload, false);
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  tz.TZDateTime setTime(int hour, int minutes) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    return scheduledDate;
  }

  tz.TZDateTime setPmTime(int hour, int minutes) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    return scheduledDate;
  }

  tz.TZDateTime setFirstTime(int hour, int minutes) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    return scheduledDate;
  }

  tz.TZDateTime setSecondTime(int hour, int minutes) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    return scheduledDate;
  }

  tz.TZDateTime setThirdTime(int hour, int minutes) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    return scheduledDate;
  }

  tz.TZDateTime setFourthTime(int hour, int minutes) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    return scheduledDate;
  }

  tz.TZDateTime setFifthTime(int hour, int minutes) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    return scheduledDate;
  }

  tz.TZDateTime setSixthTime(int hour, int minutes) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    return scheduledDate;
  }

  Future<void> cancelNotification(int cancel) async {
    await flutterLocalNotificationsPlugin.cancel(cancel);
  }
}
