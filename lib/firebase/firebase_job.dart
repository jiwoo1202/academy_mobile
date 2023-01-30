import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';
import 'package:get/get.dart';

import '../provider/job_state.dart';
import '../provider/user_state.dart';

Future<List> jobGet(String docId)async{
  final controller = Get.put(JobState());
  CollectionReference ref = FirebaseFirestore.instance.collection('jobHunting');
  try {
    QuerySnapshot snapshot = await ref.where('docId', isEqualTo: docId).get();
    // controller.userList.value = snapshot.docs.map<User>((doc) {
    //   return User.fromDocument(doc);
    // }).toList();
    final allData = snapshot.docs.map((doc) => doc.data()).toList();
    print('job222 : ${allData.length}');
    List ls = allData;
    return ls;
  } catch (e) {
    print(e);
  }
  return [];
}

Future<void> jobFullGet(String teacher)async{
  final controller = Get.put(JobState());
  CollectionReference ref = FirebaseFirestore.instance.collection('jobHunting');
  try {
    QuerySnapshot snapshot = await ref.where('teacher', isEqualTo: teacher).get();
    controller.userL.value = snapshot.docs.map((doc) => doc.data()).toList();

  } catch (e) {
    print(e);
  }
}

// 자신말고 다른사람 구인공고(추가)
Future<void> notjobFullGet(String teacher)async{
  final controller = Get.put(JobState());
  final us = Get.put(UserState());
  final js = Get.put(JobState());
  CollectionReference ref = FirebaseFirestore.instance.collection('jobHunting');
  try {
    QuerySnapshot snapshot = await ref.where('teacher', isNotEqualTo: teacher).get();
    final allData1 = snapshot.docs.map((doc) => doc.data()).toList();
    List a = allData1;

    CollectionReference ref2 = FirebaseFirestore.instance.collection('block');
    QuerySnapshot snapshot2 = await ref2.where('blockId', isEqualTo: us.userList[0].phoneNumber)
        .where('collectionName', isEqualTo: 'story').where('commentField', isEqualTo: 'true').get();
    final allData = snapshot2.docs.map((doc) => doc.data()).toList();
    print('55555 : ${allData.length}');
    List ls = allData;

    List ls3 = [];
    int count = 0;

    for(int i=0; i<a.length; i++) {
      count = 0;
      for(int j=0; j<ls.length; j++) {
        if(a[i]['docId'] == ls[j]['blockDocId']){
          count ++;
        }
      }
      if(count == 0) {
        ls3.add(a[i]);
      }
    }
    js.notuserL.value= ls3;
    print('차단한BlockList: ${js.notuserL.value} ');


  } catch (e) {
    print(e);
  }
}

Future<void> firebaseJobDelete(String docId) async {
  CollectionReference ref = FirebaseFirestore.instance.collection('jobHunting');
  QuerySnapshot snapshot = await ref.where('docId', isEqualTo: '${docId}').get();
  snapshot.docs[0].reference.delete();
}

Future<void> firebaseJobUpdate(String docId, String changeKey, String changeValue) async {
  try {
    CollectionReference ref = FirebaseFirestore.instance.collection('jobHunting');
    QuerySnapshot snapshot = await ref
        .where('docId', isEqualTo: docId).get();
    snapshot.docs[0].reference.update({'${changeKey}' : changeValue});
  } catch (e) {
    print(e);
  }
}

Future<void> firebaseJobCreate(String age, String ageValue, String body, String closeH, String closeM, String gender,
    String hasImage, String openH, String openM, String pay, String payValue, String title) async {
  final js = Get.put(JobState());
  try {
    final CollectionReference ref = FirebaseFirestore.instance.collection('jobHunting');
    await ref.add({
      'age' : age,
      'ageValue' : ageValue,
      'body' : body,
      'closeH' : closeH,
      'closeM' : closeM,
      'docId' : '',
      'gender' : gender,
      'hasImage' : hasImage,
      'openH' : openH,
      'openM' : openM,
      'pay' : pay,
      'payValue' : payValue,
      'teacher' : '01081383877',
      'title' : title,
      'createDate' : '${DateTime.now()}',
    }).then((doc) async {
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('jobHunting').doc(doc.id);
      js.jobDocId.value = doc.id;
      await userDocRef.update({'docId': '${doc.id}'});
    });
  } catch (e) {
    print(e);
  }
}

Future<void> communityCommentWrite (String body, String docId) async{
  final js = Get.put(JobState());
  CollectionReference ref = FirebaseFirestore.instance.collection('jobHunting').doc(docId).collection('comments');
  ref.add({
    'id' : '01081383877',
    'docId' : '',
    'body' : body,
    'status' : '게시중',
    'type' : '선생님',
    'name' : '김아무개',
    'createDate' : '${DateTime.now()}',
  }).then((doc) async {
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('jobHunting').doc(docId).collection('comments').doc(doc.id);
    await userDocRef.update({'docId': '${doc.id}'});
  });
}

Future<void> commentOrderBy(String? docId, String orderBy) async {
  final js = Get.put(JobState());
  CollectionReference ref = FirebaseFirestore.instance.collection('jobHunting').doc(docId).collection('comments');
  if (orderBy == 'date') {
    QuerySnapshot snapshot = await ref.orderBy('createDate', descending: false).get();
    final allData = snapshot.docs.map((doc) => doc.data()).toList();
    js.commentL.value = allData;
  } else if (orderBy == 'recommended') {
    QuerySnapshot snapshot = await ref.orderBy('likeInt', descending: true).get();
    final allData = snapshot.docs.map((doc) => doc.data()).toList();
    js.commentL.value = allData;
  }
}

Future<List> jobBlockExceptGet(String docId) async {
  final us = Get.put(UserState());
  try {
    CollectionReference ref2 = FirebaseFirestore.instance.collection('block');
    QuerySnapshot snapshot2 = await ref2
        .where('blockId', isEqualTo: us.userList[0].phoneNumber)
        .where('collectionName', isEqualTo: 'story')
        .where('commentField', isEqualTo: 'true')
        .get();
    final allData = snapshot2.docs.map((doc) => doc.data()).toList();
    print('55555 : ${allData.length}');
    List ls = allData;

    CollectionReference ref = FirebaseFirestore.instance
        .collection('jobHunting').doc(docId).collection('comments');
    QuerySnapshot snapshot = await ref.get();
    final allData2 = snapshot.docs.map((doc) => doc.data()).toList();
    print('how 777 : ${allData2.length}');
    // _commentsList = allData2;
    List ls2 = allData2;
    List ls3 = [];
    int count = 0;
    for (int i = 0; i < ls2.length; i++) {
      count = 0;
      for (int j = 0; j < ls.length; j++) {
        if (ls2[i]['docId'] == ls[j]['blockDocId']) {
          count++;
        }
      }
      if (count == 0) {
        ls3.add(ls2[i]);
      }
    }
    return ls3;
  } catch (e) {
    print(e);
  }
  return [];
}
