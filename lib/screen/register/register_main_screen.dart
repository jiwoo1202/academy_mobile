import 'package:academy/provider/user_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterMainScreen extends StatefulWidget {
  static final String id = '/register_main';

  const RegisterMainScreen({Key? key}) : super(key: key);

  @override
  State<RegisterMainScreen> createState() => _RegisterMainScreenState();
}

class _RegisterMainScreenState extends State<RegisterMainScreen> {
  TextEditingController _idCon = TextEditingController();
  TextEditingController _pwCon = TextEditingController();
  TextEditingController _phoneCon = TextEditingController();
  TextEditingController _otpCon = TextEditingController();
  TextEditingController _nameCon = TextEditingController();
  TextEditingController _birthCon = TextEditingController();

  // TextEditingController _monthCon = TextEditingController();
  // TextEditingController _dayCon = TextEditingController();
  bool _obscureText = false;
  var maskFormatter = new MaskTextInputFormatter(mask: '###-####-####');
  var maskFormatter2 = new MaskTextInputFormatter(mask: '####/##/##');
  String? selectedValue;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = '';
  bool otpCode = false;
  bool _phoneAuth = false;
  bool _authOk = false;
  bool _isConfirm = false;
  int _doubleCheck = 0;

  @override
  void initState() {
    _phoneAuth = false;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _idCon.dispose();
    _pwCon.dispose();
    _phoneCon.dispose();
    _otpCon.dispose();
    _nameCon.dispose();
    _birthCon.dispose();

    bool _phoneAuth = false;
    // _monthCon.dispose();
    // _dayCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final us = Get.put(UserState());

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '회원가입',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: Colors.orangeAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('${us.id}',style: f16w500,),
              // Obx(() =>Text('${us.id}',style: f16w500,)),
              TextField(
                controller: _idCon,
                onChanged: (v) {
                  us.id.value = _idCon.text.trim();
                },
                decoration: InputDecoration(
                  labelText: '아이디',
                  hintText: '아이디를 입력해주세요',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),

              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: _pwCon,
                onChanged: (v) {
                  us.pw.value = _pwCon.text.trim();
                },
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  hintText: '비밀번호를 입력해주세요',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  suffixIcon: !_obscureText
                      ? IconButton(
                          icon: Icon(
                            Icons.visibility_off_outlined,
                            size: 20,
                          ),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          color: Colors.black,
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.visibility_outlined,
                            size: 20,
                          ),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          color: Colors.black,
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                ),
                obscureText: !_obscureText,
                keyboardType: TextInputType.text,
              ),

              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: _phoneCon,
                onChanged: (v) {
                  us.number.value = _phoneCon.text.trim();
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(13),
                  FilteringTextInputFormatter.digitsOnly,
                  maskFormatter
                ],
                decoration: InputDecoration(
                    labelText: '휴대폰 번호',
                    hintText: '휴대폰 번호를 입력해주세요',
                    labelStyle: TextStyle(color: Colors.blueGrey),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    suffixIcon: ElevatedButton(
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
                            print('실패했습니다.');
                            print('${verificationFalied.message}');
                          },
                          codeSent: (String verifiationId,
                              int? resendingToken) async {
                            print('코드를 보냈습니다.');
                            setState(() {
                              verificationId = verifiationId;
                            });
                          },
                          codeAutoRetrievalTimeout: (verificationId) async {},
                        );
                      },
                      child: Text('인증번호'),
                    )),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: _otpCon,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(13),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                    labelText: '인증번호',
                    hintText: '인증번호를 입력해주세요',
                    labelStyle: TextStyle(color: Colors.blueGrey),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    suffixIcon: ElevatedButton(
                      onPressed: () {
                        if (_doubleCheck == 0) {
                          PhoneAuthCredential phoneAuthCredential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: _otpCon.text);
                          signInWithPhoneAuthCredential(phoneAuthCredential);
                        } else {
                          print('2');
                        }
                        setState(() {});
                      },
                      child: Text('인증번호 확인'),
                    )),
                keyboardType: TextInputType.number,
              ),
              _phoneAuth == true
                  ? Container(
                      child: Text('인증성공입니다.'),
                    )
                  : Text('인증실패입니다.'),
              const SizedBox(
                height: 12,
              ),
              TextField(
                  controller: _nameCon,
                  onChanged: (v) {
                    us.name.value = _nameCon.text.trim();
                  },
                  decoration: InputDecoration(
                    labelText: '이름',
                    hintText: '이름을 입력해주세요',
                    labelStyle: TextStyle(color: Colors.blueGrey),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  keyboardType: TextInputType.text),

              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: _birthCon,
                onChanged: (v) {
                  us.year.value = _birthCon.text.split('/')[0];
                  us.month.value = _birthCon.text.split('/')[1];
                  us.day.value = _birthCon.text.split('/')[2];
                },
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                  maskFormatter2
                ],
                decoration: InputDecoration(
                  labelText: '생년월일',
                  hintText: '생년월일을 입력해주세요(0000/00/00)',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 1.0)),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedValue,
                  hint: Text('타입을 선택해주세요'),
                  onChanged: (newValue) {
                    setState(() {
                      selectedValue = newValue;
                      us.userType.value = selectedValue!;
                    });
                  },
                  items: <String>['학생', '선생']
                      .map<DropdownMenuItem<String>>((String value) {
                    // ignore: missing_required_param
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_idCon.text.trim().isEmpty == true ||
                        _pwCon.text.trim().isEmpty == true ||
                        _phoneCon.text.trim().isEmpty == true ||
                        _nameCon.text.trim().isEmpty == true ||
                        _birthCon.text.trim().isEmpty == true) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                content: Text('모든 칸에 입력해주세요'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('네'))
                                ],
                              ));
                    } else {
                      us.addUser(
                          us.id.value,
                          us.pw.value,
                          us.number.value,
                          us.name.value,
                          us.year.value,
                          us.month.value,
                          us.day.value,
                          us.userType.value);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                content: Text('회원가입이 완료되었습니다.'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('네'))
                                ],
                              ));
                    }
                    ;
                  },
                  child: Text('회원가입 완료'))
            ],
          ),
        ),
      ),
    );
  }

  //휴대폰 인증 확인
  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        print('인공입니다');
        setState(() {
          _authOk = true;
          _phoneAuth = true;
          _isConfirm = true;
          print("인증완료 및 로그인성공 _auth ok 는 true");
        });
        _doubleCheck = 1;
        await _auth.currentUser!.delete();
        print("auth정보삭제");
        _auth.signOut();
        print("phone 로그인된것 로그아웃");

        // cancelTimer();
        print('인증번호 일치');

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
        _authOk = false;
      });
      print('인증번호 일치하지 않습니다');
      print('실패');
      print('Error Log Phone Auth : ');
    }
  }
}
