import 'package:academy/components/tile/qna_tile.dart';
import 'package:academy/provider/job_state.dart';
import 'package:academy/provider/user_state.dart';
import 'package:academy/screen/mypage/qna/qnaDetail.dart';
import 'package:academy/screen/mypage/qna/qnaWrite.dart';
import 'package:academy/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../components/community/community_body.dart';
import '../../../components/tile/job_tile.dart';
import '../../../firebase/firebase_qna.dart';
import '../../../util/font/font.dart';
import '../../community/job/job_hunting_detail_screen.dart';

class QnaPage extends StatefulWidget {
  static final String id = '/qna';
  const QnaPage({Key? key}) : super(key: key);

  @override
  State<QnaPage> createState() => _QnaPageState();
}

class _QnaPageState extends State<QnaPage> {
  bool isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  final us = Get.put(UserState());

  @override
  void initState(){
    Future.delayed(Duration.zero,()async{
      // 내가쓴 qna가져오기
      await getmyQna('${us.userList[0].docId}');
     setState(() {
       isLoading = false;
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
      child: Scaffold(
        appBar: AppBar(
          title: Text('QNA',style: f21w700grey5),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xff6f7072),
            ),
            onPressed: () {
              Get.back();
            },
          ),elevation: 0,),
        body: isLoading?LoadingBodyScreen():CommunityBody(
          paddingSize: 24,
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                // 내가 쓴 qna
                ListView.builder(
                  itemCount: us.getmyQna.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        QnaTile(
                          isOpened: true,
                          isStudent: true,
                          body: us.getmyQna[index]['admin'] == ''
                              ? '대기중'
                              : '답변완료',
                          title: '${us.getmyQna[index]['title']}',
                          onTap: ()async{
                            Get.to(() => QnaDetail(
                              title: '${us.getmyQna[index]['title']}',
                              body: '${us.getmyQna[index]['body']}',
                              docId : '${us.getmyQna[index]['docId']}',
                              image : us.getmyQna[index]['images'],
                              hasImage: '${us.getmyQna[index]['hasImage']}',
                              admin: '${us.getmyQna[index]['admin']}',
                              refreshIndicatorKey: _refreshIndicatorKey,
                            ));
                          },
                          switchOnTap: (){},
                        ),
                        SizedBox(height: 30,),
                      ],
                    );
                  },
                ),
                Divider(
                  height: 20,
                ),
              ],
            ),
          ),
          floatingIcon: const Icon(Icons.edit),
          floatingTap: (){
            // Get.toNamed(JobHuntingRequestScreen.id);
            // Get.toNamed(StoryWriteScreen.id);
            Get.to(() => QnaWrite(
              refreshIndicatorKey: _refreshIndicatorKey,
            ));
          },
        )

      ),
    );
  }
  Future<void> _refresh() async {
    Future.delayed(Duration.zero, () async {
      final us = Get.put(UserState());
      await getmyQna('${us.userList[0].docId}');
      setState(() {});
    });
  }
}

