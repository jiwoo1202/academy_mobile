import 'package:flutter/material.dart';

class NoticeMainScreen extends StatefulWidget {
  const NoticeMainScreen({Key? key}) : super(key: key);

  @override
  State<NoticeMainScreen> createState() => _NoticeMainScreenState();
}

class _NoticeMainScreenState extends State<NoticeMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(child: Text('준비중입니다\n빠른 시일내 돌아올게요 ^^'))),);
  }
}
