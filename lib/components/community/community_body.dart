import 'package:flutter/material.dart';

class CommunityBody extends StatelessWidget {
  final Widget body;
  final VoidCallback floatingTap;
  final Icon floatingIcon;
  const CommunityBody({Key? key, required this.body, required this.floatingTap, required this.floatingIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: body,
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: floatingTap,
        backgroundColor: Colors.lightGreen,
        child: floatingIcon,
      ),
    );
  }
}
