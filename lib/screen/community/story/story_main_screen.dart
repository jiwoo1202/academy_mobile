import 'package:academy/components/font/font.dart';
import 'package:academy/screen/community/story/story_write_screen.dart';
import 'package:academy/util/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/community/community_body.dart';
import '../../../provider/community_state.dart';
import '../../../provider/user_state.dart';
import 'story_detail_screen.dart';

class StoryMainScreen extends StatefulWidget {
  static final String id = '/story_main';

  const StoryMainScreen({Key? key}) : super(key: key);

  @override
  State<StoryMainScreen> createState() => _StoryMainScreenState();
}

class _StoryMainScreenState extends State<StoryMainScreen> {
  List _communityList = [];
  bool _isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await communityStoryGet('01048544580');
      await storyBlockExceptGet();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async {
        await _refresh();
      },
      child: CommunityBody(
        body: _isLoading
            ? LoadingBodyScreen()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '이야기',
                    style: f32w500,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      itemCount: _communityList.length,
                      shrinkWrap: true,
                      itemBuilder: (_, idx) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Get.to(() => StoryDetailScreen(
                              docId: _communityList[idx]['docId'],
                              id1: _communityList[idx]['id'],
                              refreshIndicatorKey:_refreshIndicatorKey,
                                ));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_communityList[idx]['title']}',
                                style: f24w700,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                '${_communityList[idx]['body']}',
                                style: f18w500,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                int.parse(DateTime.now()
                                            .difference(DateTime.parse(
                                              '${_communityList[idx]['createDate']}',
                                            ))
                                            .inMinutes
                                            .toString()) <
                                        60
                                    ? '${int.parse(DateTime.now().difference(DateTime.parse(
                                          '${_communityList[idx]['createDate']}',
                                        )).inMinutes.toString())}분 전'
                                    : int.parse(DateTime.now()
                                                .difference(DateTime.parse(
                                                  '${_communityList[idx]['createDate']}',
                                                ))
                                                .inHours
                                                .toString()) <
                                            24
                                        ? '${int.parse(DateTime.now().difference(DateTime.parse(
                                              '${_communityList[idx]['createDate']}',
                                            )).inHours.toString())}시간 전'
                                        : '${int.parse(DateTime.now().difference(DateTime.parse(
                                              '${_communityList[idx]['createDate']}',
                                            )).inDays.toString())}일 전',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'NotoSansKr'),
                              ),
                              Divider(
                                color: Colors.black,
                              ),
                            ],
                          ),
                        );
                      })
                ],
              ),
        floatingIcon: const Icon(Icons.add),
        floatingTap: () {
          Get.toNamed(StoryWriteScreen.id);
        },
      ),
    );
  }
  Future<void> _refresh() async {
    Future.delayed(Duration.zero, () async {
      await storyBlockExceptGet();
      setState(() {});
    });
  }
  Future<void> communityStoryGet(String id) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('story');
    QuerySnapshot snapshot = await ref.where('id', isEqualTo: id).get();
    final allData = snapshot.docs.map((doc) => doc.data()).toList();
    print('how many : ${allData.length}');
    _communityList = allData;
  }
  //차단한거 제외
  Future<void> storyBlockExceptGet() async {
    final us = Get.put(UserState());
    final cs = Get.put(CommunityState());
    CollectionReference ref2 = FirebaseFirestore.instance.collection('block');
    QuerySnapshot snapshot2 =
    await ref2.where('blockId', isEqualTo: us.userList[0].phoneNumber)
        .where('collectionName', isEqualTo: 'story').where('commentField', isEqualTo: 'true').get();
    final allData = snapshot2.docs.map((doc) => doc.data()).toList();
    print('55555 : ${allData.length}');
    List ls = allData;

    CollectionReference ref = FirebaseFirestore.instance.collection('story');
    QuerySnapshot snapshot = await ref.get();
    final allData2 = snapshot.docs.map((doc) => doc.data()).toList();
    print('how 777 : ${allData2.length}');
    // _commentsList = allData2;
    List ls2 = allData2;
    List ls3 = [];
    int count = 0;
    for(int i=0; i<ls2.length; i++) {
      count = 0;
      for(int j=0; j<ls.length; j++) {
        if(ls2[i]['docId'] == ls[j]['blockDocId']){
          count ++;
        }
      }
      if(count == 0) {
        ls3.add(ls2[i]);
      }
    }
    _communityList = ls3;
    print('_commentsBlockList: ${_communityList.length} ');

  }
}
