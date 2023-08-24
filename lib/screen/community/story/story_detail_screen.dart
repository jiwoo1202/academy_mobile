import 'package:academy/components/tile/textform_field.dart';
import 'package:academy/provider/community_state.dart';
import 'package:academy/util/loading.dart';
import 'package:academy/util/padding.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../components/community/community_detail.dart';
import '../../../components/dialog/showAlertDialog.dart';
import '../../../firebase/firebase_community.dart';
import '../../../provider/user_state.dart';
import '../../../util/font/font.dart';
import '../../login/login_main_screen.dart';
import 'story_write_screen.dart';

class StoryDetailScreen extends StatefulWidget {
  final String docId;
  final String id1;
  final String name;
  final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;
  static final String id = '/story_detail';

  const StoryDetailScreen(
      {Key? key,
      required this.docId,
      required this.id1,
      this.refreshIndicatorKey, required this.name})
      : super(key: key);

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  CarouselController carouselController = CarouselController();
  TextEditingController commentController = TextEditingController();
  TextEditingController editController = TextEditingController();
  TextEditingController reportController = TextEditingController();
  List<bool> _isAnn = [];
  int _numLines = 0;
  int _count = 0;
  List _communityList = [];

  // List _commentsList = [];
  List _commentsBlockList = [];
  List commentId = ['123', '456'];
  List commentBody = ['fsdafdasfadsf', 'asdgdsagadsg'];
  double? _lineHeight;
  bool _isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final us = Get.put(UserState());
      // await _refresh();
      await communityStoryGet();
      await commentsBlockExceptGet(); //commentsGet();
      _isAnn.clear();
      for (int i = 0; i < _commentsBlockList.length; i++) {
        _isAnn.add(_commentsBlockList[i]['id'] == us.userList[0].phoneNumber);
      }

      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
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
    final us = Get.put(UserState());
    final cs = Get.put(CommunityState());
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '이야기',
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
                                child: us.userList[0].phoneNumber == widget.id1
                                    ? const Text(
                                        '수정하기',
                                        style: f14w500,
                                      )
                                    : const Text(
                                        '신고하기',
                                        style: f14w500,
                                      ),
                              ),
                              us.userList[0].phoneNumber == widget.id1
                                  ? const Divider() : Container(),
                            ],
                          ),
                          value: 1,
                          onTap: () {
                            if(us.userList[0].phoneNumber != widget.id1) {
                              Future.delayed(Duration.zero, () async {
                                showEditDialog(context, '신고 사유를 입력해주세요' ,() async {
                                  Get.back();
                                  Get.back();
                                  showOnlyConfirmDialog(context, '신고했습니다');
                                  await firebaseBlockCreate(
                                    '${us.userList[0].phoneNumber}',//차단자 번호'${us.userList[0].phoneNumber}',
                                    widget.id1,// '$차단한 유저의 핸드폰 번호', // '${cs.storyId.value}',
                                    'story',
                                    'false',
                                    cs.communDocId.value,
                                  );
                                  await _blockUpdate('${us.userList[0].id}',widget.id1);

                                  // Get.back();
                                }, reportController);
                                widget.refreshIndicatorKey?.currentState?.show();
                              });
                            } else { //수정하기
                              Future.delayed(Duration.zero, () {
                                Get.to(() => StoryWriteScreen(state: 'edit', whichScreen: '',));
                              });
                            }
                          },
                        ),
                        PopupMenuItem(
                            height: 0,
                            padding: EdgeInsets.zero,
                            child: us.userList[0].phoneNumber == widget.id1
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
                              if(us.userList[0].phoneNumber == widget.id1) {
                                await _communityDelete();
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
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            await _refresh();
          },
          child: _isLoading
              ? LoadingBodyScreen()
              : SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommunityDetail(
                        who: _communityList[0]['name'],
                        dateTime: DateTime.now(),
                        docId: _communityList[0]['docId'],
                        hasImage: _communityList[0]['hasImage'],
                        createDate: _communityList[0]['createDate'],
                        image: _communityList[0]['images'],
                        id: _communityList[0]['id'],
                        carouselCon: carouselController,
                        title: _communityList[0]['title'],
                        body: _communityList[0]['body'],
                        commentCount: _count,
                        anonymous: false,
                        isMine: _communityList[0]['id'] ==
                            us.userList[0].phoneNumber,
                        //수정
                        anonymousCount: 0,
                        refreshIndicatorKey: widget.refreshIndicatorKey,
                        onTap4: () { //안씀
                          // Future.delayed(Duration.zero, () async {
                          //   showOnlyConfirmDialog(context, '차단했습니다');
                          //   await firebaseBlockCreate(
                          //     '${us.userList[0].phoneNumber}',
                          //     // '$차단한 유저의 핸드폰 번호',
                          //     // '${cs.storyId.value}',
                          //     '',
                          //     'story',
                          //     'true',
                          //     cs.communDocId.value,
                          //   );
                          //   widget.refreshIndicatorKey?.currentState?.show();
                          // });
                          // Get.back();
                        },
                      ),
                      ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          itemCount: _commentsBlockList.length,
                          shrinkWrap: true,
                          itemBuilder: (_, idx) {
                            return us.userList[0].isBanned!.contains(_commentsBlockList[idx]['id']) ? Container() :
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: ph24,
                                      child: Text(
                                        '${_commentsBlockList[idx]['name']}',
                                        style: f14w400grey5,
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
                                              borderRadius:
                                                  BorderRadius.circular(8)),
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
                                                          child: _isAnn[idx] ==
                                                                  true
                                                              ? const Text(
                                                                  '수정하기',
                                                                  style:
                                                                      f14w500,
                                                                )
                                                              : const Text(
                                                                  '신고하기',
                                                                  style:
                                                                      f14w500,
                                                                ),
                                                        ),
                                                        _isAnn[idx] == true
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
                                                            showOnlyConfirmDialog(context, '신고했습니다');
                                                            await firebaseBlockCreate(
                                                              '${us.userList[0].phoneNumber}',
                                                              _commentsBlockList[idx]['id'], 'story', 'true',
                                                              _commentsBlockList[idx]['docId'],
                                                            );

                                                            await _blockUpdate('${us.userList[0].id}', _commentsBlockList[idx]['id']);

                                                            await commentsBlockExceptGet();
                                                          }, reportController);
                                                          _refreshIndicatorKey.currentState?.show();
                                                          commentController.text = '';
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
                                                              await _communityCommentUpdate(_commentsBlockList[idx]['docId'],
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
                                                    child: _isAnn[idx] == true
                                                        ? Column(
                                                            children: [
                                                              Center(
                                                                  child:
                                                                      const Text(
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
                                                      ///comment delete

                                                      Future.delayed(Duration.zero, () async{
                                                        showComponentDialog(context, '삭제 하시겠습니까?', () async {
                                                          _communityCommentDelete(_commentsBlockList[idx]['docId']);
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
                                    '${_commentsBlockList[idx]['body']}',
                                    style: f16w400,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Divider(
                                  height: 1,
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
                    await _communityCommentWrite(commentController.text);
                    showOnlyConfirmDialog(context, '댓글이 입력되었습니다');
                    _refreshIndicatorKey.currentState?.show();
                    commentController.text = '';
                  }
                },
                hintText: '댓글을 입력해주세요',
                surffixIcon: '2'),
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    Future.delayed(Duration.zero, () async {
      final us = Get.put(UserState());
      await commentsBlockExceptGet();
      await communityStoryGet();
      reportController.text = '';
      // _communityList = [];
      _isAnn.clear();
      for (int i = 0; i < _commentsBlockList.length; i++) {
        _isAnn.add(_commentsBlockList[i]['id'] == us.userList[0].phoneNumber);
      }
      setState(() {});
    });
  }

  Future<void> communityStoryGet() async {
    final cs = Get.put(CommunityState());

    CollectionReference ref = FirebaseFirestore.instance.collection('story');
    QuerySnapshot snapshot =
        await ref.where('docId', isEqualTo: widget.docId).get();
    final allData = snapshot.docs.map((doc) => doc.data()).toList();

    _communityList = allData;
    cs.communityList.value = _communityList;
    cs.communDocId.value = widget.docId;
    cs.storyId.value = widget.id1;

  }

  // Future<void> commentsGet() async {
  //   CollectionReference ref = FirebaseFirestore.instance.collection('story').doc(widget.docId).collection('comments');
  //   QuerySnapshot snapshot =
  //   await ref.get();
  //   final allData = snapshot.docs.map((doc) => doc.data()).toList();
  //   print('how 3333 : ${allData.length}');
  //   _commentsList = allData;
  // }

  Future<void> _blockUpdate(String id,String bannedId) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('user');
    QuerySnapshot snapshot = await ref.where('id', isEqualTo: id).get();
    snapshot.docs[0].reference.update({'isBanned': FieldValue.arrayUnion([bannedId])});
  }

  Future<void> commentsBlockExceptGet() async {
    final us = Get.put(UserState());
    final cs = Get.put(CommunityState());
    // CollectionReference ref2 = FirebaseFirestore.instance.collection('block');
    // QuerySnapshot snapshot2 = await ref2
    //     .where('blockId', isEqualTo: us.userList[0].phoneNumber)
    //     .where('collectionName', isEqualTo: 'story')
    //     .where('commentField', isEqualTo: 'true')
    //     .get();
    // final allData = snapshot2.docs.map((doc) => doc.data()).toList();
    // print('55555 : ${allData.length}');
    // List ls = allData;

    CollectionReference ref = FirebaseFirestore.instance
        .collection('story')
        .doc(widget.docId)
        .collection('comments');
    QuerySnapshot snapshot = await ref.get();
    final allData2 = snapshot.docs.map((doc) => doc.data()).toList();

    // _commentsList = allData2;
    List ls2 = allData2;
    List ls3 = [];
    _count = allData2.length;
    for (int i = 0; i < ls2.length; i++) {
      if(us.userList[0].isBanned!.contains(ls2[i]['id'])){
        _count--;
      }
      // count = 0;
      // for (int j = 0; j < ls.length; j++) {
      //   if (ls2[i]['docId'] == ls[j]['blockDocId']) {
      //     count++;
      //   }
      // }
      // if (count == 0) {
      //   ls3.add(ls2[i]);
      // }
    }
    _commentsBlockList = ls2;

  }

  Future<void> _communityCommentWrite(String body) async {
    final us = Get.put(UserState());
    CollectionReference ref = FirebaseFirestore.instance
        .collection('story')
        .doc(widget.docId)
        .collection('comments');
    ref.add({
      'id': '${us.userList[0].phoneNumber}',
      'docId': '',
      'body': body,
      'status': '게시중',
      'type': '${us.userList[0].userType}',
      'name': '${us.userList[0].name}',
      'createDate': '${DateTime.now()}',
    }).then((doc) async {
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('story')
          .doc(widget.docId)
          .collection('comments')
          .doc(doc.id);
      await userDocRef.update({'docId': '${doc.id}'});
    });
  }

  Future<void> _communityCommentUpdate(String docId, String changeValue) async {
    try {
      CollectionReference ref = FirebaseFirestore.instance.collection('story').doc(widget.docId).collection('comments');
      QuerySnapshot snapshot = await ref.where('docId', isEqualTo: docId).get();
      snapshot.docs[0].reference.update({'body' : changeValue});
    } catch (e) {
      print(e);
    }
  }

  Future<void> _communityDelete() async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      CollectionReference ref = _firestore.collection('story');
      QuerySnapshot snapshot = await ref.where('docId', isEqualTo: widget.docId).get();
      snapshot.docs[0].reference.delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _communityCommentDelete(String docId) async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      CollectionReference ref = _firestore.collection('story').doc(widget.docId).collection('comments');
      QuerySnapshot snapshot = await ref.where('docId', isEqualTo: docId).get();
      snapshot.docs[0].reference.delete();
    } catch (e) {
      print(e);
    }
  }
}
