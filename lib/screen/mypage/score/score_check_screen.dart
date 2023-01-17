import 'package:academy/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/tile/main_tile.dart';
import '../../../firebase/firebase_test.dart';
import '../../../provider/test_state.dart';
import '../../../provider/user_state.dart';
import '../../main/student/test/test_check_screen.dart';

class ScoreCheckScreen extends StatefulWidget {
  static final String id = '/score_check';

  const ScoreCheckScreen({Key? key}) : super(key: key);

  @override
  State<ScoreCheckScreen> createState() => _ScoreCheckScreenState();
}

class _ScoreCheckScreenState extends State<ScoreCheckScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero,()async{
      await firebaseAllQuestionGet();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ts = Get.put(TestState());
    final us = Get.put(UserState());
    return Scaffold(
      appBar: AppBar(
        title: Text('내 점수 확인'),
        backgroundColor: Colors.lightGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: _isLoading ? LoadingBodyScreen() : Padding(
        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 20),
        child: ListView.builder(
          itemCount: ts.myAnswer.length,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                MainTile(
                  isOpened: true,
                  isStudent: true,
                  subject: '사회',
                  tName: '가나다',
                  onTap: () async {
                    ts.testDocId.value = ts.myAnswer[index]['docId'];
                    Get.to(() => TestCheckScreen(
                    ));
                  },
                  switchOnTap: () {},
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
