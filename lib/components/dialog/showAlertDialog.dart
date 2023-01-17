import 'package:academy/components/font/font.dart';
import 'package:flutter/material.dart';

showOnlyConfirmDialog(BuildContext context, String title) {
  // show the dialog
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding:
          const EdgeInsets.only(top: 45, bottom: 37, left: 16, right: 16),
          actionsPadding: const EdgeInsets.only(bottom: 21),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text('${title}',
                textAlign: TextAlign.center,
                style: f20w500),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor:
                      MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: Text("확인", style: f20w500),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            )
          ],
        );
      });
}

showOnlyLoginCheckDialog(
    BuildContext context, String title, VoidCallback onTap) {
  // show the dialog
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future(() => false);
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Builder(
              builder: (context) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${title}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'NotoSansKr',
                              color: Colors.black)),
                    ],
                  ),
                );
              },
            ),
            actions: [
              Divider(
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: onTap,
                behavior: HitTestBehavior.opaque,
                child: Center(
                  child: Container(
                    child: Text('확인',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'NotoSansKr',
                            color: Colors.black)),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        );
      });
}

showConfirmTapDialog(BuildContext context, String title, VoidCallback onTap) {
  // show the dialog
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future(() => false);
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            contentPadding: const EdgeInsets.only(top: 45, bottom: 37),
            actionsPadding: const EdgeInsets.only(bottom: 21),
            content: Builder(
              builder: (context) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${title}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'NotoSansKr',
                              color: Colors.black,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                );
              },
            ),
            actions: [
              Center(
                child: SizedBox(
                  width: 151,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff558E99),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '확인',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'NotoSansKr',
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

// showDoubleComponentDialog(BuildContext context,String alertTitle ,String title, String firstComponent, String secondComponent,
//     VoidCallback firstTap, VoidCallback secondTap) {
//   // show the dialog
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(5),
//           ),
//           contentPadding: const EdgeInsets.only(top: 45, bottom: 37, left: 16, right: 16),
//           actionsPadding: const EdgeInsets.only(bottom: 21, left: 20, right: 20),
//           title: alertTitle == '' ? null : Center(child: Text(alertTitle,style: f14w500,)),
//           content: Text('${title}',
//               textAlign: TextAlign.center,
//               style:
//                   TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'NotoSansKr', color: Colors.black)),
//           actions: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.33,
//                   height: 46,
//                   child: ElevatedButton(
//                     onPressed: firstTap,
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5.0), side: BorderSide(color: Color(0xffE9E9E9)))),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           '${firstComponent}',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontFamily: 'NotoSansKr',
//                             color: Colors.black,
//                             fontWeight: FontWeight.w400,
//                             fontSize: 14,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 12,
//                 ),
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.33,
//                   height: 46,
//                   child: ElevatedButton(
//                     onPressed: secondTap,
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xff558E99),
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           '${secondComponent}',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontFamily: 'NotoSansKr',
//                             color: Colors.white,
//                             fontWeight: FontWeight.w400,
//                             fontSize: 14,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         );
//         // return AlertDialog(
//         //   shape: RoundedRectangleBorder(
//         //     borderRadius: BorderRadius.circular(10),
//         //   ),
//         //   content: Builder(
//         //     builder: (context) {
//         //       return Container(
//         //         width: MediaQuery.of(context).size.width * 0.9,
//         //         child: Column(
//         //           mainAxisSize: MainAxisSize.min,
//         //           children: [
//         //             Text('${title}',
//         //                 textAlign: TextAlign.center,
//         //                 style: TextStyle(fontSize: 15, fontFamily: 'NotoSansKr', color: Colors.black)),
//         //           ],
//         //         ),
//         //       );
//         //     },
//         //   ),
//         //   actions: [
//         //     Divider(
//         //       color: Colors.grey,
//         //     ),
//         //     Row(
//         //       mainAxisAlignment: MainAxisAlignment.spaceAround,
//         //       children: [
//         //         TextButton(
//         //           child: Text("${firstComponent}",
//         //               style: TextStyle(fontSize: 16, fontFamily: 'NotoSansKr', color: Colors.black)),
//         //           onPressed: firstTap,
//         //         ),
//         //         TextButton(
//         //           child: Text("${secondComponent}",
//         //               style: TextStyle(fontSize: 16, fontFamily: 'NotoSansKr', color: Colors.black)),
//         //           onPressed: secondTap,
//         //         ),
//         //       ],
//         //     ),
//         //   ],
//         // );
//       });
// }

