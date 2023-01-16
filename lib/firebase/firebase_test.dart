
import 'package:academy/provider/user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../provider/test_state.dart';

Future<void> firebaseTestUpload() async{
  final ts = Get.put(TestState());
  final us = Get.put(UserState());

  CollectionReference ref = FirebaseFirestore.instance.collection('test');
  ref.add({
    'answer': ts.answer,
    'id' : us.number.value,
    'createDate' : '${DateTime.now()}'
  });
}

Future<void> firebaseAnswerGet() async{
  final ts = Get.put(TestState());

  CollectionReference ref = FirebaseFirestore.instance.collection('answer');
  QuerySnapshot snapshot = await ref.where('question', isEqualTo: 'q1').get();

  final allData = snapshot.docs.map((doc) => doc.data()).toList();
  ts.realAnswer.value = allData;
  print('real answer : ${ts.realAnswer}');
}

Future<void> firebaseQuestionGet() async{
  final ts = Get.put(TestState());
  final us = Get.put(UserState());

  CollectionReference ref = FirebaseFirestore.instance.collection('test');
  QuerySnapshot snapshot = await ref.where('id', isEqualTo: us.number.value).get();

  final allData = snapshot.docs.map((doc) => doc.data()).toList();
  ts.myAnswer.value = allData;
}