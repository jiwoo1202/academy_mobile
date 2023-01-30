import 'package:academy/components/font/font.dart';
import 'package:academy/screen/community/job/job_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../provider/user_state.dart';
import 'story/story_main_screen.dart';

class CommunityMainScreen extends StatefulWidget {
  static final String id = '/community_main';

  const CommunityMainScreen({Key? key}) : super(key: key);

  @override
  State<CommunityMainScreen> createState() => _CommunityMainScreenState();
}

class _CommunityMainScreenState extends State<CommunityMainScreen> {
  @override
  Widget build(BuildContext context) {
    final us = Get.put(UserState());

    return Scaffold(
      body: us.userList[0].userType == '학생'
          ? StoryMainScreen()
          : JobMainScreen(),
    );
  }
}
