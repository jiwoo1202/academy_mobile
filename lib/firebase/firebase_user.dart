
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> userGet()async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference ref = _firestore.collection('user');
  QuerySnapshot snapshot = await ref.where('id', isEqualTo: '1234').get();
  final allData = snapshot.docs.map((doc) => doc.data()).toList();
  print('id : ${allData.length}');
  print('id222 : ${allData}');
}