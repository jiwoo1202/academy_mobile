import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'firebase_cloud_messaging.dart';

class NotificationMain extends StatefulWidget {
  static final String id = '/notification';

  const NotificationMain({Key? key}) : super(key: key);

  @override
  State<NotificationMain> createState() => _NotificationMainState();
}

class _NotificationMainState extends State<NotificationMain> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';

  @override
  void initState() {
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();

    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);
    setupInteractedMessage();

    super.initState();
  }

  _changeData(String msg) => setState(() => notificationData = msg);

  _changeBody(String msg) => setState(() => notificationBody = msg);

  _changeTitle(String msg) => setState(() => notificationTitle = msg);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
                onTap: () async {
                  print('notification in----');
                  // LocalNotifyCation().displayNotification(
                  //     title: '로컬 알람 테스트입니다', body: '여길 클릭 하면 페이지로 이동 됩니다.');
                },
                child: Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.clear,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                )),
          ],
          title: Text(
            '알림',
            style: TextStyle(fontSize: 20, color: Colors.black, fontFamily: 'NotoSansKr'),
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        // body: Center(
        //   child:  Column(
        //     children: [
        //       TextButton(
        //         onPressed: () async {
        //           LocalNotifyCation().displayNotification(
        //               title:'로컬 알람 테스트입니다',
        //               body:'여길 클릭 하면 페이지로 이동 됩니다.'
        //           );
        //         },
        //         child: Text(
        //             '알림 테스트'
        //         ),
        //       ),
        //
        //       TextButton(
        //         onPressed: () async {
        //           LocalNotifyCation().displayCommunityNotification(
        //               title:'로컬 알람 커뮤니티 테스트입니다',
        //               body:'여길 클릭 하면 페이지로 이동 됩니다.'
        //           );
        //         },
        //         child: Text(
        //             '알림222 테스트'
        //         ),
        //       ),
        //
        //       Text(
        //         "Flutter Notification Details",
        //         style: Theme.of(context).textTheme.headline4,
        //       ),
        //       const SizedBox(height: 20),
        //       Text(
        //         "Notification Title:-  $notificationTitle",
        //         style: Theme.of(context).textTheme.headline6,
        //       ),
        //       Text(
        //         "Notification Body:-  $notificationBody",
        //         style: Theme.of(context).textTheme.headline6,
        //       ),
        //     ],
        //   ),
        // ),
        body: ListView.builder(
          itemCount: 1,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      '${DateFormat('y.MM.dd H:mm').format(DateTime.now())}',
                      style: TextStyle(color: Colors.grey, fontFamily: 'NotoSansKr', fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '$notificationTitle에 $notificationBody라고 달렸어요',
                        style: TextStyle(color: Colors.black, fontFamily: 'NotoSansKr', fontSize: 13),
                      )),
                  SizedBox(
                    height: 12,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  TextButton(
                      onPressed: () async {
                        setupInteractedMessage();
                        // var token = await FirebaseMessaging.instance.getToken();
                        // print('get token : ${token}');
                        // FCMController().sendMessage(userToken: 'fuoYIWm8TIWe5wARfb9rAp:APA91bFXb58kusPMe8rktkRsrqF1eNhDPMYIOV0Vsc-mOHJDSEYHLAZVtCqUjK8735kyA829PnSaXGJPimHn5OtCKcU8lH75esTz3LUlb5FJCWvxrP5Xfkts-BHirVjIfdALNOCs1cUM', title: 'test app', body: 'app to app');
                      },
                      child: Text('token'))
                ],
              ),
            );
          },
        ));
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['screen'] == 'screenA') {
      print('it is correct!');
    } else {
      print('what??? : ${message.data['screen']}');
    }
  }
}
