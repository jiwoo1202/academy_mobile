import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../provider/user_state.dart';
import 'student/student_screen.dart';
import 'teacher/teacher_screen.dart';

class MainScreen extends StatefulWidget {
  static final String id = '/main_screen';
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final us = Get.put(UserState());
    return
      Scaffold(
      body: us.userList[0].userType == '학생' ? StudentScreen() : TeacherScreen()
        // Container( width: Get.width,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       //선생님인지 학생인지 호출
      //       Obx(() => Text(
      //         '${us.userList[0].userType}',
      //         style: TextStyle(color: Colors.black),
      //       )),
      //       SizedBox(height: 12,),
      //
      //       // Obx(() => Text(
      //       //       '${us.count}',
      //       //       style: TextStyle(color: Colors.black),
      //       //     )),
      //       // Obx(() => Text(
      //       //       '${us.name}',
      //       //       style: TextStyle(color: Colors.black),
      //       //     )),
      //       // TextButton(
      //       //   onPressed: () {
      //       //     us.decrease();
      //       //     print('123123123: ${us.userList[0].id}');
      //       //     setState(() {});
      //       //   },
      //       //   child: Text(
      //       //     'hello',
      //       //     style: TextStyle(color: Colors.black, fontSize: 24),
      //       //   ),
      //       // ),
      //     ],
      //   ),
      // ),
    );
  }
}
