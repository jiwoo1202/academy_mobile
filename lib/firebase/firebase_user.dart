import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user.dart';

Future<void> userGet()async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference ref = _firestore.collection('user');
  QuerySnapshot snapshot = await ref.where('id', isEqualTo: '1234').get();
  final allData = snapshot.docs.map((doc) => doc.data()).toList();
  print('id : ${allData.length}');
  print('id222 : ${allData}');
}

Future<void> firebaseUserDelete(String docId) async {
  CollectionReference ref = FirebaseFirestore.instance.collection('user');
  QuerySnapshot snapshot = await ref.where('docId', isEqualTo: '${docId}').get();
  snapshot.docs[0].reference.delete();
}

Future<void> firebaseUserUpdate(String docId, String changeKey, String changeValue) async {
  try {
    print('docId: ${docId} , ${changeKey} , ${changeValue}');
    CollectionReference ref = FirebaseFirestore.instance.collection('user');
    QuerySnapshot snapshot = await ref
        .where('docId', isEqualTo: docId).get();
    snapshot.docs[0].reference.update({'${changeKey}' : changeValue});
  } catch (e) {
    print(e);
  }
}

Future<void> firebaseUserCreate(String createDate, String day, String docId, String email, String group,
    String id, String month, String name, String phoneNumber, String pw, String temp1, String temp2, String token,
    String userType, String year) async {
  try {
    final CollectionReference ref = FirebaseFirestore.instance.collection('user');
    User users = User(
      createDate: createDate,
      day: day,
      docId: docId,
      email : email,
      group : group,
      id : id,
      month : month,
      name: name,
      phoneNumber : phoneNumber,
      pw: pw,
      temp1: temp1,
      temp2: temp2,
      token: token,
      userType: userType,
      year: year,
    );
    await ref.add(users.toMap()).then((doc) async {
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('user').doc(doc.id);
      await userDocRef.update({'docId': '${doc.id}'});
    });
  } catch (e) {
    print(e);
  }
}