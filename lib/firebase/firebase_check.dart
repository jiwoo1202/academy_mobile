import 'dart:math';

import 'package:academy/provider/check_state.dart';
import 'package:academy/provider/user_state.dart';
import 'package:academy/screen/check/teacherCheck/classCheck.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
// 출석등록 업로드
Future<void> checkUpload(String data)async{
  final us = Get.put(UserState());
  CollectionReference ref = FirebaseFirestore.instance.collection('check');
  ref.add({
    'teacherId': us.userList[0].id,
    'qrcode' : data, // qr코드 넘버 넣는곳
    'createDate':'${DateTime.now()}',
    'date':'${DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(DateTime.now())}',
    'checkStudent':[],
    'lat':'',
    'lng':'',
    'state':'대기',
  }).then((doc) async {
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('check').doc(doc.id);
    await userDocRef.update({'docId': '${doc.id}'});
    Get.back();
    Get.back();
  });
}
// 내가 올린 출석 관리 가져오기
Future<void> getmyCheckUpload(String teacherId)async{
  final cs = Get.put(CheckState());
  try{
    CollectionReference ref = FirebaseFirestore.instance.collection('check');
    QuerySnapshot snapshot = await ref.where('teacherId', isEqualTo: teacherId).orderBy('createDate', descending: true).get();
    final allData = snapshot.docs.map((doc) => doc.data()).toList();
    List a = allData;
    cs.myCheckList.value = a;

    print('길이는 ?? ${cs.myCheckList[0]['state']}');
  }catch(e){
    print(e);
  };
}
// 학생이 출석하기
Future<void> studentCheck(String qrcode, String id)async{
  CollectionReference ref = FirebaseFirestore.instance.collection('check');
  QuerySnapshot snapshot = await ref.where('qrcode', isEqualTo: qrcode).get();
  snapshot.docs[0].reference.update({'checkStudent' :FieldValue.arrayUnion(['${id}'])});
  Get.back();
  Get.back();
}

// 상태 변경할때 쓰는 함수
Future<void> updateState(String docId, String value) async {
  CollectionReference ref = FirebaseFirestore.instance.collection('check');
  QuerySnapshot snapshot = await ref.where('docId', isEqualTo: docId).get();
  snapshot.docs[0].reference.update({'state': '${value}'});
}

// 중복출석번호 한번 걸러주기
Future<void>checkQrCode(String qrcode) async{
    final cs = Get.put(CheckState());
    int max = 3;
    int min = 1;
    Random rnd = new Random();
    String data = '';
    data = '${min+rnd.nextInt(max-min)}'; // 두번째 랜덤변수
    print('두번째 랜덤변수 는?? ${data}');
    CollectionReference ref = FirebaseFirestore.instance.collection('check');
    QuerySnapshot snapshot = await ref.where('qrcode', isEqualTo: qrcode).get();
    final allData = snapshot.docs.map((doc) => doc.data()).toList();
    List a = allData;
    if(a.length==0){
      print('비었어요');
      cs.checkQrcode.value = 'false';
    }
    else{
      print('들어있어요');
      cs.checkQrcode.value = 'true';
    }
    print('중복인가요? ${cs.checkQrcode.value}');
}
