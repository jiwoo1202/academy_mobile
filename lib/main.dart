
import 'package:academy/screen/community/job/job_hunting_request_screen.dart';
import 'package:academy/screen/login/login_main_screen.dart';
import 'package:academy/screen/mypage/blockPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  print('-- WidgetsFlutterBinding.ensureInitialized');
  // NotificationController.initioalizeNotificationService();
  // print('-- NotificationController.initioalizeNotificationService');
  await Firebase.initializeApp();
  print('-- main: Firebase.initializeApp');

  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
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

        //setting
        SettingMainScreen.id : (_) => SettingMainScreen(),

        //main screen
        MainScreen.id : (_) => MainScreen(),
      },
    );
  }
}
