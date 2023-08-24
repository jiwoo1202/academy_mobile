import 'package:academy/components/dialog/showAlertDialog.dart';
import 'package:academy/firebase/firebase_answer.dart';
import 'package:academy/provider/answer_state.dart';
import 'package:academy/provider/test_state.dart';
import 'package:academy/screen/main/student/test/individual/test_individual_screen.dart';
import 'package:academy/util/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../api/pdf/pdf_api.dart';
import '../../../components/tile/main_tile.dart';
import '../../../provider/user_state.dart';
import '../../../util/colors.dart';

import '../../../util/font/font.dart';
import 'test/test_main_screen.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  TextEditingController _pwcontroller = TextEditingController();
  TextEditingController _teacherCon = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    final as = Get.put(AnswerState());
    as.getDocid.value = [];
    as.teacherList.value = [];
    as.createList.value = [];
    super.initState();
  }

  @override
  void dispose() {
    _pwcontroller.dispose();
    _teacherCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final as = Get.put(AnswerState());
    final ts = Get.put(TestState());
    final us = Get.put(UserState());
    return WillPopScope(
      onWillPop: () {
        return onTerminated(context);
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            width: Get.width,
            padding: EdgeInsets.only(right: 24, left: 24, top: 60),
            child: StreamBuilder<QuerySnapshot>(
              stream: _teacherCon.text.trim().isNotEmpty
                  ? FirebaseFirestore.instance
                      .collection('answer')
                      .orderBy('nickName').where('state',isEqualTo: '대기')
                      .startAt([_teacherCon.text]).endAt([_teacherCon.text + '\uf8ff']).snapshots()
                  : FirebaseFirestore.instance
                      .collection('answer')
                      .where('state', isEqualTo: '대기')
                      .orderBy('createDate', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: LoadingBodyScreen());
                }
                return Column(
                  children: [
                    Text(
                      '학생',
                      style: f24w500,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    //검색
                    TextFormField(
                      // enabled: !_pay,
                      controller: _teacherCon,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      onFieldSubmitted: (v){
                        setState(() {
                        });
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Color(0xffEBEBEB),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8)),
                        hintText: '선생님 검색',
                        suffixIcon: GestureDetector(
                            onTap: () {

                              setState(() {

                              });
                            },
                            child: Icon(
                              Icons.search_outlined,
                              color: Colors.black,
                              size: 30,
                            )),
                        hintStyle: f16w400grey8,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            MainTile(
                              isOpened: true,
                              isStudent: true,
                              subject: snapshot.data!.docs[index]['pdfCategory'],
                              tName: snapshot.data!.docs[index]['nickName'],
                              tCreateDate:
                                  '${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(snapshot.data!.docs[index]['createDate']))}',
                              onTap: () async {
                                getAnswerLength(
                                    snapshot.data!.docs[index]['docId']);
                                ts.answerDocId.value =
                                    '${snapshot.data!.docs[index]['docId']}';
                                as.getTeacherName.value =
                                    '${snapshot.data!.docs[index]['teacher']}';
                                as.temp2.value =
                                '${snapshot.data!.docs[index]['temp2']}';
                                showPasswordDialog(context, '비밀번호', () async {
                                  // if(snapshot.data!.docs[index]
                                  // ['student'].contains('${us.userList[0].id}')){
                                  //   showOnlyConfirmDialog(context, '중복 테스트는 불가능 합니다.');
                                  // }
                                  // else
                                    if (_pwcontroller.text ==
                                      snapshot.data!.docs[index]['password']) {
                                    if (snapshot.data!.docs[index]
                                            ['isIndividual'] ==
                                        'true') {
                                      Get.back();
                                      _pwcontroller.text = '';
                                      Get.to(() => TestIndividual(
                                            docId: snapshot.data!.docs[index]
                                                ['docId'],
                                            myPage: false,
                                          ));
                                    } else {
                                      final url =
                                          'https://firebasestorage.googleapis.com/v0/b/academy-957f7.appspot.com/o/12345%2F${snapshot.data!.docs[index]['teacher']}%2F${snapshot.data!.docs[index]['docId']}.pdf?alt=media';
                                      final file = await PDFApi.loadNetwork(url);
                                      Get.back();
                                      Get.to(() => TestMainScreen(
                                          file: file,
                                          docId: snapshot.data!.docs[index]['docId'],
                                          teacher: snapshot.data!.docs[index]['teacher'],
                                          hasAudio: snapshot.data!.docs[index]['audio'],
                                      ));
                                    }
                                    _pwcontroller.text = '';
                                  } else {
                                    Get.back();
                                    showOnlyConfirmDialog(
                                        context, '비밀번호가 맞지 않습니다');
                                    _pwcontroller.text = '';

                                  }
                                }, _pwcontroller);
                                // print('index : $index');
                              },
                              switchOnTap: () {},
                              title: '',
                            ),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
  Future<bool> onTerminated(BuildContext context) async {
    return showComponentDialog(context, '앱을 종료하시겠습니까?', () {
      SystemNavigator.pop();
    });
  }
}
