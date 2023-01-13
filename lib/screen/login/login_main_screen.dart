import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../provider/user_state.dart';
import '../main_screen.dart';

class LoginMainScreen extends StatefulWidget {
  static final String id = '/login_main';

  const LoginMainScreen({Key? key}) : super(key: key);

  @override
  State<LoginMainScreen> createState() => _LoginMainScreenState();
}

class _LoginMainScreenState extends State<LoginMainScreen> {
  @override
  Widget build(BuildContext context) {
    final us = Get.put(UserState());
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() => Text(
              '${us.count}',
              style: TextStyle(color: Colors.black),
            )),

            TextButton(
              onPressed: () {
                us.increase();
                us.name.value = 'my name is ipad';
              },
              child: Text(
                'hello',
                style: TextStyle(color: Colors.black,fontSize: 24),
              ),
            ),

            TextButton(
              onPressed: () {
                Get.toNamed(MainScreen.id);
              },
              child: Text(
                'move',
                style: TextStyle(color: Colors.black,fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
