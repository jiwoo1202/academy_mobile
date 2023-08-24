import 'package:academy/components/dialog/showAlertDialog.dart';
import 'package:academy/firebase/firebase_answer.dart';
import 'package:academy/util/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/tile/main_tile.dart';
import '../../../provider/user_state.dart';
import '../../../util/behavior.dart';
import '../../../util/colors.dart';
import '../../../util/font/font.dart';
import 'all/pdf_upload_screen.dart';
import 'individual/pdf_individual_main_screen.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  // bool _isOpened = false;
  List _allData = [];
  List<bool> _isOpened = [];
  List<bool> _selection = List.generate(3, (_) => false);

  @override
  void initState() {
    // Future.delayed(Duration.zero, () async {
    //   // await teacherGet();
    //   // CollectionReference ref = FirebaseFirestore.instance.collection('answer');
    //   // QuerySnapshot snapshot = await ref
    //   //     .('createDate')
    //   //     .where('teacher', isEqualTo: '1234')
    //   //     .get();
    //   // final allData = snapshot.docs.map((doc) => doc.data()).toList();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final us = Get.put(UserState());

    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          width: Get.width,
          // height: Get.height,
          padding: EdgeInsets.only(right: 24, left: 24, top: 60),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('answer')
                  .where('teacher', isEqualTo: us.userList[0].id)
                  // .where('state', isNotEqualTo: '삭제')
                  .orderBy('createDate', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                      height: Get.height, child: LoadingBodyScreen());
                }
                return Column(
                  children: [
                    Text(
                      ' 선생님',
                      style: f24w500,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    //검색
                    // GestureDetector(
                    //   behavior: HitTestBehavior.opaque,
                    //   onTap: () async {
                    //     // var drugName = Navigator.push(
                    //     //   context,
                    //     //   MaterialPageRoute(
                    //     //     builder: (context) => MainSearchScreen(),
                    //     //   ),
                    //     // );
                    //     // Get.to(() => MainSearchScreen.id);
                    //     // setState(() {
                    //     //   if (drugName != null && drugName != '') createDrugItem(drugName);
                    //     // });
                    //   },
                    //   child: Container(
                    //     alignment: Alignment.topCenter,
                    //     padding: EdgeInsets.symmetric(
                    //         horizontal: 20, vertical: 18.5),
                    //     decoration: BoxDecoration(
                    //       color: textFormColor,
                    //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    //     ),
                    //     child: Align(
                    //       alignment: Alignment.topLeft,
                    //       child: Text(
                    //         '검색',
                    //         style: f16w400,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 30,
                    ),
                    //조건 비어있으면 Text or 카드 있으면 카드 ListView 부르기
                    // false ?
                    // Text('선생님 이름 혹은\n코드를 검색해주세요', style: TextStyle(fontSize: 20),):
                    ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return snapshot.data!.docs[index]['state'] != '삭제'
                            ? GestureDetector(
                                  onLongPress : (){
                                    showComponentDialog(context, '삭제하시겠습니까?', () {
                                      Get.back();
                                      deleteAnswer(
                                          snapshot.data!.docs[index]['docId']);
                                    });

                                  },
                                child: Column(
                                  children: [
                                    MainTile(
                                      isOpened: snapshot.data!.docs[index]
                                                  ['state'] ==
                                              '대기'
                                          ? true
                                          : false,
                                      isStudent: false,
                                      onTap: () async {
                                        // final url =
                                        //     'https://firebasestorage.googleapis.com/v0/b/academy-957f7.appspot.com/o/12345%2F12345%2F${snapshot.data!.docs[index]['docId']}.pdf?alt=media';
                                        // // 'https://firebasestorage.googleapis.com/v0/b/miocr-82323.appspot.com/o/test.pdf?alt=media&token=0fd055a8-aa9d-41d8-970c-1c882ed6d5dc';
                                        // final file = await PDFApi.loadNetwork(url);
                                        // Get.to(PdfCheckScreen(
                                        //   file: file,
                                        // ));
                                        // print('hey');
                                        //individual
                                        if (snapshot.data!.docs[index]
                                                ['isIndividual'] ==
                                            'true') {
                                          Get.to(() => PdfIndMainScreen(
                                                edit: 'true',
                                                category: snapshot.data!
                                                    .docs[index]['pdfCategory'],
                                                docId: snapshot
                                                    .data!.docs[index]['docId'],
                                                password: snapshot.data!
                                                    .docs[index]['password'],
                                                answer: snapshot.data!
                                                    .docs[index]['answer'],
                                                title:
                                                    snapshot.data!.docs[index]
                                                        ['individualTitle'],
                                                body: snapshot.data!.docs[index]
                                                    ['individualBody'],
                                                image: snapshot.data!
                                                    .docs[index]['images'],
                                            countdown: snapshot.data!.docs[index]
                                            ['temp2'],
                                                file: snapshot.data!.docs[index]
                                                    ['individualFile'],
                                                audio: snapshot.data!.docs[index]['audio'],
                                                state: snapshot.data!.docs[index]['state'],
                                                pdfUploadName: snapshot.data!.docs[index]['pdfUploadName'],
                                                pdfUploadName2: snapshot.data!.docs[index]['pdfUploadName2'],
                                                teacher:snapshot.data!.docs[index]['teacher']
                                              ));
                                        } else {
                                          Get.to(() => PdfUploadScreen(
                                              category: snapshot.data!.docs[index]
                                                  ['pdfCategory'],
                                              pdfUploadName: snapshot.data!
                                                  .docs[index]['pdfUploadName'],
                                              state: snapshot.data!
                                                  .docs[index]['state'],
                                              pdfUploadName2: snapshot.data!.docs[index]['pdfUploadName2'],
                                              password: snapshot.data!.docs[index]
                                                  ['password'],
                                              answerlength: snapshot
                                                  .data!.docs[index]['answer'],
                                              docId: snapshot.data!.docs[index]
                                                  ['docId'],
                                              teacherName: snapshot
                                                  .data!.docs[index]['teacher'],
                                              countdown: snapshot.data!.docs[index]
                                              ['temp2'],
                                              edit: true));
                                        }
                                      },
                                      tName: us.userList[0].nickName,
                                      tCreateDate:
                                          '${DateFormat('y-MM-dd HH:mm').format(DateTime.parse('${snapshot.data!.docs[index]['createDate']}'))}',
                                      title:
                                          '${snapshot.data!.docs[index]['pdfCategory']}',
                                      switchOnTap: () {

                                        if (snapshot.data!.docs[index]
                                                ['state'] ==
                                            '대기') {
                                          updateData(
                                              snapshot.data!.docs[index]
                                                  ['docId'],
                                              '완료');
                                        } else {
                                          updateData(
                                              snapshot.data!.docs[index]
                                                  ['docId'],
                                              '대기');
                                        }
                                      },
                                      storage:'${snapshot.data!.docs[index]['state']}',
                                      isSwitched: true,
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                ),
                              )
                            : Container();
                      },
                    ),
                    SizedBox(
                      height: 60,
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }

  Future<void> updateData(String docId, String value) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('answer');
    QuerySnapshot snapshot = await ref.where('docId', isEqualTo: docId).get();
    snapshot.docs[0].reference.update({'state': '${value}'});
    // final allData = snapshot.docs.map((doc) => doc.data()).toList();
    // _allData = allData;
    // print('all : ${_allData.length}');
  }
}
