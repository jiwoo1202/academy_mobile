import 'package:academy/components/font/font.dart';
import 'package:academy/screen/mypage/setting/setting_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../firebase/firebase_user.dart';
import 'score/score_check_screen.dart';

class MyPageScreen extends StatefulWidget {
  static final String id = '/bottom';

  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        leading: Container(),
        title: Text('마이페이지'),
        backgroundColor: Colors.lightGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 20),
        child: Column(
         children: [
           ListTile(
             leading: Icon(
               Icons.score,
               color: Colors.grey[850],
               size: 40,
             ),
             title: Text('내 점수 확인',style: f20w500,),
             onTap: () {
               Get.toNamed(ScoreCheckScreen.id);
               print('점수');
             },
             trailing: Icon(Icons.add,size: 40,),
           ),
           ListTile(
             leading: Icon(
               Icons.settings,
               color: Colors.grey[850],
               size: 40,
             ),
             title: Text('설정',style: f20w500,),
             onTap: () {
               Get.toNamed(SettingMainScreen.id);
               print('설정');
             },
             trailing: Icon(Icons.add,  size: 40,),
           ),
           ListTile(
             leading: Icon(
               Icons.question_answer,
               color: Colors.grey[850],
               size: 40,
             ),
             title: Text('Q&A',style: f20w500,),
             onTap: () {
               print('QNA');
             },
             trailing: Icon(Icons.add,  size: 40,),
           ),
         ],
        ),
      ),
    );
  }
}
