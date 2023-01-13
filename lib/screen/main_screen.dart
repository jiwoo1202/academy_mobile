import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../provider/user_state.dart';

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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => Text(
                '${us.count}',
                style: TextStyle(color: Colors.black),
              )),
          Obx(() => Text(
            '${us.name}',
            style: TextStyle(color: Colors.black),
          )),
          TextButton(
            onPressed: () {
              us.decrease();
              setState(() {});
            },
            child: Text(
              'hello',
              style: TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}
