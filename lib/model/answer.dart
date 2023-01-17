import 'package:cloud_firestore/cloud_firestore.dart';

class Answer {
  String? createDate;
  List answer;
  String? answerCount;
  String? docId;
  String? group;
  String? password;
  String? pdfCategory;
  String? pdfName;
  String? pdfUploadName;
  String? state;
  String? teacher;
  String? temp1;
  String? temp2;

  Answer(
      {required this.createDate,
        required this.answer,
        required this.answerCount,
        required this.docId,
        required this.group,
        required this.password,
        required this.pdfCategory,
        required this.pdfName,
        required this.pdfUploadName,
        required this.state,
        required this.teacher,
        required this.temp1,
        required this.temp2,});

  Answer.fromMap(Map<String, dynamic> map)
      : createDate = map['createDate'],
        answer = map['answer'].cast<String>(),
        answerCount = map['answerCount'],
        docId = map['docId'],
        group = map['group'],
        password = map['password'],
        pdfCategory = map['pdfCategory'],
        pdfName = map['pdfName'],
        pdfUploadName = map['pdfUploadName'],
        state = map['state'],
        teacher = map['teacher'],
        temp1 = map['temp1'],
        temp2 = map['temp2'];

  Map<String, dynamic> toMap() {
    return {
      "createDate": createDate,
      "answer": answer,
      "answerCount": answerCount,
      "docId" : docId,
      "group" : group,
      "password" : password,
      "pdfCategory" : pdfCategory,
      "pdfName" : pdfName,
      "pdfUploadName" : pdfUploadName,
      "state": state,
      "teacher" : teacher,
      "temp1": temp1,
      "temp2": temp2,
    };
  }

  factory Answer.fromDocument(DocumentSnapshot doc) {
    return Answer(
      docId: doc.id,
      createDate: doc['createDate'],
      answer: doc['answer'].cast<String>(),
      answerCount : doc['answerCount'],
      group: doc['group'],
      password: doc['password'],
      pdfCategory : doc['pdfCategory'],
      pdfName : doc['pdfName'],
      pdfUploadName : doc['pdfUploadName'],
      state : doc['state'],
      teacher : doc['teacher'],
      temp1: doc['temp1'],
      temp2: doc['temp2'],
    );
  }
}
