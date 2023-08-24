import 'package:academy/components/dialog/showAlertDialog.dart';
import 'package:academy/firebase/firebase_user.dart';
import 'package:academy/provider/user_state.dart';
import 'package:academy/screen/login/login_main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../components/tile/textform_field.dart';
import '../../util/font/font.dart';
import '../../util/loading.dart';

class PasswordChange extends StatefulWidget {
  const PasswordChange({Key? key}) : super(key: key);

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  bool _isLoading = false;
  bool _obscureText = false;
  bool _obscureText2 = false;
  bool _passTrue = false;
  TextEditingController _pwCon = TextEditingController();
  TextEditingController _pwCon2 = TextEditingController();
  final us = Get.put(UserState());
   String pw = '';
  @override
  void initState(){

    Future.delayed(Duration.zero,()async{
      setState(() {
        _isLoading= false;
      });
    });
    super.initState();
  }
  @override
  void dispose() {

    _pwCon.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return _isLoading
        ?LoadingBodyScreen():
    Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 변경',style: f21w700grey5),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xff6f7072),
          ),
          onPressed: () {
            Get.back();
          },
        ),elevation: 0,),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 50, 25, 0),
        child: Column(
          children: [
            TextFormFields(
              controller: _pwCon,
              onChanged: (v) {
                  setState(() {

                  });
              },
              obscureText: _obscureText,
              hintText: '비밀번호를 입력해주세요',
              surffixIcon: '1',
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            TextFormFields(
              controller: _pwCon2,
              onChanged: (v) {
                // 비밀번호 일치할때 true
                if(_pwCon.text==_pwCon2.text){
                  _passTrue = true;
                  setState(() {
                  });
                }
                // 비밀번호 실패할 때 false
                else{
                  setState(() {
                    _passTrue = false;
                  });
                }

              },
              obscureText: _obscureText2,
              hintText: '비밀번호를 입력해주세요',
              surffixIcon: '1',
              onTap: () {
                setState(() {
                  _obscureText2 = !_obscureText2;
                });
              },
            ),
            _pwCon.text==''&&_pwCon2.text ==''?Container():
            _passTrue==true
                ?Container(child: Text('비밀번호가 일치합니다.'))
                :Container(child: Text('비밀번호가 일치하지 않습니다.'),),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: ()async{
                if(_passTrue==true){
                  showComponentDialog(context, '비밀번호를 변경하시겠습니까?', () async{
                    Get.back();
                    pw = loginPasswordCheck(_pwCon2.text, 1); //비밀번호를 복호화
                    print('비밀번호가 일치합니다.');
                    await updatePassword(us.usGetId.value, pw);
                    showConfirmTapDialog(context, '비밀번호가 변경되었습니다.', () { Get.offAll(LoginMainScreen());});
                  });
                }
                else {
                  showOnlyConfirmDialog(context, '비밀번호를 다시 입력해 주세요');
                }
              },
              child: Container(
                width: Get.width,
                height: 50,
                decoration: BoxDecoration(
                    color: Color(0xffffEBEBEB),
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('비밀번호 변경',style: f18w700primary,textAlign: TextAlign.center,),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> updatePassword(String docId, String password)async {
    DocumentReference ref = FirebaseFirestore.instance.collection('user').doc(docId);
    ref.update({
      'pw' : password
    });
  }
}

