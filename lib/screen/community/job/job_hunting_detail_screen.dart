// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:academy/util/padding.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../components/community/community_detail.dart';
import '../../../components/dialog/showAlertDialog.dart';
import '../../../components/tile/textform_field.dart';
import '../../../firebase/firebase_community.dart';
import '../../../firebase/firebase_job.dart';
import '../../../provider/job_state.dart';
import '../../../provider/user_state.dart';
import '../../../util/font/font.dart';
import '../story/story_write_screen.dart';

class JobHuntingDetailScreen extends StatefulWidget {
  final String docId;

  final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

  const JobHuntingDetailScreen(
      {Key? key, required this.docId, this.refreshIndicatorKey})
      : super(key: key);

  @override
  State<JobHuntingDetailScreen> createState() => _JobHuntingDetailScreenState();
}

class _JobHuntingDetailScreenState extends State<JobHuntingDetailScreen> {
  CarouselController carouselController = CarouselController();
  TextEditingController commentController = TextEditingController();
  TextEditingController editController = TextEditingController();
  TextEditingController reportController = TextEditingController();
  List _commentsBlockList = [];
  List _jobList = [];
  List<bool> _isAnn = [];
  int _numLines = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  double? _lineHeight;

  @override
  void initState() {
    super.initState();

    //comment 가져오기
    Future.delayed(Duration.zero, () async {
      // await comment('${widget.docId}', 'date');
      _commentsBlockList = await jobBlockExceptGet(widget.docId);
      print('q123: ${_commentsBlockList}');
      final us = Get.put(UserState());
      final js = Get.put(JobState());
      for (int i = 0; i < _commentsBlockList.length; i++) {
        _isAnn.add(_commentsBlockList[i]['id'] == '${us.userList[0].phoneNumber}');
      }
      setState(() {});
    });
    // List commentId = ['123','456'];
    // List commentBody = ['fsdafdasfadsf','asdgdsagadsg'];
  }

