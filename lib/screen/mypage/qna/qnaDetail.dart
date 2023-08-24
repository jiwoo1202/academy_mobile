import 'package:academy/provider/user_state.dart';
import 'package:academy/screen/mypage/qna/qnaWrite.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../components/community/community_detail.dart';
import '../../../components/dialog/showAlertDialog.dart';
import '../../../firebase/firebase_community.dart';
import '../../../util/font/font.dart';
import '../../community/story/story_write_screen.dart';

class QnaDetail extends StatefulWidget {
  final String title;
  final String body;
  final String docId;
  final List image;
  final String hasImage;
  final String? admin;
  final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

  const QnaDetail({Key? key, required this.title, required this.body, required this.docId, required this.image, required this.hasImage, this.refreshIndicatorKey, this.admin}) : super(key: key);

  @override
  State<QnaDetail> createState() => _QnaDetailState();
}

class _QnaDetailState extends State<QnaDetail> {
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final us = Get.put(UserState());

    return Scaffold(
        appBar: AppBar(title: Text('내가 쓴 질문',style: f21w700grey5,),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xff6f7072),
            ),
            onPressed: () {
              Get.back();
            },
          ),elevation: 0,
          actions: [
            widget.admin!=''?Container():
            Theme(
              data: Theme.of(context).copyWith(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: PopupMenuButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  offset: const Offset(-20, 40),
                  icon: Container(
                    height: 15,
                    width: 20,
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset(
                      'assets/icon/more_button.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          Center(
                            child: const Text(
                              '수정하기',
                              style: f14w500,
                            ),
                          ),
                        ],
                      ),
                      value: 1,
                      onTap: () {//수정하기
                          Future.delayed(Duration.zero, () {
                            Get.to(
                                    () => QnaWrite(
                                      state: 'edit',
                                      title: widget.title,
                                      body: widget.body,
                                      docId: widget.docId,
                                    )
                            );
                          });
                          widget.refreshIndicatorKey?.currentState?.show();
                      },
                    ),
                    PopupMenuItem(
                        height: 0,
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            Center(
                                child: const Text(
                                  '삭제하기',
                                  style: f14w500,
                                )),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                        value: 2,
                        onTap: () async {
                          await _qnaDelete();
                            Get.back();
                            await showOnlyConfirmDialog(context, '삭제 되었습니다');
                          widget.refreshIndicatorKey?.currentState?.show();
                        }
                        ),
                  ]),
            )
          ],),
      body: CommunityDetail(
        who: us.userList[0].nickName!,
        dateTime: DateTime.now(),
        docId: widget.docId,
        hasImage: widget.hasImage,
        createDate: us.getmyQna[0]['createDate'],
        image: widget.image,
        id: '${us.userList[0].phoneNumber}',
        carouselCon: carouselController,
        title: widget.title,
        body: widget.body,
        commentCount: 0,
        anonymous: false,
        qna: true,
        admin: widget.admin,
        anonymousCount: 0,
        onTap4: () { //안씀
        },
      ),
    );
  }

  //qna 삭제
  Future<void> _qnaDelete() async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      CollectionReference ref = _firestore.collection('qna');
      QuerySnapshot snapshot = await ref.where('docId', isEqualTo: widget.docId).get();
      snapshot.docs[0].reference.delete();
    } catch (e) {
      print(e);
    }
  }
  Future<void> _refresh() async {
    Future.delayed(Duration.zero, () async {
      final us = Get.put(UserState());
      setState(() {});
    });
  }
}
