import 'package:academy/components/tile/textform_field.dart';
import 'package:academy/screen/community/community_main_screen.dart';
import 'package:academy/screen/login/findPassword.dart';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../api/pdf/pdf_api.dart';
import '../../components/button/main_button.dart';
import '../../components/controllers/firebase_cloud_messaging.dart';
import '../../components/controllers/local_notification_setting.dart';
import '../../components/controllers/notification_controller.dart';
import '../../components/dialog/showAlertDialog.dart';
import '../../firebase/firebase_log.dart';
import '../../firebase/firebase_user.dart';
import '../../model/user.dart';
import '../../provider/user_state.dart';
import '../../util/colors.dart';
import '../../util/font/font.dart';
import '../community/story/story_detail_screen.dart';
import '../community/story/story_main_screen.dart';
import '../main/main_screen.dart';
import '../mypage/mypage_screen.dart';
import '../mypage/setting/setting_main_screen.dart';
import '../register/register_main_screen.dart';
// class SplashScreen extends StatelessWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: Future.delayed(Duration(seconds: 3)),
//         builder: (splashContext, snapshot){
//           if(snapshot.connectionState == ConnectionState.waiting) {
//             return Splash();
//           } else {
//             return LoginMainScreen();
//           }
//         });
//   }
// }

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
  String userInfo = "";
  String userpw = '';
  String usertype = '';

  // final userData = GetStorage('user');
  static final storage = new FlutterSecureStorage();
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  List _userList = [];
  int type = 0;

  void initialization() async{
    await Future.delayed(Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  @override
  void initState() {
    _nestedTabController = TabController(length: 2, vsync: this);

    initialization();
    // LocalNotifyCation().initializeNotification();
    // _requestPermissions();

    ///Fcm
    // FCM().setNotifications();
      _asyncMethod();

    // userData.writeIfNull('isLogged', true);
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

    // userGet('YaEDhOV20pKDnAz69ixf');
    super.initState();

  }
  _asyncMethod() async{
    final us = Get.put(UserState());
    userInfo = (await storage.read(key: "isLogged"))!;
    userpw = (await storage.read(key: "pw"))!;


    if(userInfo != null){
      // 로그인
        await userGet(userInfo, userpw);
        await loginLogCheck('${us.userList[0].id}','${us.userList[0].nickName}');
        Get.toNamed(BottomNavigator.id);
    }
  }
  // void _requestPermissions() {
  //   flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           IOSFlutterLocalNotificationsPlugin>()
  //       ?.requestPermissions(
  //         alert: true,
  //         badge: true,
  //         sound: true,
  //       );
  // }

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
        appBar: AppBar(
          title: Text("ACADEMY"),
          backgroundColor: nowColor,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(44),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 205, 0),
              child: TabBar(
                controller: _nestedTabController,
                unselectedLabelColor: Color(0xffA0A4A6),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400),
                indicatorColor: Colors.transparent,
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: Colors.white, width: 5),
                    insets: EdgeInsets.symmetric(horizontal: 60)),
                labelColor: Colors.black,
                onTap: (int) {
                  setState(() {
                    type = _nestedTabController.index;
                  });
                },
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      '학생',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          color: Colors.white),
                    ),
                  ),
                  Tab(
                    child: Text(
                      '선생님',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              type == 0
                  ? Text(
                      '학생 로그인',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          fontSize: 24),
                    )
                  : Text(
                      '선생님 로그인',
                      style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          fontSize: 24),
                    ),
              SizedBox(
                height: 25,
              ),
              TextFormFields(
                  controller:
                      type == 0 ? _studentIdController : _teacherIdController,
                  obscureText: true,
                  hintText: '아이디를 입력해주세요',
                  surffixIcon: "0"),
              SizedBox(
                height: 16,
              ),
              TextFormFields(
                  controller:
                      type == 0 ? _studentPwController : _teacherPwController,
                  obscureText: _obscureText,
                  hintText: '비밀번호를 입력해 주세요',
                  surffixIcon: "1",
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  }),
              SizedBox(
                height: 16,
              ),
              MainButton(
                onPressed: () async {
                  switch (_nestedTabController.index) {
                    case 0:
                      if (_studentIdController.text == '' ||
                          _studentPwController.text == '') {
                        showOnlyLoginCheckDialog(context, '아이디 또는 비밀번호를 입력해주세요',
                            () {
                          Navigator.pop(context);
                        });
                      } else {
                        await userGet(_studentIdController.text,
                            _studentPwController.text);
                        setState(() {
                        });
                        if (us.userList.isEmpty) {
                          showOnlyLoginCheckDialog(context, '유저 정보가 없습니다', () {
                            Navigator.pop(context);
                          });
                          return;
                        }
                        else if(us.pwCheck.value == '1'){

                          showOnlyConfirmDialog(context, '비밀번호가 일치하지 않습니다.');
                        }
                        else if(us.userList[0].userType=='학생'){
                          Get.toNamed(BottomNavigator.id);
                          // userData.write('id', _studentIdController.text);
                          // userData.write('pw',_studentPwController.text);
                          await storage.write(key: "isLogged", value: _studentIdController.text);
                          await storage.write(key: "pw", value: _studentPwController.text);
                          await loginLogCheck('${us.userList[0].id}','${us.userList[0].nickName}');
                        }
                        else{
                          showOnlyConfirmDialog(context, "유저정보가 없습니다.");
                        }
                      }
                      break;
                    case 1:

                      if (_teacherIdController.text == '' ||
                          _teacherPwController.text == '') {
                        showOnlyLoginCheckDialog(context, '아이디 또는 비밀번호를 입력해주세요',
                            () {
                          Navigator.pop(context);
                        });
                      } else {
                         await userGet(_teacherIdController.text,
                            _teacherPwController.text);
                        if (us.userList.isEmpty) {
                          showOnlyLoginCheckDialog(context, '유저정보가 없습니다', () {
                            Navigator.pop(context);
                          });
                          return;
                        }else if(us.pwCheck.value == '1'){

                          showOnlyConfirmDialog(context, '비밀번호가 일치하지 않습니다.');
                        }
                        else if(us.userList[0].userType=='선생님'){

                            // userData.write('id', _teacherIdController.text);
                            // userData.write('pw', _teacherPwController.text);
                            // userData.write('userType', '선생님');
                            // userData.write('isLogged',true);
                            // print(userData.read('isLogged'));
                            await storage.write(key: "isLogged", value: _teacherIdController.text);
                            await storage.write(key: "pw", value: _teacherPwController.text);
                            await loginLogCheck('${us.userList[0].id}','${us.userList[0].nickName}');

                          Get.toNamed(BottomNavigator.id);
                        }
                        else{
                          showOnlyConfirmDialog(context, "유저정보가 없습니다.");
                        }
                      }
                      break;
                  }
                },
                text: '로그인하기',
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 26),
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.toNamed(RegisterMainScreen.id);
                },
                child: Container(
                  height: 69,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 2, color: Color(0xffDADADA)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '회원가입',
                        style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 16,
                            color: Color(0xff535353)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {

                  Get.to(()=>FindPassword());
                },
                child: Container(
                  height: 69,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 2, color: Color(0xffDADADA)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '비밀번호 찾기',
                        style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 16,
                            color: Color(0xff535353)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
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
        padding: const EdgeInsets.only(top: 19, bottom: 41),
        child: TabBar(
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          indicatorColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.label,
          controller: _bottomTabController,
          unselectedLabelStyle: f16w700greyA,
          labelStyle: f16w700,
          unselectedLabelColor: Colors.grey,
          labelColor: const Color(0xff3D6177),
          tabs: <Widget>[
            Tab(
              icon: _currentIndex == 0
                  ? SvgPicture.asset(
                'assets/bottom/home_click.svg',
                width: Get.width * 0.3,
                height: Get.height * 0.05,
              )
                  : SvgPicture.asset(
                'assets/bottom/home_not_click.svg',
                width: Get.width * 0.3,
                height: Get.height * 0.05,
              ),
              // text: '홈',
            ),
            Tab(
              icon: _currentIndex == 1
                  ? SvgPicture.asset(
                'assets/bottom/community_click.svg',
                width: Get.width * 0.3,
                height: Get.height * 0.05,
              )
                  : SvgPicture.asset(
                'assets/bottom/community_not_click.svg',
                width: Get.width * 0.3,
                height: Get.height * 0.05,
              ),
              // text: '커뮤니티',
            ),
            Tab(
              icon: _currentIndex == 2
                  ? SvgPicture.asset(
                'assets/bottom/my_profile_click.svg',
                width: Get.width * 0.3,
                height: Get.height * 0.05,
              )
                  : SvgPicture.asset(
                'assets/bottom/my_profile_not_click.svg',
                width: Get.width * 0.3,
                height: Get.height * 0.05,
              ),
              // text: '마이페이지',
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

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            width: Get.width,
            height: Get.height,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/academy_splash.png'), fit: BoxFit.contain)
            ),
          ),
        )
    );
  }
}