
import 'package:academy/provider/user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../provider/test_state.dart';
import '../screen/main/student/test/test_check_screen.dart';

Future<void> firebaseTestUpload() async{
  final ts = Get.put(TestState());
  final us = Get.put(UserState());

  CollectionReference ref = FirebaseFirestore.instance.collection('test');
  ref.add({
    'answer': ts.answer,
    // 'id' : us.number.value,
    'id' : '01048544580',
    'createDate' : '${DateTime.now()}'
  }).then((doc) async {
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('test').doc(doc.id);
    await userDocRef.update({'docId': '${doc.id}'});
    ts.testDocId.value = doc.id;
    Get.to(() => TestCheckScreen(
    ));
    print('ts value test : ${ts.testDocId.value}');
  });
}

Future<void> firebaseAnswerGet() async{
  final ts = Get.put(TestState());

  CollectionReference ref = FirebaseFirestore.instance.collection('answer');
  QuerySnapshot snapshot = await ref.where('docId', isEqualTo: 'mj3HJ1QeWAj2TOk3ozPt').get();

  final allData = snapshot.docs.map((doc) => doc.data()).toList();
  ts.realAnswer.value = allData;
  print('real answer : ${ts.realAnswer}');
}

Future<void> firebaseAllQuestionGet() async{
  final ts = Get.put(TestState());
  final us = Get.put(UserState());

  CollectionReference ref = FirebaseFirestore.instance.collection('test');
  QuerySnapshot snapshot = await ref.where('id', isEqualTo: '01048544580').get();

  final allData = snapshot.docs.map((doc) => doc.data()).toList();
  ts.myAnswer.value = allData;
}


Future<void> firebaseSingleQuestionGet(String docId) async{
  final ts = Get.put(TestState());

  CollectionReference ref = FirebaseFirestore.instance.collection('test');
  QuerySnapshot snapshot = await ref.where('docId', isEqualTo: docId).get();

  final allData = snapshot.docs.map((doc) => doc.data()).toList();
  ts.mySingleAnswer.value = allData;
}