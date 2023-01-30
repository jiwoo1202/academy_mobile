
import 'package:academy/screen/community/community_main_screen.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../api/pdf/pdf_api.dart';
import '../../components/button/main_button.dart';
import '../../components/controllers/firebase_cloud_messaging.dart';
import '../../components/controllers/local_notification_setting.dart';
import '../../components/controllers/notification_controller.dart';
import '../../components/font/font.dart';
import '../../firebase/firebase_user.dart';
import '../../model/user.dart';
import '../../provider/user_state.dart';
import '../community/story/story_detail_screen.dart';
import '../community/story/story_main_screen.dart';
import '../main/main_screen.dart';
import '../mypage/mypage_screen.dart';
import '../register/register_main_screen.dart';
class LoginMainScreen extends StatefulWidget {
  static final String id = '/login_main';

  const LoginMainScreen({Key? key}) : super(key: key);

  @override
  State<LoginMainScreen> createState() => _LoginMainScreenState();
}

class _LoginMainScreenState extends State<LoginMainScreen>
    with TickerProviderStateMixin {
  late TabController _nestedTabController;
  TextEditingController _studentIdController = TextEditingController();
  TextEditingController _studentPwController = TextEditingController();
  TextEditingController _teacherIdController = TextEditingController();
  TextEditingController _teacherPwController = TextEditingController();
  bool _obscureText = false;
  bool _obscureText2 = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  List _userList = [];
  @override
  void initState() {
    _nestedTabController = TabController(length: 2, vsync: this);

    LocalNotifyCation().initializeNotification();
    _requestPermissions();
    print('init 에 몇 번 들어오니????');

    ///Fcm
    FCM().setNotifications();

    // AwesomeNotifications().setListeners(
    //     onActionReceivedMethod:         NotificationController.onActionReceivedMethod,
    //     onNotificationCreatedMethod:    NotificationController.onNotificationCreatedMethod,
    //     onNotificationDisplayedMethod:  NotificationController.onNotificationDisplayedMethod,
    //     onDismissActionReceivedMethod:  NotificationController.onDismissActionReceivedMethod
    // );
    //
    // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    //   if(!isAllowed){
    //     AwesomeNotifications().requestPermissionToSendNotifications();
    //   }
    // });

    userGet('YaEDhOV20pKDnAz69ixf');
    super.initState();
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
    _studentIdController.dispose();
    _studentPwController.dispose();
    _teacherPwController.dispose();
    _teacherIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final us = Get.put(UserState());
    // final user = User().obs;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        body: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 41,
              ),
              ColoredBox(
                color: Color(0xffE9E9E9),
                child: TabBar(
                  controller: _nestedTabController,
                  unselectedLabelColor: Color(0xffA0A4A6),
                  indicatorColor: Colors.transparent,
                  indicator: BoxDecoration(color: Colors.white),
                  labelColor: Colors.black,
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        '학생',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NotoSansKr'),
                      ),
                    ),
                    Tab(
                      child: Text(
                        '선생님',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NotoSansKr'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                constraints: BoxConstraints(minHeight: 200, maxHeight: 200),
                child: TabBarView(controller: _nestedTabController, children: [
                  ///일반 회원
                  Container(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),

                        /// ID
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: TextFormField(
                                controller: _studentIdController,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'NotoSansKr',
                                    color: Color(0xff292929)),
                                enabled: true,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueGrey[200]!),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    prefixIconConstraints:
                                        BoxConstraints(minWidth: 23),
                                    hintText: '아이디를 입력해주세요',
                                    hintStyle: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'NotoSansKr',
                                        color: Colors.blueGrey[200])),
                              ),
                              width: MediaQuery.of(context).size.width * 0.9,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),

                        /// Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: TextFormField(
                                controller: _studentPwController,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'NotoSansKr',
                                    color: const Color(0xff292929)),
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.text,
                                obscureText: !_obscureText,
                                enabled: true,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueGrey[200]!),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    prefixIconConstraints:
                                        BoxConstraints(minWidth: 23),
                                    suffixIcon: !_obscureText
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.visibility_off_outlined,
                                              size: 20,
                                            ),
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            color: Colors.black,
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                          )
                                        : IconButton(
                                            icon: Icon(
                                              Icons.visibility_outlined,
                                              size: 20,
                                            ),
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            color: Colors.black,
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                          ),
                                    hintText: '비밀번호를 입력해 주세요',
                                    hintStyle: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'NotoSansKr',
                                        color: Colors.blueGrey[200])),
                              ),
                              width: MediaQuery.of(context).size.width * 0.9,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  ///Teacher
                  Container(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),

                        /// ID
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: TextFormField(
                                controller: _teacherIdController,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'NotoSansKr',
                                    color: Color(0xff292929)),
                                enabled: true,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueGrey[200]!),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    prefixIconConstraints:
                                        BoxConstraints(minWidth: 23),
                                    hintText: '아이디를 입력해주세요',
                                    hintStyle: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'NotoSansKr',
                                        color: Colors.blueGrey[200])),
                              ),
                              width: MediaQuery.of(context).size.width * 0.9,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),

                        /// Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: TextFormField(
                                controller: _teacherPwController,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'NotoSansKr',
                                    color: Color(0xff292929)),
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.text,
                                obscureText: !_obscureText2,
                                enabled: true,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueGrey[200]!),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    prefixIconConstraints:
                                        BoxConstraints(minWidth: 23),
                                    suffixIcon: !_obscureText2
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.visibility_off_outlined,
                                              size: 20,
                                            ),
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            color: Colors.black,
                                            onPressed: () {
                                              setState(() {
                                                _obscureText2 = !_obscureText2;
                                              });
                                            },
                                          )
                                        : IconButton(
                                            icon: Icon(
                                              Icons.visibility_outlined,
                                              size: 20,
                                            ),
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            color: Colors.black,
                                            onPressed: () {
                                              setState(() {
                                                _obscureText2 = !_obscureText2;
                                              });
                                            },
                                          ),
                                    hintText: '비밀번호를 입력해 주세요',
                                    hintStyle: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'NotoSansKr',
                                        color: Colors.blueGrey[200])),
                              ),
                              width: MediaQuery.of(context).size.width * 0.9,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MainButton(
                  onPressed: () async {
                    switch (_nestedTabController.index) {
                      case 0:

                        await userGet('SIg3OP2qqovlBZROIaRr');
                        Get.toNamed(BottomNavigator.id);
                        // Get.toNamed(StoryMainScreen.id);
                        break;
                      case 1:
                        // us.name.value = 'i am teacher';
                        // Get.toNamed(MainScreen.id);

                        print('선생님 로그인');
                        await userGet('N5mGm8g9a9vZWvAqh0Wc');
                        Get.toNamed(BottomNavigator.id);

                        break;
                    }
                  },
                  text: '로그인하기',
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Get.toNamed(RegisterMainScreen.id);
                          },
                          child: Text(
                            '회원가입',
                            style: f14Greyw500,
                            textAlign: TextAlign.center,
                          )),
                    ),
                    VerticalDivider(
                      color: const Color(0xffE9E9E9),
                      thickness: 0.5,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // print('123123123: ${us.userList[0].docId}');
                        },
                        child: Text(
                          '비밀번호 찾기',
                          style: f14Greyw500,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {

                            FirebaseMessaging.instance.getToken().then((value) {
                              String? token = value;
                              print('token : ${token}');
                            });

                            var androidPlatformChannelSpecifics = new AndroidNotificationDetails('ClickSoundId', 'ClickSoundChannel',
                                channelDescription: 'Click Sound Description', importance: Importance.max, priority: Priority.high);

                            var iOSPlatformChannelSpecifics = DarwinNotificationDetails( categoryIdentifier: 'ClickSoundId',);
                            var platformChannelSpecifics =
                            new NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
                            await flutterLocalNotificationsPlugin.show(
                              0,
                              'title',
                              'body',
                              platformChannelSpecifics,
                              payload: 'Default_sound',
                            );

                            // CollectionReference ref = FirebaseFirestore.instance.collection('user');
                            // QuerySnapshot snapshot = await ref
                            //     .where('phoneNumber', isEqualTo: '01081383877').get();
                            // final allData = snapshot.docs.map((doc) => doc.data()).toList();
                            // List _checkUser = allData;
                            // FcmCommunityComment().sendMessage(
                            //     userToken: 'fkmYnOzmikNcr4jqVaU7g4:APA91bExwhC1yk2oalxJan-_OypPUAj1-k5DLxWQ8NonqXMlsvClaWcY4ir0SG0LBEzkoORdnHrFtUrJIgMcpeWaWlDxQv0k9By9NfBDqrT6qDda7Q0Q2hYazsrtBZeP2iarxarKm0Yn',
                            //     title: '클릭사운드',
                            //     which:'job',
                            //     docId: '',
                            //     body: '올려주신 피드백에 답글이 달렸습니다!');


                            // AwesomeNotifications().createNotification(
                            //     content: NotificationContent(
                            //         id: 0,
                            //         channelKey: 'basic_channel',
                            //         title: 'Simple Notification',
                            //         body: 'Simple body',
                            //         actionType: ActionType.Default
                            //     ),
                            //   actionButtons: <NotificationActionButton>[
                            //     // NotificationActionButton(key: 'accept', label: 'Accept'),
                            //     // NotificationActionButton(key: 'reject', label: 'Reject'),
                            //     // NotificationActionButton(key: '11', label: '11'),
                            //     NotificationActionButton(
                            //         key: 'REPLY',
                            //         label: 'Reply Message',
                            //         requireInputText: true,
                            //         actionType: ActionType.SilentAction
                            //     ),

                                // NotificationActionButton(
                                //     key: 'DISMISS',
                                //     label: 'Dismiss',
                                //     actionType: ActionType.DismissAction,
                                //     isDangerousOption: true)
                            //   ],
                            // );
                          },
                          child: Text(
                            'tab',
                            style: f14Greyw500,
                            textAlign: TextAlign.center,
                          )),
                    ),
                    VerticalDivider(
                      color: const Color(0xffE9E9E9),
                      thickness: 0.5,
                    ),
                  ],
                ),
              ),
              // Obx(() => Text(
              //   '${us.count}',
              //   style: TextStyle(color: Colors.black),
              // )),
              //
              // TextButton(
              //   onPressed: () {
              //     us.increase();
              //     us.name.value = 'my name is ipad';
              //   },
              //   child: Text(
              //     'hello',
              //     style: TextStyle(color: Colors.black,fontSize: 24),
              //   ),
              // ),
              //
              // TextButton(
              //   onPressed: () {
              //     Get.toNamed(MainScreen.id);
              //   },
              //   child: Text(
              //     'move',
              //     style: TextStyle(color: Colors.black,fontSize: 24),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavigator extends StatefulWidget {
  static final String id = '/bottom';

  const BottomNavigator({Key? key}) : super(key: key);

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> with TickerProviderStateMixin {
  List<Widget> _widgetOptions = [];
  late TabController _bottomTabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [MainScreen(), CommunityMainScreen(),MyPageScreen()];
    _bottomTabController = TabController(length: 3, vsync: this);
    // _bottomTabController.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final us = Get.put(UserState());

    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: TabBar(
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          indicatorColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.label,
          controller: _bottomTabController,
          unselectedLabelStyle: TextStyle(fontSize: 16, fontFamily: 'NotoSansKr', fontWeight: FontWeight.w300),
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'NotoSansKr'),
          unselectedLabelColor: Colors.grey,
          labelColor: const Color(0xff3D6177),
          tabs: <Widget>[
            Tab(
              icon: _currentIndex == 0
                  ? SvgPicture.asset(
                'assets/bottom/home_click.svg',
                width: 25,
                height: 20,
              )
                  : SvgPicture.asset(
                'assets/bottom/home_not_click.svg',
                width: 25,
                height: 20,
              ),
              text: '홈',
            ),
            Tab(
              icon: _currentIndex == 1
                  ? SvgPicture.asset(
                'assets/bottom/community_click.svg',
                width: 25,
                height: 20,
              )
                  : SvgPicture.asset(
                'assets/bottom/community_not_click.svg',
                width: 25,
                height: 20,
              ),
              text: '커뮤니티',
            ),
            Tab(
              icon: _currentIndex == 2
                  ? SvgPicture.asset(
                'assets/bottom/my_profile_click.svg',
                width: 20,
                height: 20,
              )
                  : SvgPicture.asset(
                'assets/bottom/my_profile_not_click.svg',
                width: 20,
                height: 20,
              ),
              text: '마이페이지',
            ),
          ],
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        children: _widgetOptions,
        controller: _bottomTabController,
      ),
    );
  }
}
