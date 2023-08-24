import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/colors.dart';
import '../../../util/font/font.dart';
import '../switch/switch_button.dart';

class QnaTile extends StatelessWidget {
  final title;
  final String body;
  final bool isOpened;
  final bool isStudent;
  
  final VoidCallback? onTap;
  final VoidCallback switchOnTap;
  final bool? isCheck;
  const QnaTile(
      {Key? key,
        this.title: '박보검',
        required this.isOpened,
        required this.isStudent,
        required this.body,
        this.onTap,
        this.isCheck, required this.switchOnTap
        })
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
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 6, bottom: 5),
              child: Text(
                '${title}',
                textAlign: TextAlign.start,
                style: f16w700,
              ),
            ),
            Container(
              // child: Text(
              //   '질문내용',
              //   textAlign: TextAlign.start,
              //   style: f16w500greyA,
              // ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  body,
                  textAlign: TextAlign.start,
                  style:  f16w700primary
                ),
                Spacer(),
                isCheck==false?SwitchButton(
                  value: isOpened,
                  onTap: switchOnTap,
                ):Text('답글 보기 >', style: f16w700)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
