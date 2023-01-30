import 'package:academy/components/font/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../switch/switch_button.dart';

class JobTile extends StatelessWidget {
  final tName;
  final String subject;
  final bool isOpened;
  final bool isStudent;
  final VoidCallback switchOnTap;
  final VoidCallback? onTap;

  const JobTile(
      {Key? key,
        this.tName: '박보검',
        required this.isOpened,
        required this.switchOnTap, required this.isStudent, required this.subject, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.black,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 24,),
                  Text(
                    '${tName} 학원\n 선생님 모집중',
                    textAlign: TextAlign.center,
                    style: f20w500,
                  ),
                  Spacer(),
                  Text(
                    subject,
                    textAlign: TextAlign.center,
                    style: f20w500,
                  ),
                  SizedBox(width: 24,),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '공고 보기',
                style: f20w500 ,selectionColor: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
