// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../components/community/community_detail.dart';
import '../../../components/dialog/showAlertDialog.dart';
import '../../../components/font/font.dart';
import '../../../firebase/firebase_community.dart';
import '../../../firebase/firebase_job.dart';
import '../../../provider/job_state.dart';
import '../../../provider/user_state.dart';

// import '../../components/community/community_detail.dart';
// import '../../components/dialog/showAlertDialog.dart';
// import '../../components/font/font.dart';
// import '../../firebase/firebase_job.dart';
// import '../../provider/job_state.dart';

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
      await commentOrderBy('${widget.docId}', 'date');

      final js = Get.put(JobState());
      for (int i = 0; i < js.commentL.length; i++) {
        _isAnn.add(js.commentL[i]['id'] == js.userL[0]['teacher']);
      }
      setState(() {});
    });
    // List commentId = ['123','456'];
    // List commentBody = ['fsdafdasfadsf','asdgdsagadsg'];
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final js = Get.put(JobState());
    final us = Get.put(UserState());
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async {
          await _refresh();
        },
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommunityDetail(
                  who: '누구인지',
                  dateTime: DateTime.now(),
                  hasImage: 'true',
                  createDate: '2023-01-19 09:30',
                  image: js.jobList,
                  id: '${js.jobTeacher.value}',
                  docId: '${js.jobDocId.value}',
                  carouselCon: carouselController,
                  title: '${js.jobTitle.value}',
                  body: '${js.jobbody.value}',
                  commentCount: js.commentL.length,
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
                    Future.delayed(Duration.zero, () async {
                      showOnlyConfirmDialog(context, '차단했습니다');
                      await firebaseBlockCreate(
                        '${us.userList[0].phoneNumber}',
                        '${js.jobTeacher.value}',
                        'story',
                        'true',
                        '${js.jobDocId.value}',
                      );
                      widget.refreshIndicatorKey?.currentState?.show();
                    });
                    Get.back();
                  },
                ),
                ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: js.commentL.length,
                    shrinkWrap: true,
                    itemBuilder: (_, idx) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '익명 ${idx + 1}',
                                //commentId[idx] ${js.commentL.value == [] ? '' : js.commentL[0]['id'] }
                                style: f20w500,
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
                                      width: 3,
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        Icons.more_vert,
                                        color: const Color(0xff272424),
                                        size: 20,
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
                                                                color: Colors
                                                                    .black,
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
                                                                color: Colors
                                                                    .black,
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
                                                  ///
                                                  ///
                                                  ///
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
                                                        )),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                              value: 2,
                                              onTap: () {}),
                                        ]),
                              ),
                            ],
                          ),
                          Text(
                            '${js.commentL == [] ? '' : js.commentL[idx]['body']}', //commentBody[idx]
                            style: f20w500,
                          ),
                        ],
                      );
                    })
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
          child: TextField(
            controller: commentController,
            textAlignVertical: TextAlignVertical.center,
            onChanged: (String e) {
              setState(() {
                _numLines = e.split('\n').length;
                if (_numLines <= 1) {
                  _lineHeight = 36;
                } else if (_numLines == 2) {
                  _lineHeight = 56;
                } else if (_numLines >= 3) {
                  _lineHeight = 76;
                }
              });
            },
            maxLines: 3,
            minLines: 1,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: '댓글을 입력해 주세요',
              isDense: true,
              hintStyle: const TextStyle(
                  fontSize: 14,
                  height: 1,
                  color: Colors.grey,
                  fontFamily: 'NotoSansKr'),
              suffixIcon: GestureDetector(
                onTap: () async {
                  if (commentController.text.trim().isEmpty == true) {
                    showOnlyConfirmDialog(context, '댓글을 입력해 주세요');
                  } else {
                    await communityCommentWrite(
                        '${commentController.text}', '${js.jobDocId}');
                    showOnlyConfirmDialog(context, '댓글이 입력되었습니다').then(() {
                      _refreshIndicatorKey.currentState?.show();
                      commentController.text = '';
                    });

                    // AwesomeNotifications().createNotification(
                    //   content: NotificationContent(
                    //       id: 0,
                    //       channelKey: 'basic_channel',
                    //       title: 'Simple Notification',
                    //       body: 'Simple body',
                    //       actionType: ActionType.Default
                    //   ),
                    //   actionButtons: <NotificationActionButton>[
                    //     // NotificationActionButton(key: 'accept', label: 'Accept'),
                    //     // NotificationActionButton(key: 'reject', label: 'Reject'),
                    //     // NotificationActionButton(key: '11', label: '11'),
                    //     NotificationActionButton(
                    //         key: 'REPLY',
                    //         label: 'Reply Message',
                    //         requireInputText: true,
                    //         actionType: ActionType.SilentAction
                    //     ),
                    //   ],
                    // );

                  }
                },
                child: Container(
                    height: _lineHeight,
                    constraints: BoxConstraints(
                      maxHeight: double.infinity,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 11, vertical: 11),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)), //here
                      color: Color(0xff272424),
                    ),
                    child: SvgPicture.asset(
                      'assets/icon/comment_click_icon.svg',
                      height: 14,
                      width: 16,
                    )),
              ),
              suffixIconConstraints: BoxConstraints(minHeight: 8, minWidth: 8),
              filled: true,
              fillColor: Colors.grey.withOpacity(0.2),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(color: Colors.transparent, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(color: Colors.transparent, width: 2),
              ),
              contentPadding: const EdgeInsets.all(8),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    Future.delayed(Duration.zero, () async {
      await commentOrderBy('${widget.docId}', 'date');
      setState(() {});
    });
  }
}
