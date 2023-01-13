
import 'package:academy/screen/login/login_main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screen/main_screen.dart';

void main() async {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  print('-- WidgetsFlutterBinding.ensureInitialized');
  await Firebase.initializeApp();
  print('-- main: Firebase.initializeApp');

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      title: 'academy',
      home: LoginMainScreen(),
      routes: {
        //login
        LoginMainScreen.id : (_) => LoginMainScreen(),

        //main screen
        MainScreen.id : (_) => MainScreen(),
      },
    );
  }
}
