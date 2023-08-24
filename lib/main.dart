
import 'package:academy/screen/community/job/job_hunting_request_screen.dart';
import 'package:academy/screen/login/login_main_screen.dart';
import 'package:academy/screen/mypage/blockPage.dart';
import 'package:academy/screen/mypage/job_setting_screen.dart';
import 'package:academy/screen/mypage/qna/qna.dart';
import 'package:academy/screen/register/policy.dart';
import 'package:academy/screen/register/privatePolicy.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import 'components/controllers/notification_controller.dart';
import 'screen/community/community_main_screen.dart';
import 'screen/community/story/story_detail_screen.dart';
import 'screen/community/story/story_main_screen.dart';
import 'screen/community/story/story_write_screen.dart';
import 'screen/main/main_screen.dart';
import 'screen/main/main_search_screen.dart';
import 'screen/mypage/score/score_check_screen.dart';
import 'screen/mypage/setting/setting_main_screen.dart';
import 'screen/register/register_main_screen.dart';

void main() async {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  print('-- WidgetsFlutterBinding.ensureInitialized');
  // NotificationController.initioalizeNotificationService();
  // print('-- NotificationController.initioalizeNotificationService');
  await Firebase.initializeApp();
  print('-- main: Firebase.initializeApp');
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // await GetStorage.init('user');
  runApp(MyApp());
}


 class MyApp extends StatelessWidget {
  // final userData = GetStorage();
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      builder: (context,child){
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1), child: child!);
      },
      debugShowCheckedModeBanner: false,
      title: 'academy',
      home: LoginMainScreen(),
      routes: {
        //register
        RegisterMainScreen.id : (_) => RegisterMainScreen(),

        //bottom
        BottomNavigator.id : (_) => BottomNavigator(),

        //login
        LoginMainScreen.id : (_) => LoginMainScreen(),

        //search
        MainSearchScreen.id : (_) => MainSearchScreen(),

        //community
        CommunityMainScreen.id : (_) => CommunityMainScreen(),
        JobHuntingRequestScreen.id : (_) => JobHuntingRequestScreen(),
        StoryMainScreen.id : (_) => StoryMainScreen(),
        StoryWriteScreen.id : (_) => StoryWriteScreen(),
        // StoryDetailScreen.id : (_) => StoryDetailScreen(),

        //test
        // TestMainScreen.id : (_) => TestMainScreen(),

        //score
        ScoreCheckScreen.id : (_) => ScoreCheckScreen(),
        //block
        BlockPage.id : (_)=> BlockPage(),
        //policy
        PolicyPage.id :(_)=>PolicyPage(),
        PrivatePolicy.id: (_) =>PrivatePolicy(),
       //setting
        SettingMainScreen.id : (_) => SettingMainScreen(),
        JobSettingScreen.id: (_)=> JobSettingScreen(),
        //qna
        QnaPage.id:(_) => QnaPage(),
        //main screen
        MainScreen.id : (_) => MainScreen(),
      },
    );
  }
}