showPasswordDialog(
    BuildContext context, String title, VoidCallback confirmTap) {
  // show the dialog
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Builder(
            builder: (context) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${title}',
                        textAlign: TextAlign.center, style: f20w500),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: '비밀번호를 입력해주세요',
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white70,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.4)),
                        ),
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      minLines: 1,
                    )
                  ],
                ),
              );
            },
          ),
          actions: [
            Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: Text("취소", style: f20w500),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor:
                      MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: Text("확인", style: f20w500),
                    onPressed: confirmTap,
                  ),
                ),
              ],
            ),
          ],
        );
      });
}

showTwoComponentDialog(BuildContext context, String title,
    VoidCallback cancelTap, VoidCallback confirmTap) {
  // show the dialog
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Builder(
            builder: (context) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${title}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'NotoSansKr',
                            color: Colors.black)),
                  ],
                ),
              );
            },
          ),
          actions: [
            Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text("나중에 하기",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'NotoSansKr',
                          color: Colors.black)),
                  onPressed: cancelTap,
                ),
                TextButton(
                  child: Text("확인",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'NotoSansKr',
                          color: Colors.black)),
                  onPressed: confirmTap,
                ),
              ],
            ),
          ],
        );
      });
}

showComponentDialog(
    BuildContext context, String title, VoidCallback confirmTap) {
  // show the dialog
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding:
              const EdgeInsets.only(top: 45, bottom: 37, left: 16, right: 16),
          actionsPadding: const EdgeInsets.only(bottom: 21),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text('${title}',
                textAlign: TextAlign.center,
                style: f20w500),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor:
                      MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: Text("취소", style: f20w500),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: TextButton(
                    style: ButtonStyle(
                      overlayColor:
                      MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: Text("확인", style: f20w500),
                    onPressed:confirmTap,
                  ),
                ),
              ],
            )
          ],
        );
      });
}

showTextComponentDialog(BuildContext context, TextEditingController controller,
    VoidCallback confirmTap) {
  // show the dialog
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Builder(
            builder: (context) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: '수정할 내용을 입력해 주세요.',
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white70,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.4)),
                        ),
                      ),
                      controller: controller,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      minLines: 1,
                    )
                  ],
                ),
              );
            },
          ),
          actions: [
            Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text("취소",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'NotoSansKr',
                          color: Colors.black)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("확인",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'NotoSansKr',
                          color: Colors.black)),
                  onPressed: confirmTap,
                ),
              ],
            ),
          ],
        );
      });
}

showTextFieldDialog(BuildContext context, TextEditingController controller,
    String title, VoidCallback confirmTap) {
  // show the dialog
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Builder(
            builder: (context) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('${title}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'NotoSansKr',
                            color: Colors.black)),
                    SizedBox(
                      height: 8,
                    ),
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: '상세사유를 입력해 주세요.',
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white70,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide:
                              BorderSide(color: Colors.grey.withOpacity(0.4)),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                    )
                  ],
                ),
              );
            },
          ),
          actions: [
            Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text("취소",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'NotoSansKr',
                          color: Colors.black)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("확인",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'NotoSansKr',
                          color: Colors.black)),
                  onPressed: confirmTap,
                ),
              ],
            ),
          ],
        );
      });
}

showOnlyConfirmDialogChanged(BuildContext context, String title) {
  // show the dialog
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          actionsPadding: const EdgeInsets.only(bottom: 21),
          content: Builder(
            builder: (context) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'NotoSansKr',
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
          actions: [
            Center(
              child: SizedBox(
                width: 151,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff558E99),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '확인',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'NotoSansKr',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      });
}
