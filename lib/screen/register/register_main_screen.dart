import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void dispose() {
    // TODO: implement dispose
    _idCon.dispose();
    _pwCon.dispose();
    _phoneCon.dispose();
    _otpCon.dispose();
    _nameCon.dispose();
    _birthCon.dispose();
    // _monthCon.dispose();
    // _dayCon.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('회원가입',style: TextStyle(color: Colors.black,fontSize: 20),),
          centerTitle: true,
          backgroundColor: Colors.orangeAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _idCon,
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
              const SizedBox(height: 12,),
              TextField(
                controller: _pwCon,
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
              const SizedBox(height: 12,),

              TextField(
                controller: _phoneCon,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(13),
                  FilteringTextInputFormatter.digitsOnly,
                  maskFormatter
                  // TextInputMask(mask: '999-9999-9999', reverse: false)
                  // _mobileMask
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
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12,),

              TextField(
                controller: _nameCon,
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
                keyboardType: TextInputType.text
              ),
              const SizedBox(height: 12,),

              TextField(
                controller: _birthCon,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
