import 'package:academy/components/dialog/showAlertDialog.dart';
import 'package:academy/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/tile/main_tile.dart';
import '../../../firebase/firebase_test.dart';
import '../../../provider/test_state.dart';
import '../../../provider/user_state.dart';
import '../../../util/colors.dart';

import '../../../util/font/font.dart';
import '../../main/student/test/individual/test_individual_screen.dart';
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
      final us = Get.put(UserState());
      await firebaseAllQuestionGet('${us.userList[0].id}');
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
        title: Text('내 점수 확인',style: f21w700grey5,),
        backgroundColor: backColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xff6f7072),
          ),
          onPressed: () {
              Get.back();
          },
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: _isLoading ? LoadingBodyScreen() : SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
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
                    title: '',
                    subject: '${ts.myAnswer[index]['testTitle']}',
                    arrowString: '${ts.myAnswer[index]['score']}점 확인하기',
                    tCreateDate: '${DateFormat('y-MM-dd hh:mm').format(DateTime.parse('${ts.myAnswer[index]['createDate']}'))}',
                    tName: '${ts.myAnswer[index]['nickName']}',
                    onTap: () async {
                      if(ts.myAnswer[index]['status'] == '채점중'){
                        showOnlyConfirmDialog(context, '아직 종료되지 않은 시험입니다');
                      }else{
                        if(ts.myAnswer[index]['isIndividual'] == 'true'){
                          ts.individualAnswer.value = ts.myAnswer[index]['answer'];
                          Get.to(()=>TestIndividual(
                            isChecked: 'true',
                            docId: ts.myAnswer[index]['answerDocid'],
                            myPage: true
                          ));
                        }else{
                          ts.testDocId.value = ts.myAnswer[index]['docId'];
                          ts.answerDocId.value = ts.myAnswer[index]['answerDocid'];
                          Get.to(() => TestCheckScreen(
                              teacherName:ts.myAnswer[index]['teacher'],
                              docId: ts.myAnswer[index]['answerDocid'],
                              myPage : true
                          ));
                        }
                      }
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
      ),
    );
  }
}
