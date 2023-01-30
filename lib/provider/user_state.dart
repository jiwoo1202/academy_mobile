import 'package:academy/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserState extends GetxController{
  //파베 시작
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final count = 0.obs;
  final name = ''.obs;
  final number = ''.obs;
  final searchText = ''.obs;
  final userList = <User>[].obs;
  final id = ''.obs;
  final pw = ''.obs;
  final userType = ''.obs;
  final year = ''.obs;
  final month = ''.obs;
  final day = ''.obs;
  void increase(){
    count.value ++;
    update();
  }
  void decrease(){
    count.value --;
    update();
  }
  // 회원가입
  Future addUser(String id, String pw, String phoneNumber,String name,String year,String month, String day, String userType) async {
    try{
      DocumentReference docRef = _firestore.collection("user").doc();
      User docUser = User(
          createDate: '${DateTime.now()}',
          docId:docRef.id,
          id: id,
          pw: pw,
          phoneNumber: phoneNumber,
          name: name,
          year: year,
          month: month,
          day: day,
          userType: userType
      );
      await docRef.set(docUser.toMap());
    }catch(e){
      print(e);
    }
    update();
  }
//로그인

}