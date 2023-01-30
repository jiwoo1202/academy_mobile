
import 'package:academy/provider/user_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../provider/answer_state.dart';
import '../provider/test_state.dart';
import '../screen/main/student/test/test_check_screen.dart';

Future<void> firebaseTestUpload() async{
  final ts = Get.put(TestState());
  // final us = Get.put(UserState());
  final as = Get.put(AnswerState());
  CollectionReference ref = FirebaseFirestore.instance.collection('test');
  ref.add({
    'answer': ts.answer,
    // 'id' : us.number.value,
    'id' : '01048544580',
    'answerDocid':ts.answerDocId.value,
    'teacher':as.getTeacherName.value
  }).then((doc) async {
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('test').doc(doc.id);
    await userDocRef.update({'docId': '${doc.id}'});
    ts.testDocId.value = doc.id;
    Get.to(() => TestCheckScreen(
    ));
    print('1111${as.docId.value}');
    print('ts value test : ${ts.testDocId.value}');
  });
}

Future<void> firebaseAnswerGet(String docId) async{
  final ts = Get.put(TestState());

  CollectionReference ref = FirebaseFirestore.instance.collection('answer');
  QuerySnapshot snapshot = await ref.where('docId', isEqualTo: docId).get();

  final allData = snapshot.docs.map((doc) => doc.data()).toList();
  List a = allData;
  ts.realAnswer.value = allData;
  print('real answer : ${ts.realAnswer.length}');
}


Future<void> firebaseAllQuestionGet() async{
  final ts = Get.put(TestState());
  final us = Get.put(UserState());
  final as = Get.put(AnswerState());
  CollectionReference ref = FirebaseFirestore.instance.collection('test');
  QuerySnapshot snapshot = await ref.where('id', isEqualTo: '01048544580').get();

  final allData = snapshot.docs.map((doc) => doc.data()).toList();
  List a = allData;
  ts.myAnswer.value = allData;

  for(int i=0;i<a.length;i++){
    ts.teacherNameList.add(a[i]['teacher']);
  }
  print('선생님 명단${ts.teacherNameList.value}');
}


Future<void> firebaseSingleQuestionGet(String docId) async{
  final ts = Get.put(TestState());

  CollectionReference ref = FirebaseFirestore.instance.collection('test');
  QuerySnapshot snapshot = await ref.where('docId', isEqualTo: docId).get();

  final allData = snapshot.docs.map((doc) => doc.data()).toList();
  ts.mySingleAnswer.value = allData;
  print('real answer1241224124 : ${ts.mySingleAnswer.length}');

}