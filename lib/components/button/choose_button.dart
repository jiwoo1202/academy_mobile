import 'package:flutter/material.dart';

import '../../util/colors.dart';
import '../../../util/font/font.dart';

class ChooseButton extends StatelessWidget {
  final String title;
  final bool isTrue;
  final VoidCallback onTap;

  const ChooseButton({Key? key, required this.isTrue, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
            child: Text(
          title,
          style: isTrue ? f16w700 : f16w400greyA,
        )),
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: isTrue ? nowColor : blurColor,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
