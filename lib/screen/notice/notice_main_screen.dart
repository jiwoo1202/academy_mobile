import 'package:flutter/material.dart';

class NoticeMainScreen extends StatefulWidget {
  const NoticeMainScreen({Key? key}) : super(key: key);

  @override
  State<NoticeMainScreen> createState() => _NoticeMainScreenState();
}

class _NoticeMainScreenState extends State<NoticeMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('Hello world'),);
  }
}
