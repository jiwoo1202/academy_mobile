import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/community/community_body.dart';
import '../../../components/font/font.dart';
import '../../../components/tile/job_tile.dart';
import '../../../firebase/firebase_job.dart';
import '../../../provider/community_state.dart';
import '../../../provider/job_state.dart';
// import '../../components/community/community_body.dart';
// import '../../components/community/community_detail.dart';
// import '../../components/font/font.dart';
// import '../../components/tile/job_tile.dart';
// import '../../firebase/firebase_job.dart';
// import '../../provider/job_state.dart';
import '../../../provider/user_state.dart';
import 'job_hunting_detail_screen.dart';
import 'job_hunting_request_screen.dart';

class JobHuntingScreen extends StatefulWidget {
  static final String id = '/job_hunting_screen';
  const JobHuntingScreen({Key? key}) : super(key: key);

  @override
  State<JobHuntingScreen> createState() => _JobHuntingScreenState();
}

class _JobHuntingScreenState extends State<JobHuntingScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    //클릭한 타일의 정보 가져오기
    Future.delayed(Duration.zero, () async{
      await jobFullGet('01081383877');//userL
      await notjobFullGet('01081383877'); // notuserL
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final js = Get.put(JobState());
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async {
        await _refresh();
      },
      child: CommunityBody(
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('구인구직',style: f24w500,),
              SizedBox(height: 12,),
              Text('내 구인구직',style: f20w500,),
              ListView.builder(
                itemCount: js.userL.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      JobTile(
                        isOpened: true,
                        isStudent: true,
                        subject: '구직중',
                        tName: '${js.userL[index]['title']}',
                        onTap: ()async{
                          js.jobDocId.value = js.userL[index]['docId'];
                          js.jobbody.value = js.userL[index]['body'];
                          js.jobTitle.value = js.userL[index]['title'];
                          js.jobList.value = js.userL[index]['picture'];
                          js.jobTeacher.value = js.userL[index]['teacher'];
                          Get.to(() => JobHuntingDetailScreen(docId: '${js.jobDocId}'));
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
              ListView.builder(
                itemCount: js.notuserL.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      JobTile(
                        isOpened: true,
                        isStudent: true,
                        subject: '구직중',
                        tName: '${js.notuserL[index]['title']}',
                        onTap: ()async{
                          js.jobDocId.value = js.notuserL[index]['docId'];
                          js.jobbody.value = js.notuserL[index]['body'];
                          js.jobTitle.value = js.notuserL[index]['title'];
                          js.jobList.value = js.notuserL[index]['picture'];
                          js.jobTeacher.value = js.notuserL[index]['teacher'];
                          Get.to(() => JobHuntingDetailScreen(docId: '${js.jobDocId}',refreshIndicatorKey: _refreshIndicatorKey,));
                        },
                        switchOnTap: (){},
                      ),
                      SizedBox(height: 30,),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        floatingIcon: const Icon(Icons.add),
        floatingTap: (){
          Get.toNamed(JobHuntingRequestScreen.id);
        },
      ),
    );
  }
  Future<void> _refresh() async {
    Future.delayed(Duration.zero, () async {
      await jobFullGet('01081383877');//userL
      await notjobFullGet('01081383877');
      setState(() {});
    });
  }
  // //차단한거 제외
  // Future<void> storyBlockExceptGet() async {
  //   final us = Get.put(UserState());
  //   final cs = Get.put(CommunityState());
  //   final js = Get.put(JobState());
  //   CollectionReference ref2 = FirebaseFirestore.instance.collection('block');
  //   QuerySnapshot snapshot2 =
  //   await ref2.where('blockId', isEqualTo: us.userList[0].phoneNumber)
  //       .where('collectionName', isEqualTo: 'story').where('commentField', isEqualTo: 'true').get();
  //   final allData = snapshot2.docs.map((doc) => doc.data()).toList();
  //   print('55555 : ${allData.length}');
  //   List ls = allData;
  //
  //   CollectionReference ref = FirebaseFirestore.instance.collection('jobHunting');
  //   QuerySnapshot snapshot = await ref.get();
  //   final allData2 = snapshot.docs.map((doc) => doc.data()).toList();
  //   print('how 777 : ${allData2.length}');
  //   // _commentsList = allData2;
  //   List ls2 = allData2;
  //   List ls3 = [];
  //   int count = 0;
  //   for(int i=0; i<ls2.length; i++) {
  //     count = 0;
  //     for(int j=0; j<ls.length; j++) {
  //       if(ls2[i]['docId'] == ls[j]['blockDocId']){
  //         count ++;
  //       }
  //     }
  //     if(count == 0) {
  //       ls3.add(ls2[i]);
  //     }
  //   }
  //   js.notuserL.value= ls3;
  //   print('차단한BlockList: ${js.notuserL.value} ');
  //
  // }


}
