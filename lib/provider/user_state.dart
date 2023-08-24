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
  final nickName = ''.obs;
  final findPassWord = ''.obs;
  final pwCheck = ''.obs; // 비밀번호 암/복호화

  final qnaTitle = ''.obs; // qna 제목
  final qnaBody = ''.obs; // qna 내용
  final qnaImgs = [].obs; // qna 사진
  final getmyQna = [].obs; // 내가쓴 질문 가져옴


  final usGetId = ''.obs; // 비밀번호찾기에서 유저 닥아이디 넣기 위해

  final usipAddress = ''.obs;
  final usinterface = ''.obs;
  final usipType = ''.obs;


  // 회원가입
  Future addUser(String id, String pw, String phoneNumber,String name,String year,String month, String day, String userType,String nickName) async {
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
          userType: userType,
          isBanned: [],
          nickName: nickName
      );
      await docRef.set(docUser.toMap());
    }catch(e){
      print(e);
    }
    update();
  }
//로그인

}