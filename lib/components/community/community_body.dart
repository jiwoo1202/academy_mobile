import 'package:academy/util/colors.dart';
import 'package:flutter/material.dart';

class CommunityBody extends StatelessWidget {
  final Widget body;
  final VoidCallback floatingTap;
  final Icon floatingIcon;
  final double paddingSize;
  const CommunityBody({Key? key,
    required this.body,
    required this.floatingTap,
    required this.floatingIcon,
    required this.paddingSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: paddingSize),
        child: body,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: floatingTap,
        backgroundColor: nowColor,
        child: floatingIcon,
      ),
    );
  }
}
