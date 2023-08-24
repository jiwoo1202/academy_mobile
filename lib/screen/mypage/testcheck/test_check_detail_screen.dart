import 'dart:math';

import 'package:academy/provider/answer_state.dart';
import 'package:academy/provider/test_state.dart';
import 'package:academy/screen/main/student/test/individual/test_individual_screen.dart';
import 'package:academy/screen/main/student/test/test_check_screen.dart';
import 'package:academy/util/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../components/dialog/showAlertDialog.dart';
import '../../../../firebase/firebase_answer.dart';
import '../../../../provider/user_state.dart';
import '../../../../util/colors.dart';
import '../../../../util/font/font.dart';

class TestCheckDetailScreen extends StatefulWidget {
  static final String id = '/test_check_detail';
  final String? docId;
  final String? isInd;
  final List? answer;

  const TestCheckDetailScreen({Key? key, this.docId, this.answer, this.isInd})
      : super(key: key);

  @override
  State<TestCheckDetailScreen> createState() => _TestCheckDetailScreenState();
}

class _TestCheckDetailScreenState extends State<TestCheckDetailScreen> {
  int _currentSortColumn = 0;
  bool _isAscending = true;
  bool _isLoading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await studentAnswerGet('${widget.docId}');

      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final us = Get.put(UserState());
    final as = Get.put(AnswerState());
    final ts = Get.put(TestState());

    return Scaffold(
      appBar: AppBar(
        title: Text('테스트 체크', style: f21w700grey5),
        backgroundColor: Colors.white,
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
      ),
      body: _isLoading
          ? LoadingBodyScreen()
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Center(
                      child: DataTable(
                        sortColumnIndex: _currentSortColumn,
                        sortAscending: _isAscending,
                        headingRowColor: MaterialStateProperty.all(Colors.white),
                        columns: [
                          DataColumn(
                              label: Text(
                            '아이디',
                            style: f16w700,
                          )),
                          DataColumn(
                              label: Text('날짜', style: f16w700),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumn = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    as.testAnswerList.sort((productA, productB) =>
                                        productB['createDate']
                                            .compareTo(productA['createDate']));
                                  } else {
                                    _isAscending = true;
                                    as.testAnswerList.sort((productA, productB) =>
                                        productA['createDate']
                                            .compareTo(productB['createDate']));
                                  }
                                });
                              }),
                          DataColumn(
                              label: Text(
                                '점수',
                                style: f16w700,
                              ),
                              onSort: (columnIndex, _) {
                                setState(() {
                                  _currentSortColumn = columnIndex;
                                  if (_isAscending == true) {
                                    _isAscending = false;
                                    as.testAnswerList.sort((productA, productB) =>
                                        productB['score']
                                            .compareTo(productA['score']));
                                  } else {
                                    _isAscending = true;
                                    as.testAnswerList.sort((productA, productB) =>
                                        productA['score']
                                            .compareTo(productB['score']));
                                  }
                                });
                              }),
                        ],
                        // item -> 선생님한테 답한 test값
                        rows: as.testAnswerList.map((item) {
                          return DataRow(cells: [
                            DataCell(GestureDetector(
                              onTap: () {
                                if(widget.isInd=='true'){
                                    ts.individualAnswer.value = item['answer'];
                                    Get.to(TestIndividual(
                                      isChecked: 'true',
                                        docId: item['answerDocid'],
                                      myPage: true,
                                    ));
                                }
                                else{
                                  ts.testDocId.value = item['docId'];
                                  ts.answerDocId.value = '${widget.docId}';
                                  Get.to(()=>TestCheckScreen(
                                    teacherName: '${us.userList[0].id}',
                                    docId: '${widget.docId}',
                                    myPage: true,
                                  ));
                                }
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Text(
                                item['id'].toString(),
                                style: f16w500,
                              ),
                            )),
                            DataCell(
                                     GestureDetector(
                                        onTap: () {
                                          if(widget.isInd=='true'){
                                            ts.individualAnswer.value = item['answer'];
                                            Get.to(TestIndividual(
                                              isChecked: 'true',
                                              docId: item['answerDocid'],
                                              myPage: true,
                                            ));
                                          }
                                          else{
                                            ts.testDocId.value = item['docId'];
                                            ts.answerDocId.value = '${widget.docId}';
                                            Get.to(()=>TestCheckScreen(
                                              teacherName: '${us.userList[0].id}',
                                              docId: '${widget.docId}',
                                              myPage: true,
                                            ));
                                          }
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: Text(
                                            '${DateFormat('y-MM-dd HH:mm').format(DateTime.parse('${item['createDate']}'))}',
                                            style: f16w500),
                                      )
                          ),
                            DataCell(GestureDetector(
                                onTap: () {
                                  if(widget.isInd=='true'){
                                    ts.individualAnswer.value = item['answer'];
                                    Get.to(TestIndividual(
                                      isChecked: 'true',
                                      docId: item['answerDocid'],
                                      myPage: true,
                                    ));
                                  }
                                  else{
                                    ts.testDocId.value = item['docId'];
                                    ts.answerDocId.value = '${widget.docId}';
                                    Get.to(()=>TestCheckScreen(
                                      teacherName: '${us.userList[0].id}',
                                      docId: '${widget.docId}',
                                      myPage: true,
                                    ));
                                  }
                                },
                                behavior: HitTestBehavior.opaque,
                                child:
                                    Text('${item['score']}점', style: f16w500))),
                            // DataCell(Text(item['price'].toString()))
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }


}
