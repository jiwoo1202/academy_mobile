import 'package:academy/components/font/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../switch/switch_button.dart';

class MainTile extends StatelessWidget {
  final tName;
  final tCreateDate;
  final String title;
  final String subject;
  final bool isOpened;
  final bool isStudent;
  final VoidCallback switchOnTap;
  final VoidCallback? onTap;

  const MainTile(
      {Key? key,
      this.tName: '박보검',
      this.tCreateDate: '2023-01-16 12:30',
      required this.isOpened,
      required this.switchOnTap,
      required this.isStudent,
      required this.title,
      this.onTap,
      this.subject: ''})
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${tName} 선생님\n ${tCreateDate}',
                    textAlign: TextAlign.center,
                    style: f20w500,
                  ),
                  Spacer(),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: f20w500,
                  ),
                  !isStudent
                      ? SizedBox(
                          width: 20,
                        )
                      : Container(),
                  !isStudent
                      ? SwitchButton(
                          value: isOpened,
                          onTap: switchOnTap,
                        )
                      : Container(),
                  Text(
                    subject,
                    textAlign: TextAlign.center,
                    style: f20w500,
                  ),
                ],
              ),
            ),
            isStudent
                ? Divider(
                    height: 1,
                    color: Colors.black,
                  )
                : Container(),
            isStudent
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '시험 보기',
                      style: f20w500,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
