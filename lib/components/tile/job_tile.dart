import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/colors.dart';
import '../../../util/font/font.dart';
import '../switch/switch_button.dart';

class JobTile extends StatelessWidget {
  final tName;
  final String subject;
  final bool isOpened;
  final bool isStudent;
  final bool isjobOK;
  final VoidCallback switchOnTap;
  final VoidCallback? onTap;
  const JobTile(
      {Key? key,
      this.tName: '박보검',
      required this.isOpened,
      required this.switchOnTap,
      required this.isStudent,
      required this.subject,
      this.onTap,
      required this.isjobOK})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 0.5,
            color: Colors.grey.withOpacity(0.5),
          ),
          boxShadow: [
            // BoxShadow(
            //   color: Colors.grey.withOpacity(0.5),
            //   spreadRadius: 0,
            //   blurRadius: 5,
            //   offset: Offset(0, 0),
            // ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 6, bottom: 5),
              child: Text(
                '${tName} 학원',
                textAlign: TextAlign.start,
                style: f16w700,
              ),
            ),
            Container(
              child: Text(
                '선생님 모집중',
                textAlign: TextAlign.start,
                style: f16w500greyA,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  subject,
                  textAlign: TextAlign.start,
                  style: isjobOK ? f16w700primary : f16w700greyA,
                ),
                Spacer(),
                Text('공고 보기 >', style: f16w700)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
