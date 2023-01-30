import 'package:academy/components/font/font.dart';
import 'package:academy/firebase/firebase_test.dart';
import 'package:academy/provider/answer_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../provider/test_state.dart';


class TestCheckScreen extends StatefulWidget {
  // final String docId;
  const TestCheckScreen({Key? key}) : super(key: key);

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
      print('doc id 123 : ${ts.testDocId.value}');
      print('answer doc id : ${ts.answerDocId.value}');
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
        title: Text('내 점수 확인'),
        backgroundColor: Colors.lightGreen,
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
              child: Column(
                children: [
                  ListView.builder(
                    itemCount: ts.realAnswer[0]['answer'].length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (_, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20,),
                          Text(
                            '${index + 1}번 문제(내 답 : ${ts.mySingleAnswer[0]['answer'][index]})',
                            style: f20w500,
                          ),
                          Obx(() => Container(
                              height: 80,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: number.map((number) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        '$number',
                                        style: ts.mySingleAnswer[0]['answer'][index] ==
                                                    ts.realAnswer[0]['answer']
                                                        [index] &&
                                            ts.mySingleAnswer[0]['answer'][index] == number
                                            ? f24Bluew700
                                            : ts.realAnswer[0]['answer']
                                                        [index] ==
                                                    number
                                                ? f24Redw700
                                                : f18w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ))),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    },
                  ),
                  Text('총점 : ${((correct/ts.realAnswer[0]['answer'].length)*100).ceil()}',style: f24w500,),
                  const SizedBox(height: 80,),
                ],
              ),
            ),
    );
  }

  void _score(){
    final ts = Get.put(TestState());

    for (int i = 0; i < ts.realAnswer[0]['answer'].length; i++){
      if(ts.realAnswer[0]['answer'][i] == ts.mySingleAnswer[0]['answer'][i]){
        print('yes');
        correct++;
      }
    }
  }
}
