// //내가 차단한 유저
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// Future<void> getBlockData(String phoneNumber) async {
//
//   // String phoneNumber
//   try {
//     CollectionReference ref = FirebaseFirestore.instance.collection('block');
//
//     QuerySnapshot snapshot = await ref.where('blockedBy', isEqualTo: 'phoneNumber').get();
//     final allData = snapshot.docs.map((doc) => doc.data()).toList();
//     List a = allData;
//
//
//   } catch (e) {
//     print(e);
//   }
// }