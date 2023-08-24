
import 'package:academy/screen/login/login_main_screen.dart';
import 'package:academy/screen/main/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../components/dialog/showAlertDialog.dart';
import '../model/user.dart';
import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart'as en;
import '../provider/user_state.dart';

Future<void> userGet(String id,String pw)async{
  final controller = Get.put(UserState());
  CollectionReference ref = FirebaseFirestore.instance.collection('user');
  try {
    QuerySnapshot snapshot = await ref.where('id', isEqualTo: id).get();
    final allData = snapshot.docs.map((doc) => doc.data()).toList();
    List a = allData;


    if(loginPasswordCheck(a[0]['pw'], 2) != pw){
      controller.pwCheck.value = '1';
    }
    else{
      controller.pwCheck.value = '';
    }
    controller.userList.value = snapshot.docs.map<User>((doc) {
           return User.fromDocument(doc);
    }).toList();
  } catch (e) {
    print(e);
  }
}

Future<void> firebaseUserDelete(String docId) async {
  CollectionReference ref = FirebaseFirestore.instance.collection('user');
  QuerySnapshot snapshot = await ref.where('docId', isEqualTo: '${docId}').get();
  snapshot.docs[0].reference.delete();
}

Future<void> firebaseUserUpdate(String docId, String changeKey, String changeValue) async {
  try {

    CollectionReference ref = FirebaseFirestore.instance.collection('user');
    QuerySnapshot snapshot = await ref
        .where('docId', isEqualTo: docId).get();
    snapshot.docs[0].reference.update({'${changeKey}' : changeValue});
  } catch (e) {
    print(e);
  }
}

Future<void> firebaseUserCreate() async {
  final us = Get.put(UserState());
  try {
    final CollectionReference ref = FirebaseFirestore.instance.collection('user');
    User users = User(
      createDate: '${DateTime.now()}',
      day: '',
      docId: '',
      email : '',
      group : 'group',
      id : '1234',
      month : 'month',
      name: 'name',
      phoneNumber : 'phoneNumber',
      pw: '1234',
      temp1: 'temp1',
      temp2: 'temp2',
      token: '',
      userType: '선생님',
      year: 'year',
    );
    await ref.add(users.toMap()).then((doc) async {
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('user').doc(doc.id);
      await userDocRef.update({'docId': '${doc.id}'});
    });
  } catch (e) {
    print(e);
  }
}
// 비밀번호 찾기
Future<void> findPassWord(String phoneNumber)async{
  final us = Get.put(UserState());
  try{
    CollectionReference ref = FirebaseFirestore.instance.collection('user');
    QuerySnapshot snapshot = await ref.where('phoneNumber', isEqualTo: phoneNumber).get();
    final allData = snapshot.docs.map((doc) => doc.data()).toList();
    List a = allData;
    us.findPassWord.value = a[0]['pw'];
    us.usGetId.value = a[0]['docId'];
  }catch(e){
    print(e);
  }
}

// 암호화/복호화 하는 키
String loginPasswordCheck(String text, int enOrDe) {
  //0510 enOrDe(1 encrypt, 2 decrypt)
  dynamic publicKey = en.RSAKeyParser().parse('-----BEGIN PUBLIC KEY-----\n'
      'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCzoN1rGpG4oIam1m2fup1ruY5e\n'
      'nRGxF9KJtnhc2XZZoTn2mRz+oqFJEvgN0DsfNrjpAJRModM9qHFx4u2wEZgSjHvI\n'
      '2IgVp0t5R2Ji/v3bwwcYKy9MUhL6Qp24EYyi6awh8uK8BovNCM7IzWFOgBxTtOJ8\n'
      'oBUkko01QfIIG+uoAQIDAQAB\n'
      '-----END PUBLIC KEY-----');
  dynamic privKey = en.RSAKeyParser().parse('-----BEGIN RSA PRIVATE KEY-----\n'
      'MIICWwIBAAKBgQCzoN1rGpG4oIam1m2fup1ruY5enRGxF9KJtnhc2XZZoTn2mRz+\n'
      'oqFJEvgN0DsfNrjpAJRModM9qHFx4u2wEZgSjHvI2IgVp0t5R2Ji/v3bwwcYKy9M\n'
      'UhL6Qp24EYyi6awh8uK8BovNCM7IzWFOgBxTtOJ8oBUkko01QfIIG+uoAQIDAQAB\n'
      'An8l48jQzsnuJ+4/QvvctYB/OKTPUFJrCJtgcRzyeOx9+4Q+gA2dqLBcuaOZRlMy\n'
      'Qli+zWB6yafFWcKUQ0nf2dY5t86wubsSAaHrSMDCASjLIJJeVDEqPe+Gj+w3RAXw\n'
      'vb8MW4l7I9T3sSRukn0CnIhGU0KT8+znTHQrAvxNFFbZAkEA+yyTC2FSEGrGqKEx\n'
      'Vao0ZBegnyoWIN26Xyh+i0c1mZKYHNw363NbMIo3VLQRrnQ08OzXNXE4pxKH+ACN\n'
      's1wAjwJBALcUYq619D42YmwpSoPLIUWAFHZmbQYQbO+N+wBlopP0nE6CimC5HsTI\n'
      'uMAqefnAXRIEU9CM5h3u+6zFVCyi9m8CQQD4JXqEtLppw8POl6nw8z3dYUZr2R2R\n'
      'jN1y48PZgBmhRqYHZT3N3OLLmtG9WkVZsC8ZkzOu9dO9o943EvzrpUpbAkEAliv9\n'
      'iiusDX/Umb4A5jwvrW+S2U/I6+l7QcBne/riMZS6xddkJFSUvXubt9zfspIshYPR\n'
      'MEby1ujZve0az4ZYtwJAa00wn3MncsMiYkwmPIqIruAT5AMkTHLGhddaEFmuQ/kP\n'
      'xrVrCDQlcV53PNeRoldVb2YSXu58gMeI/SOQIgKMzw==\n'
      '-----END RSA PRIVATE KEY-----');
  final encrypter = en.Encrypter(en.RSA(publicKey: publicKey, privateKey: privKey));
  if (enOrDe == 1) {
    final encrypted = encrypter.encrypt(text);
    return encrypted.base64.toString();
  } else {
    try {

      return encrypter.decrypt64(text).toString();
    } catch (Exception) {
      return text.toString();
    }
  }
}