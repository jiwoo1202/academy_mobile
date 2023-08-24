import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../provider/user_state.dart';


Future<void> loginLogCheck(String id,String nickName)  async{
  final us = Get.put(UserState());
  try {
    await getLocalIpAddress();
    await getPublicIP();
    var token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance.collection('log').add({
      'ID': id,
      'ip': us.usipAddress.value,
      'ipType' : us.usipType.value,
      'interface': us.usinterface.value,
      'time': '${DateTime.now()}',
      'deviceId': '$token',
      'nickName': nickName,
      'temp1' : '',
      'temp2' : '',
      'temp3' : '',
      'isApp' : 'true'
    });
    print('4');
  } catch (e) {
    print(e);
  }
}

Future<String?> getLocalIpAddress() async {
  final us = Get.put(UserState());
  final interfaces = await NetworkInterface.list();
  try {
    NetworkInterface vpnInterface = interfaces.firstWhere((element) => element.name == "tun0");
    // NetworkInterface vpnInterface = interfaces.firstWhere((element) => element.name == "wlan0");
    print('1 : ${vpnInterface.addresses.first.address}');
    print('1-1 : ${vpnInterface.addresses.first.type.name}');
    us.usinterface.value = vpnInterface.name;
    us.usipAddress.value = vpnInterface.addresses.first.address;
    us.usipType.value = vpnInterface.addresses.first.type.name;

    return vpnInterface.addresses.first.address;
  } on StateError {
    // Try wlan connection next
    try {
      NetworkInterface interface = interfaces.firstWhere((element) => element.name == "wlan0");
      print('2 : ${interface.addresses.first.address}');
      print('2-1 : ${interface.addresses.first.type.name}');
      us.usinterface.value = interface.name;
      us.usipAddress.value = interface.addresses.first.address;
      us.usipType.value = interface.addresses.first.type.name;

      return interface.addresses.first.address;
    } catch (ex) {
      // Try any other connection next
      try {
        NetworkInterface interface = interfaces.firstWhere((element) => !(element.name == "tun0" || element.name == "wlan0"));
        print('3 : ${interface.addresses.first.address}');
        print('3-1 : ${interface.addresses.first.type.name}');
        us.usinterface.value = interface.name;
        us.usipType.value = interface.addresses.first.type.name;
        return interface.addresses.first.address;
      } catch (ex) {
        return null;
      }
    }
  }
}
Future<String?> getPublicIP() async {
  final us = Get.put(UserState());
  try {
    final Uri url = Uri.parse('https://api64.ipify.org');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      us.usipAddress.value = '${response.body}';
      return response.body;
    } else {
      print(response.statusCode);
      print(response.body);
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}