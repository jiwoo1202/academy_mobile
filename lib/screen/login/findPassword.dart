import 'package:academy/components/dialog/showAlertDialog.dart';
import 'package:academy/components/tile/textform_field.dart';
import 'package:academy/firebase/firebase_user.dart';
import 'package:academy/provider/user_state.dart';
import 'package:academy/screen/login/passwordChange.dart';
import 'package:academy/util/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../util/colors.dart';
import '../../util/font/font.dart';

class FindPassword extends StatefulWidget {
  const FindPassword({Key? key}) : super(key: key);

  @override
  State<FindPassword> createState() => _FindPasswordState();
}

class _FindPasswordState extends State<FindPassword> {
  TextEditingController _phoneCon = TextEditingController();
  TextEditingController _otpCon = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  int _doubleCheck = 0;
  bool _phoneAuth = false;
  String verificationId = '';
  String passWord = '';
  bool _isLoading = false;
  bool phoneblock = false;
  final us = Get.put(UserState());
  @override
  void initState(){
    Future.delayed(Duration.zero,()async{
      us.findPassWord.value='';

     setState(() {
       _isLoading= false;
     });
    });
    super.initState();
  }
  @override
  void dispose() {
    _phoneCon.dispose();
    _otpCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ?LoadingBodyScreen():
    Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 찾기 페이지',style: f21w700grey5),
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
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormFields(
                    controller: _phoneCon,
                    obscureText: true,
                    hintText: '번호를 입력해주세요',
                    keyboardType: TextInputType.number,
                    surffixIcon: '0',
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(13),
                      FilteringTextInputFormatter.digitsOnly,
                      MaskTextInputFormatter(mask: '###-####-####')
                    ],),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffEBEBEB),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffEBEBEB),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        //휴대폰 인증번호 보내기
                        _auth.verifyPhoneNumber(
                          phoneNumber: '+82${_phoneCon.text}',
                          verificationCompleted:
                              (PhoneAuthCredential credential) async {
                            await _auth
                                .signInWithCredential(credential)
                                .then((value) => print('success'));
                          },
                          verificationFailed: (verificationFalied) async {
                            showOnlyConfirmDialog(context, "인증번호 보내기가 실패하였습니다.");

                          },
                          codeSent: (verifiationId,resendingToken) async {
                            showOnlyConfirmDialog(context, "인증번호를 보냈습니다");
                            setState(() {
                              verificationId = verifiationId;
                            });
                          },
                          timeout: Duration(seconds: 30),
                          codeAutoRetrievalTimeout: (verificationId) async {},
                        );
                      },
                      child: Text(
                        '인증번호',
                        style: TextStyle(
                            color: Color(0xff3A8EFF),
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormFields(
                    controller: _otpCon,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    obscureText: true,
                    hintText: '인증번호를 입력해주세요',
                    surffixIcon: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffEBEBEB),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffEBEBEB),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (_doubleCheck == 0) {
                          PhoneAuthCredential phoneAuthCredential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId,
                              smsCode: _otpCon.text);
                          signInWithPhoneAuthCredential(phoneAuthCredential);
                        } else {

                        }
                        setState(() {});
                      },
                      child: Text(
                        '인증번호\n확인 ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff3A8EFF),
                            fontFamily: "Pretendard",
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            //인증번호 일치하는지 확인
              _phoneAuth==true
                ?Container(child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('인증되었습니다.'),
                  ],
                ))
                :Container(),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: ()async{
                if(_phoneAuth==true){
                  await findPassWord(_phoneCon.text.replaceAll('-', ''));

                  if(us.findPassWord.value==''){
                    showOnlyConfirmDialog(context, '등록되지않은 휴대폰 번호입니다.');
                  }
                  else{
                    Get.to(()=>PasswordChange());
                    setState(() {
                      _phoneCon.text = '';
                      _otpCon.text='';
                      _phoneAuth=false;
                      _doubleCheck=0;
                    });
                  }
                }
                else if(_phoneCon.text==''){
                  showOnlyConfirmDialog(context, '휴대폰 번호를 입력해 주세요');
                }
                else {
                  showOnlyConfirmDialog(context, '휴대폰 번호를 확인해 주세요');
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
  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {

    try {

      final authCredential =
      await _auth.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {

        setState(() {
          _phoneAuth = true;
          showOnlyConfirmDialog(context, "인증이 완료되었습니다.");
          phoneblock = true;

        }
        );

        _doubleCheck = 1;
        await _auth.currentUser!.delete();

        _auth.signOut();

        // cancelTimer();

        //     CollectionReference ref = FirebaseFirestore.instance.collection('fcm');
        //     QuerySnapshot snapshot = await ref.where('1', isEqualTo: _otpCon.text).get();
        //     final allData = snapshot.docs.map((doc) => {doc.data()}).toList();
        //     List as = allData;
        //     if (as.length != 0) {
        //       FirebaseFirestore.instance
        //           .collection('fcm')
        //           .doc(as[0].toString().replaceAll('{', '').replaceAll('}', '').split(',')[3].split(' ')[2])
        //           .delete();
        //     }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _phoneAuth = false;
      });
      showOnlyConfirmDialog(context, "인증번호가 일치하지 않습니다.");
      print('Error Log Phone Auth : ${e}');
    }
  }

}
