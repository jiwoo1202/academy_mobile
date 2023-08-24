import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../provider/user_state.dart';
//qna 업로드
// Future<void> qnaUpload() async {
//   final us = Get.put(UserState());
//   CollectionReference ref = FirebaseFirestore.instance.collection('qna');
//   ref.add({
//     'title': us.qnaTitle.value,
//     'body' : us.qnaBody.value,
//     'images': us.qnaImgs,
//     'writeDocId':us.userList[0].docId,
//   }).then((doc) async {
//     DocumentReference userDocRef =
//     FirebaseFirestore.instance.collection('qna').doc(doc.id);
//     await userDocRef.update({'docId': '${doc.id}'});
//     // if (_imageFileList!.length != 0) {
//     //   await userDocRef.update({'hasImage': 'true'});
//     //   await uploadFile(doc.id, '${us.userList[0].phoneNumber}', 'story');
//     // }
//   });
// }
// 내가 쓴 qna 가져오기
Future<void> getmyQna(String docId)async{
  final us = Get.put(UserState());
  CollectionReference ref = FirebaseFirestore.instance.collection('qna');
  try {
    QuerySnapshot snapshot = await ref.where('writeDocId', isEqualTo: docId).orderBy('createDate', descending: true).get();
    us.getmyQna.value = snapshot.docs.map((doc) => doc.data()).toList();
    print('내가쓴 qna: ${us.getmyQna.value}');

  } catch (e) {
    print(e);
  }
}