import 'package:academy/components/dialog/showAlertDialog.dart';
import 'package:academy/components/tile/textform_field.dart';
import 'package:academy/provider/user_state.dart';
import 'package:academy/screen/main/student/student_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../firebase/firebase_check.dart';
import '../../../util/font/font.dart';

class StudentCheck extends StatefulWidget {
  const StudentCheck({Key? key}) : super(key: key);

  @override
  State<StudentCheck> createState() => _StudentCheckState();
}

class _StudentCheckState extends State<StudentCheck> {
  TextEditingController _codeController = TextEditingController();
  final us = Get.put(UserState());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '출석체크',
          style: f21w700,
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () async{
              print(_codeController.text);
              showComponentDialog(context, '출석체크 하시겠습니까?', () async{
                try{
                  await studentCheck(_codeController.text,'${us.userList[0].phoneNumber}');
                   showOnlyConfirmDialog(context, '출석체크가 완료되었습니다.');
                }catch(e){
                  showOnlyConfirmDialog(context, '코드를 다시 입력해주세요');
                }
              }
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 28),
              child: Center(
                  child: Text(
                    '출석',
                    style: f16w700primary,
                  )),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20,top: 50),
        child: Column(
          children: [
            TextFormFields(
              controller: _codeController,
              obscureText: true,
              hintText: '코드를 입력해주세요',
              surffixIcon: '0',
            onTap: (){
            },),
          ],
        ),
      ),
    );
  }
}
