// import 'package:cloud_firestore/cloud_firestore.dart';
//
// Future<void> communityStoryGet (String id) async{
//   CollectionReference ref = FirebaseFirestore.instance.collection('story');
//   QuerySnapshot snapshot = await ref.where('id', isEqualTo: id).get();
//   final allData = snapshot.docs.map((doc) => doc.data()).toList();
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../provider/community_state.dart';

Future<void> firebaseBlockCreate(String block, String blocked, String collectionName,
    String commentField, String blockDocId) async {
  final cs = Get.put(CommunityState());
  try {
    final CollectionReference ref = FirebaseFirestore.instance.collection('block');
    await ref.add({
      'blockDocId' : blockDocId,
      'blockId' : block,
      'blockedId' : blocked,
      'collectionName' : collectionName,
      'commentField' : commentField,
      'createDate' : '${DateTime.now()}',
      'docId' : '',
      'state' : '처리중',
    }).then((doc) async {
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('block').doc(doc.id);
      await userDocRef.update({'docId': '${doc.id}'});
    });
  } catch (e) {
    print(e);
  }
}

Future<void> blockGet(String id)async{
  final cs = Get.put(CommunityState());
  CollectionReference ref = FirebaseFirestore.instance.collection('block');
  try {
    QuerySnapshot snapshot = await ref.where('blockId', isEqualTo: id).get();
    cs.comBlock.value = snapshot.docs.map((doc) => doc.data()).toList();
    print('${cs.comBlock.value}');

  } catch (e) {
    print(e);
  }
}