import 'package:academy/components/dialog/showAlertDialog.dart';
import 'package:academy/components/switch/switch_button.dart';
import 'package:academy/screen/login/login_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/font/font.dart';

class SettingMainScreen extends StatefulWidget {
  static final String id = '/setting_main';
  const SettingMainScreen({Key? key}) : super(key: key);

  @override
  State<SettingMainScreen> createState() => _SettingMainScreenState();
}

class _SettingMainScreenState extends State<SettingMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text('설정'),
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
                Icons.notification_important,
                color: Colors.grey[850],
                size: 40,
              ),
              title: Text('알림',style: f20w500,),
              onTap: () {
                print('점수');
              },
              trailing: SwitchButton(
                onTap: (){},
                value: false,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.pattern,
                color: Colors.grey[850],
                size: 40,
              ),
                title: Text('버젼',style: f20w500,),
              onTap: () {
                print('설정');
              },
              trailing: Text('ver 1.0.0',style: f20w500,),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.grey[850],
                size: 40,
              ),
              title: Text('로그아웃',style: f20w500,),
              onTap: () {
                showComponentDialog(context, '로그아웃 하시겠습니까?', () {
                  Get.offAll(LoginMainScreen());
                });
              },
            ),
            // ListTile(
            //   leading: Icon(
            //     Icons.question_answer,
            //     color: Colors.grey[850],
            //     size: 40,
            //   ),
            //   title: Text('Q&A',style: f20w500,),
            //   onTap: () {
            //     print('QNA');
            //   },
            //   trailing: Icon(Icons.add,  size: 40,),
            // ),
          ],
        ),
      ),
    );
  }
}
