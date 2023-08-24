import 'package:cloud_firestore/cloud_firestore.dart';

class Answer {
  String? createDate;
  List answer;
  List individualFile;
  List individualTitle;
  List individualBody;
  List images;
  List audio;
  List student;
  String? isIndividual;
  String? answerCount;
  String? docId;
  String? nickName;
  String? group;
  String? password;
  String? pdfCategory;
  String? pdfName;
  List? pdfUploadName;
  List? pdfUploadName2;
  String? state;
  String? teacher;
  List? temp1;
  String? temp2;

  Answer(
      {required this.createDate,
        required this.answer,
        required this.individualFile,
        required this.individualTitle,
        required this.individualBody,
        required this.images,
        required this.isIndividual,
        required this.answerCount,
        required this.docId,
        required this.group,
        required this.password,
        required this.pdfCategory,
        required this.pdfName,
        required this.pdfUploadName2,
        required this.state,
        required this.teacher,
        required this.temp1,
        required this.temp2,
        required this.audio,
      required this.nickName,
      required this.student,
      required this.pdfUploadName});

  Answer.fromMap(Map<String, dynamic> map)
      : createDate = map['createDate'],
        answer = map['answer'].cast<String>(),
        individualTitle = map['individualTitle'].cast<String>(),
        individualBody = map['individualBody'].cast<String>(),
        images = map['images'].cast<String>(),
        answerCount = map['answerCount'],
        isIndividual = map['isIndividual'],
        individualFile = map['individualFile'].cast<String>(),
        student = map['student'].cast<String>(),
        docId = map['docId'],
        group = map['group'],
        password = map['password'],
        pdfCategory = map['pdfCategory'],
        pdfName = map['pdfName'],
        pdfUploadName = map['pdfUploadName'],
        pdfUploadName2 = map['pdfUploadName2'],
        state = map['state'],
        teacher = map['teacher'],
        temp1 = map['temp1'],
        temp2 = map['temp2'],
        audio = map['audio'].cast<String>(),
        nickName = map['nickName'];

  Map<String, dynamic> toMap() {
    return {
      "createDate": createDate,
      "answer": answer,
      "individualFile": individualFile,
      "individualBody": individualBody,
      "individualTitle": individualTitle,
      "images": images,
      "student": student,
      "isIndividual": isIndividual,
      "answerCount": answerCount,
      "docId" : docId,
      "group" : group,
      "password" : password,
      "pdfCategory" : pdfCategory,
      "pdfName" : pdfName,
      "pdfUploadName" : pdfUploadName,
      "pdfUploadName2" : pdfUploadName2,
      "state": state,
      "teacher" : teacher,
      "temp1": temp1,
      "temp2": temp2,
      "audio": audio,
      "nickName": nickName
    };
  }

  factory Answer.fromDocument(DocumentSnapshot doc) {
    return Answer(
      docId: doc.id,
      createDate: doc['createDate'],
      answer: doc['answer'].cast<String>(),
      individualFile: doc['individualFile'].cast<String>(),
      individualTitle: doc['individualTitle'].cast<String>(),
      individualBody: doc['individualBody'].cast<String>(),
      images: doc['images'].cast<String>(),
      isIndividual: doc['isIndividual'],
      answerCount : doc['answerCount'],
      group: doc['group'],
      password: doc['password'],
      pdfCategory : doc['pdfCategory'],
      pdfName : doc['pdfName'],
      pdfUploadName2 : doc['pdfUploadName2'],
      pdfUploadName : doc['pdfUploadName'],
      state : doc['state'],
      teacher : doc['teacher'],
      temp1: doc['temp1'],
      temp2: doc['temp2'],
      audio: doc['audio'].cast<String>(),
      nickName: doc['nickName'],
      student: doc['student'].cast<String>(),
    );
  }
}
