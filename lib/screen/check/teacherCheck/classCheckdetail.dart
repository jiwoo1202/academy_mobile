import 'dart:math';

import 'package:academy/provider/check_state.dart';
import 'package:academy/provider/user_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../firebase/firebase_check.dart';
import '../../../util/font/font.dart';

class CheckDetail extends StatefulWidget {
  final String? qrcode;
  final String? state;
  final String? createDate;
  const CheckDetail({Key? key, this.qrcode, this.state, this.createDate}) : super(key: key);

  @override
  State<CheckDetail> createState() => _CheckDetailState();
}

class _CheckDetailState extends State<CheckDetail> {
  String formatnow = DateFormat("yyyy년 MM월 dd일 HH시 mm분").format(DateTime.now());

  // int max = 999999;
  // int min = 100000;
  int max = 3;
  int min = 1;
  Random rnd = new Random();
  String data = '';
  final us = Get.put(UserState());
  final cs = Get.put(CheckState());
  @override
  void initState() {
    data = '${min+rnd.nextInt(max-min)}'; // 처음 랜던변수 하나 만듬
    checkQrCode('${data}');
    print('첫번째 랜덤변수는 ?? ${data}');
    // 중복이면
    if(cs.checkQrcode.value=='true'){
      while(true){
        data = '${min+rnd.nextInt(max-min)}';
        //리스트에 생성한게 없으면
        if(!cs.rndList.contains(data)){
          cs.rndList.add(data);
        }
        if(cs.rndList.length==1){
          break;
        }
      }
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '출석 등록',
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
              await checkUpload(data);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 28),
              child: Center(
                  child: Text(
                    '저장',
                    style: f16w700primary,
                  )),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20,top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.state=='수정'?Text('${widget.createDate}',style: f21w700,):Text('${formatnow}',style: f21w700,),
            SizedBox(
              height: 20,
            ),
            Text('선생님 : ${us.userList[0].id}',style: f21w700,),
            SizedBox(
              height: 20,
            ),
            Text('출석번호',style: f21w700,),
            SizedBox(
              height: 20,
            ),
            widget.state=='수정'?Text('${widget.qrcode}',style: f24w700primary,):Text('${data}',style: f24w700primary,),
            SizedBox(
              height: 20,
            ),
            Text('QR코드',style: f21w700,),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                width: 200,
                height: 200,
                child: QrImage(
                  version: 3,
                  size: 200,
                  data: widget.state=='수정'?'${widget.qrcode}': data,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            widget.state=='수정'?Text('출석인원',style: f21w700,):Container(),
            SizedBox(
              height: 20,
            ),
            widget.state=='수정'?Container(child: Text('22'),):Container()
          ],
        ),
      ),
    );
  }
}