  @override
  void dispose() {
    commentController.dispose();
    editController.dispose();
    reportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final js = Get.put(JobState());
    final us = Get.put(UserState());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '구인구직',
          style: f21w700,
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        actions: [
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
                    height: 15,
                    width: 20,
                  ),
                ),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            Center(
                              child: us.userList[0].phoneNumber == js.jobTeacher.value
                                  ? const Text(
                                      '수정하기',
                                      style: f14w500,
                                    )
                                  : const Text(
                                      '신고하기',
                                      style: f14w500,
                                    ),
                            ),
                            us.userList[0].phoneNumber == js.jobTeacher.value ? const Divider() : Container(),
                          ],
                        ),
                        value: 1,
                        onTap: () {
                          if(us.userList[0].phoneNumber != js.jobTeacher.value) {
                            Future.delayed(Duration.zero, () {
                              showEditDialog(context, '신고 사유를 입력해주세요' ,() async {
                                Get.back();
                                Get.back();
                                showOnlyConfirmDialog(context, '신고했습니다');
                                await firebaseBlockCreate(
                                    '${us.userList[0].phoneNumber}',//차단자 번호'${us.userList[0].phoneNumber}',
                                    js.jobTeacher.value,// '$차단한 유저의 핸드폰 번호', // '${cs.storyId.value}',
                                    'jobHunting',
                                    'false',
                                    widget.docId,
                                );
                                _commentsBlockList = await jobBlockExceptGet('${widget.docId}');

                                // Get.back();
                              }, reportController);
                              widget.refreshIndicatorKey?.currentState?.show();

                            });

                          } else { //수정하기
                            Future.delayed(Duration.zero, () {
                              Get.to(() => StoryWriteScreen(state: 'edit', whichScreen: 'job',));
                            });
                          }
                        },
                      ),
                      PopupMenuItem(
                          height: 0,
                          padding: EdgeInsets.zero,
                          child: us.userList[0].phoneNumber == js.jobTeacher.value
                              ? Column(
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
                                )
                              : Container(),
                          value: 2,
                          onTap: () async {
                            if(us.userList[0].phoneNumber == js.jobTeacher.value) {
                              await _jobDelete();
                              Get.back();
                              await showOnlyConfirmDialog(context, '삭제 되었습니다');
                              _refreshIndicatorKey.currentState?.show();

                            }
                          }),
                    ]),
          )
        ],
        elevation: 0,
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async {
          await _refresh();
        },
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommunityDetail(
                who: '${js.jobTeacher}',
                dateTime: DateTime.now(),
                hasImage: '${js.jobHasImage}',
                createDate: '${js.selectJobTile[0]['createDate']}',
                image: js.jobList,
                id: '${js.jobTeacher.value}',
                docId: '${js.jobDocId.value}',
                carouselCon: carouselController,
                title: '${js.jobTitle.value}',
                body: '${js.jobbody.value}',
                commentCount: _commentsBlockList.length,
                anonymous: true,
                isMine: us.userList[0].phoneNumber == js.jobTeacher.value,
                //차단, 신고
                onTap2: () {},
                onTap3: () {},
                anonymousCount: 12,
                commentId: 'commentId',
                commentBody: 'commentBody',
                commentCon: commentController,
                refreshIndicatorKey: widget.refreshIndicatorKey,
                onTap4: () {
                  // Future.delayed(Duration.zero, () async {
                  //   showOnlyConfirmDialog(context, '차단했습니다');
                  //   await firebaseBlockCreate(
                  //     '${us.userList[0].phoneNumber}',
                  //     '${js.jobTeacher.value}',
                  //     'story',
                  //     'true',
                  //     '${js.jobDocId.value}',
                  //   );
                  //   widget.refreshIndicatorKey?.currentState?.show();
                  // });
                  Get.back();
                },
              ),
              ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: _commentsBlockList.length,
                  shrinkWrap: true,
                  itemBuilder: (_, idx) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: ph24,
                              child: Text(
                                '익명 ${idx + 1}',
                                //commentId[idx] ${js.commentL.value == [] ? '' : js.commentL[0]['id'] }
                                style: f14w400,
                              ),
                            ),
                            Spacer(),
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
                                      height: 15,
                                      width: 20,
                                    ),
                                  ),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                            padding: EdgeInsets.zero,
                                            child: Column(
                                              children: [
                                                Center(
                                                  child: _isAnn[idx]
                                                      ? const Text(
                                                          '수정하기',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              height: 1,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'NotoSansKr'),
                                                        )
                                                      : const Text(
                                                          '신고하기',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              height: 1,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'NotoSansKr'),
                                                        ),
                                                ),
                                                _isAnn[idx]
                                                    ? const Divider()
                                                    : Container(),
                                              ],
                                            ),
                                            value: 1,
                                            onTap: () {
                                              if (_isAnn[idx] == false) {
                                                ///comment 차단
                                                Future.delayed(Duration.zero, () async {
                                                  showEditDialog(context, '신고 사유를 입력해주세요' ,() async {
                                                    Get.back();
                                                    showOnlyConfirmDialog(context, '신고했습니다');
                                                    await firebaseBlockCreate(
                                                      '${us.userList[0].phoneNumber}',
                                                      '${_commentsBlockList[idx]['id']}',
                                                      'jobHunting',
                                                      'true',
                                                      '${_commentsBlockList[idx]['docId']}',
                                                    );
                                                  }, reportController);

                                                  widget.refreshIndicatorKey?.currentState?.show();
                                                });
                                              } else {
                                                ///comment 수정
                                                Future.delayed(Duration.zero, () async{
                                                  setState(() {
                                                    editController.text = _commentsBlockList[idx]['body'];
                                                  });
                                                  showEditDialog(context, '댓글 수정하기', () async {
                                                    if (editController.text.trim().isEmpty == true) {
                                                      showOnlyConfirmDialog(context, '수정할 댓글을 입력해 주세요');
                                                    } else {
                                                      await _jobCommentUpdate('${_commentsBlockList[idx]['docId']}',
                                                          editController.text);
                                                      Get.back();
                                                      await showOnlyConfirmDialog(context, '댓글이 입력되었습니다');
                                                      _refreshIndicatorKey.currentState?.show();
                                                      commentController.text = '';
                                                      editController.text = '';
                                                    }
                                                  }, editController);
                                                });
                                              }
                                            }),
                                        PopupMenuItem(
                                            height: 0,
                                            padding: EdgeInsets.zero,
                                            child: _isAnn[idx]
                                                ? Column(
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
                                                  )
                                                : Container(),
                                            value: 2,
                                            onTap: () {
                                              Future.delayed(Duration.zero, () async{
                                                showComponentDialog(context, '삭제 하시겠습니까?', () async {
                                                  _jobCommentDelete(_commentsBlockList[idx]['docId']);
                                                  Get.back();
                                                  await showOnlyConfirmDialog(context, '댓글이 삭제 되었습니다');
                                                  _refreshIndicatorKey.currentState?.show();
                                                });
                                              });
                                            }),
                                      ]),
                            ),
                          ],
                        ),
                        Padding(
                          padding: ph24,
                          child: Text(
                            '${_commentsBlockList[idx]['body']}', //commentBody[idx]
                            style: f16w400,
                          ),
                        ),
                      ],
                    );
                  })
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: TextFormFields(
              controller: commentController,
              obscureText: true,
              textOnTap: () async {
                if (commentController.text.trim().isEmpty == true) {
                  showOnlyConfirmDialog(context, '댓글을 입력해 주세요');
                } else {
                  await communityCommentWrite(
                      commentController.text, '${js.jobDocId.value}');
                  showOnlyConfirmDialog(context, '댓글이 입력되었습니다');
                  _refreshIndicatorKey.currentState?.show();
                  commentController.text = '';
                }
              },
              hintText: '댓글을 입력해주세요',
              surffixIcon: '2'),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    Future.delayed(Duration.zero, () async {
      // await comment('${widget.docId}', 'date');
      reportController.text = '';
      _commentsBlockList = await jobBlockExceptGet('${widget.docId}');
      final js = Get.put(JobState());
      for (int i = 0; i < _commentsBlockList.length; i++) {
        _isAnn.add(_commentsBlockList[i]['id'] == js.jobTeacher.value);
      }
      setState(() {});
    });
  }

  Future<void> _jobCommentUpdate(String docId, String changeValue) async {
    try {
      CollectionReference ref = FirebaseFirestore.instance.collection('jobHunting').doc(widget.docId).collection('comments');
      QuerySnapshot snapshot = await ref.where('docId', isEqualTo: docId).get();
      snapshot.docs[0].reference.update({'body' : changeValue});
    } catch (e) {
      print(e);
    }
  }

  Future<void> _jobDelete() async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      CollectionReference ref = _firestore.collection('jobHunting');
      QuerySnapshot snapshot = await ref.where('docId', isEqualTo: widget.docId).get();
      snapshot.docs[0].reference.delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _jobCommentDelete(String docId) async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      CollectionReference ref = _firestore.collection('jobHunting').doc(widget.docId).collection('comments');
      QuerySnapshot snapshot = await ref.where('docId', isEqualTo: docId).get();
      snapshot.docs[0].reference.delete();
    } catch (e) {
      print(e);
    }
  }
}
