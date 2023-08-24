import 'package:academy/components/dialog/showAlertDialog.dart';
import 'package:academy/components/switch/switch_button.dart';
import 'package:academy/provider/user_state.dart';
import 'package:academy/screen/login/login_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../util/colors.dart';
import '../../../util/font/font.dart';
import '../blockPage.dart';
import '../job_setting_screen.dart';

class SettingMainScreen extends StatefulWidget {
  static final String id = '/setting_main';

  const SettingMainScreen({Key? key}) : super(key: key);

  @override
  State<SettingMainScreen> createState() => _SettingMainScreenState();
}

class _SettingMainScreenState extends State<SettingMainScreen> {
  bool _alarm = false;
  static final storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    final us = Get.put(UserState());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xff6f7072),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        title: Text(
          '설정',
          style: f21w700grey5,
        ),
        centerTitle: true,
        backgroundColor: backColor,
      ),
      body: Container(
        color: backColor,
        padding: const EdgeInsets.fromLTRB(24, 50, 24, 0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: buttonTextColor,
                  borderRadius: BorderRadius.circular(8.0)),
              child: ListTile(
                leading: SvgPicture.asset(
                  'assets/icon/set.svg',
                  width: 24,
                  height: 24,
                ),
                title: Text(
                  '차단 설정',
                  style: f18w400,
                ),
                onTap: () {
                  Get.toNamed(BlockPage.id);

                },
                trailing: SvgPicture.asset(
                  'assets/icon/arrowFront.svg',
                  width: 7,
                  height: 14,
                ),
              ),
            ),

            us.userList[0].userType == '학생'
                ? Container()
                : const SizedBox(
                    height: 16,
                  ),
            us.userList[0].userType == '학생'
                ? Container()
                : Container(
                    decoration: BoxDecoration(
                        color: buttonTextColor,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: ListTile(
                      leading: SvgPicture.asset(
                        'assets/icon/set.svg',
                        width: 24,
                        height: 24,
                      ),
                      title: Text(
                        '구인구직 설정',
                        style: f18w400,
                      ),
                      onTap: () {
                        Get.toNamed(JobSettingScreen.id);

                      },
                      trailing: SvgPicture.asset(
                        'assets/icon/arrowFront.svg',
                        width: 7,
                        height: 14,
                      ),
                    ),
                  ),

            const SizedBox(
              height: 16,
            ),
            Container(
              height: 64,
              decoration: BoxDecoration(
                  color: buttonTextColor,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      offset: Offset(0, 1),
                    )
                  ]),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: SvgPicture.asset(
                    'assets/icon/bell.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
                title: Text(
                  '알림',
                  style: f20w500,
                ),
                onTap: () {

                },
                trailing: SwitchButton(
                  onTap: () {
                    setState(() {
                      _alarm = !_alarm;
                    });
                  },
                  value: _alarm,
                ),
              ),
            ),

            const SizedBox(
              height: 16,
            ),
            Container(
              height: 64,
              decoration: BoxDecoration(
                  color: buttonTextColor,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      offset: Offset(0, 1),
                    )
                  ]),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: SvgPicture.asset(
                    'assets/icon/set.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
                title: Text(
                  '버전',
                  style: f18w400,
                ),
                onTap: () {

                },
                trailing: Text(
                  'ver 1.0.0',
                  style: f18w400,
                ),
              ),
            ),

            const SizedBox(
              height: 16,
            ),
            Container(
              height: 64,
              decoration: BoxDecoration(
                  color: buttonTextColor,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      offset: Offset(0, 1),
                    )
                  ]),
              child: ListTile(
                leading: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: SvgPicture.asset(
                    'assets/icon/set.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
                title: Text(
                  '로그아웃',
                  style: f18w400,
                ),
                onTap: () {
                  showComponentDialog(context, '로그아웃 하시겠습니까?', () {
                    storage.delete(key: "isLogged");
                    storage.delete(key: 'pw');
                    Get.offAll(() => LoginMainScreen());
                  });
                },
              ),
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
