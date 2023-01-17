import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String? createDate;
  String? day;
  String? docId;
  String? email;
  String? group;
  String? id;
  String? month;
  String? name;
  String? phoneNumber;
  String? pw;
  String? temp1;
  String? temp2;
  String? token;
  String? userType;
  String? year;

  User(
      {this.createDate,
        this.day,
        this.docId,
        this.email,
        this.group,
        this.id,
        this.month,
        this.name,
        this.phoneNumber,
        this.pw,
        this.temp1,
        this.temp2,
        this.token,
        this.userType,
        this.year,});

  User.fromMap(Map<String, dynamic> map)
      : createDate = map['createDate'],
        day = map['day'],
        docId = map['docId'],
        email = map['email'],
        group = map['group'],
        id = map['id'],
        month = map['month'],
        name = map['name'],
        phoneNumber = map['phoneNumber'],
        pw = map['pw'],
        temp1 = map['temp1'],
        temp2 = map['temp2'],
        token = map['token'],
        userType = map['userType'],
        year = map['year'];

  Map<String, dynamic> toMap() {
    return {
      "createDate": createDate,
      "day": day,
      "docId": docId,
      "email" : email,
      "group" : group,
      "id" : id,
      "month" : month,
      "name": name,
      "phoneNumber" : phoneNumber,
      "pw": pw,
      "temp1": temp1,
      "temp2": temp2,
      "token": token,
      "userType": userType,
      "year": year,
    };
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        docId: doc.id,
        createDate: doc['createDate'],
        day: doc['day'],
        email : doc['email'],
        group: doc['group'],
        id : doc['id'],
        month : doc['month'],
        name : doc['name'],
        phoneNumber : doc['phoneNumber'],
        pw: doc['pw'],
        temp1: doc['temp1'],
        temp2: doc['temp2'],
        token: doc['token'],
        userType: doc['userType'],
        year: doc['year'],
    );
  }
}
