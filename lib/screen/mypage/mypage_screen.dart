import 'package:flutter/material.dart';

class MypageScreen extends StatefulWidget {
  static final String id = '/bottom';
  const MypageScreen({Key? key}) : super(key: key);

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('mypage'),),);
  }
}
