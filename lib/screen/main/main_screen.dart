import 'package:academy/screen/check/studentCheck/qrCheck.dart';
import 'package:academy/screen/check/teacherCheck/classCheck.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../provider/user_state.dart';
import '../../components/dialog/showAlertDialog.dart';
import '../../../util/font/font.dart';
import '../../firebase/firebase_log.dart';
import '../../util/colors.dart';
import '../check/studentCheck/studentCheck.dart';
import 'student/student_screen.dart';
import 'student/test/individual/test_individual_screen.dart';
import 'teacher/individual/pdf_individual_main_screen.dart';
import 'teacher/individual/pdf_upload_individual_screen.dart';
import 'teacher/all/pdf_upload_screen.dart';
import 'teacher/teacher_screen.dart';

class MainScreen extends StatefulWidget {
  static final String id = '/main_screen';

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState(){
    Future.delayed(Duration.zero,(){
      final us = Get.put(UserState());

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final us = Get.put(UserState());
    return Scaffold(
        body: Stack(children: [
      Container(
          color: Color(0xffF7F7F7),
          child: us.userList[0].userType == '학생'
              ? StudentScreen()
              : TeacherScreen()),
      us.userList[0].userType == '선생님'
          ? Positioned(
              top: 60,
              right: 28,
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    showComponentUploadDialog(context, '문제를 추가하시겠습니까?', () {
                      Get.back();
                      Get.to(() => PdfUploadScreen());
                    }, () {
                      Get.back();
                      Get.to(() => PdfIndMainScreen());
                    });

                    // showDialog(
                    //     context: context,
                    //     builder:(BuildContext context)=>AlertDialog(
                    //       content: Text('등록 방식을 선택해주세요'),
                    //       actions: [
                    //         ElevatedButton(
                    //             onPressed:(){
                    //               Get.to(() => PdfUploadScreen());
                    //             } , child: Text('한번에 등록')),
                    //         ElevatedButton(
                    //             onPressed:(){
                    //               Get.to(() => PdfUploadScreen());
                    //             } , child: Text('한개씩 등록'))
                    //       ],
                    //     ));
                  },
                  child: Container(
                    child: const Center(
                        child: Text(
                      '문제추가',
                      style: f16w700primary,
                    )),
                  )))
          : Container(),
          // Padding(
          //   padding: const EdgeInsets.all(13.0),
          //   child: Align(
          //     alignment: Alignment.bottomRight,
          //       child: Container(
          //         height: 56,
          //         width: 56,
          //         child: FittedBox(
          //           fit: BoxFit.fill,
          //           child: FloatingActionButton(
          //             onPressed: (){
          //               if(us.userList[0].userType=='선생님') {
          //                 Get.to(() => ClassCheckPage());
          //               }
          //               else{
          //                 studentCheckButton(
          //                     context,
          //                     '출석체크',
          //                         () {
          //                           Get.to(()=>StudentCheck());
          //                       },
          //                         () {
          //                           Get.to(()=>QrCheck());
          //                     });
          //               }
          //             },
          //             backgroundColor: nowColor,
          //             child: Text('출석',textAlign: TextAlign.center,style: f16Whitew500,),),
          //         ),
          //       )),
          // )
    ])
        // Container( width: Get.width,
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       //선생님인지 학생인지 호출
        //       Obx(() => Text(
        //         '${us.userList[0].userType}',
        //         style: TextStyle(color: Colors.black),
        //       )),
        //       SizedBox(height: 12,),
        //
        //       // Obx(() => Text(
        //       //       '${us.count}',
        //       //       style: TextStyle(color: Colors.black),
        //       //     )),
        //       // Obx(() => Text(
        //       //       '${us.name}',
        //       //       style: TextStyle(color: Colors.black),
        //       //     )),
        //       // TextButton(
        //       //   onPressed: () {
        //       //     us.decrease();
        //       //     print('123123123: ${us.userList[0].id}');
        //       //     setState(() {});
        //       //   },
        //       //   child: Text(
        //       //     'hello',
        //       //     style: TextStyle(color: Colors.black, fontSize: 24),
        //       //   ),
        //       // ),
        //     ],
        //   ),
        // ),
        // , floatingActionButton: us.userList[0].userType == '선생님'
        //     ? FloatingActionButton(
        //         onPressed: () {
        //           Get.to(() => PdfUploadScreen());
        //         },
        //         tooltip: '시험 등록',
        //         backgroundColor: Colors.lightGreen,
        //         child: const Icon(Icons.add, color: Colors.white,),
        //       )
        //     : null);
        );
  }
}
