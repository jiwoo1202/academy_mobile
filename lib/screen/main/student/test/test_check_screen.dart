import 'package:academy/components/button/choose_button.dart';
import 'package:academy/firebase/firebase_test.dart';
import 'package:academy/provider/answer_state.dart';
import 'package:academy/screen/main/student/test/test_main_screen.dart';
import 'package:academy/screen/mypage/mypage_screen.dart';
import 'package:academy/util/padding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../api/pdf/pdf_api.dart';
import '../../../../provider/test_state.dart';
import '../../../../util/colors.dart';

import '../../../../util/font/font.dart';
import '../../../login/login_main_screen.dart';
import '../../../mypage/score/score_check_screen.dart';
import 'test_file.dart';

class TestCheckScreen extends StatefulWidget {
  // final String docId;
  final String? teacherName;
  final String? docId;
  final bool? myPage;
  const TestCheckScreen({Key? key, this.teacherName, this.docId, this.myPage,})
      : super(key: key);

  @override
  State<TestCheckScreen> createState() => _TestCheckScreenState();
}

class _TestCheckScreenState extends State<TestCheckScreen> {
  bool _isLoading = true;
  int correct = 0;
  List<String> number = ['1', '2', '3', '4', '5'];

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final ts = Get.put(TestState());
      // final as = Get.put(AnswerState());

      // await answerGet('fNWPBW7v8VQJ1HzKeYu5');
      await firebaseAnswerGet(ts.answerDocId.value);
      await firebaseSingleQuestionGet(ts.testDocId.value);
      _score();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ts = Get.put(TestState());
    final as = Get.put(AnswerState());
    return Scaffold(
      appBar: AppBar(
        title: Text('내 점수 확인', style: f21w700grey5),
        backgroundColor: backColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xff6f7072),
          ),
          onPressed: () {
            // 나눠서
            if(widget.myPage==true){
            Get.back();
            }
            else if(widget.myPage==false){
              Get.offAllNamed(BottomNavigator.id);
            }
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 100,
                child: ChooseButton(
                    isTrue: true,
                    title: '시험지',
                    onTap: () async {
                      final url =
                          //
                          'https://firebasestorage.googleapis.com/v0/b/academy-957f7.appspot.com/o/12345%2F${widget.teacherName}%2F${widget.docId}.pdf?alt=media';
                      final file = await PDFApi.loadNetwork(url);
                      // Get.back();
                      Get.to(() => TestFilePage(
                            file: file,
                            myPage:widget.myPage
                          ));
                    })),
          )
        ],
        centerTitle: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: _isLoading
          ? Container()
          : SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Column(
                  children: [
                    ListView.builder(
                      itemCount: ts.realAnswer[0]['answer'].length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${index + 1}번 문제',
                                    style: f16w400grey8,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  number.contains(
                                          ts.realAnswer[0]['answer'][index])
                                      ? Text(
                                          '내 답 : ${ts.mySingleAnswer[0]['answer'][index]}',
                                          style: f16w700,
                                        )
                                      : Container()
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              number.contains(ts.realAnswer[0]['answer'][index])
                                  ? Container(
                                      height: 52,
                                      child: ListView.builder(
                                        itemCount: 5,
                                        shrinkWrap: true,
                                        itemBuilder: (context, idx) {
                                          return SizedBox(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 52,
                                                  height: 52,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: ts.mySingleAnswer[0]['answer'][index] == ts.realAnswer[0]['answer'][index] &&
                                                                ts.mySingleAnswer[0]['answer'][index] ==
                                                                    number[idx]
                                                            ? nowColor
                                                            : ts.mySingleAnswer[0]['answer'][index] != ts.realAnswer[0]['answer'][index] &&
                                                                    ts.realAnswer[0]['answer'][index] ==
                                                                        number[
                                                                            idx]
                                                                ? Colors.red
                                                                : Colors.white,
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                cameraBackColor),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(20))),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '${idx + 1}',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: ts.mySingleAnswer[0]['answer'][index] ==
                                                                      ts.realAnswer[0]
                                                                              ['answer'][
                                                                          index] &&
                                                                  ts.mySingleAnswer[0]
                                                                              ['answer']
                                                                          [
                                                                          index] ==
                                                                      number[
                                                                          idx]
                                                              ? f16Whitew700
                                                              : ts.realAnswer[0]
                                                                              ['answer']
                                                                          [index] ==
                                                                      number[idx]
                                                                  ? f16Whitew700
                                                                  : f16w700,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                        scrollDirection: Axis.horizontal,
                                      ))
                                  : Container(
                                      width: Get.width,
                                      padding: ph24v12,
                                      decoration: BoxDecoration(
                                        color: textFormColor,
                                        border: Border.all(
                                          width: 1,
                                          color: blurColor,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${ts.mySingleAnswer[0]['answer'][index]}',
                                        style: f18w700,
                                      ),
                                    ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '총점 : ${((correct / ts.realAnswer[0]['answer'].length) * 100).ceil()}',
                            style: f21w700,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _score() {
    final ts = Get.put(TestState());

    for (int i = 0; i < ts.realAnswer[0]['answer'].length; i++) {
      if (ts.realAnswer[0]['answer'][i] == ts.mySingleAnswer[0]['answer'][i]) {

        correct++;
      }
    }
  }
}
