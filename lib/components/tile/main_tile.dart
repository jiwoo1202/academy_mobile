import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../util/font/font.dart';
import '../switch/switch_button.dart';

class MainTile extends StatelessWidget {
  final tName;
  final tCreateDate;
  final String title;
  final String subject;
  final String arrowString;
  final String? storage;
  final bool isOpened;
  final bool isStudent;
  final bool? isSwitched;
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
      this.subject: '',this.arrowString : '', this.isSwitched, this.storage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.translate(
        offset: const Offset(0, -44),
        child: Material(
          elevation: 1,
          color: Color(0xffFAFAFA),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 18),
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 6, bottom: 5),
                  child: Text(
                    '${tName} 선생님',
                    textAlign: TextAlign.start,
                    style: f16w700,
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Text(
                        '${tCreateDate}',
                        textAlign: TextAlign.start,
                        style: f16w500greyA,
                      ),
                      Spacer(),
                      storage=='임시'
                          ?Text('등록전',style:f16w700primary,)
                          :Container(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      !isStudent
                          ? Text(
                              title,
                              textAlign: TextAlign.start,
                              style: f16w700greyA,
                            )
                          : Container(),
                      !isStudent ? Spacer() : Container(),
                      !isStudent
                          ? isSwitched == true
                          ? SwitchButton(
                              value: isOpened,
                              onTap: switchOnTap,
                            )
                          : Container()
                          :Container(),
                      Text(
                        subject,
                        textAlign: TextAlign.center,
                        style: f16w700primary,
                      ),
                      isStudent ? Spacer() : Container(),
                      isStudent
                          ? Row(
                              children: [
                                Text(
                                  arrowString == '' ? '시험 보기' : arrowString,
                                  style: f16w700,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SvgPicture.asset('assets/arrow.svg')
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
