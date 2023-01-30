import 'package:academy/provider/job_state.dart';
import 'package:academy/screen/community/job/job_hunting_screen.dart';
import 'package:academy/util/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../components/community/community_main.dart';
import '../../../provider/community_state.dart';
import '../story/story_main_screen.dart';

class JobMainScreen extends StatefulWidget {
  const JobMainScreen({Key? key}) : super(key: key);

  @override
  State<JobMainScreen> createState() => _JobMainScreenState();
}

class _JobMainScreenState extends State<JobMainScreen> {
  bool _isLoading = true;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final js = Get.put(JobState());
      final cs = Get.put(CommunityState());
      await communityTitleGet();
      await jobTitleGet();

      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final cs = Get.put(CommunityState());
    final js = Get.put(JobState());
    return _isLoading
        ?LoadingBodyScreen():
      Scaffold(
      body: Column(
        children: [
          CommunityMain(
            title: '공지사항',
            detail1: '공지사항',detail2: '공지사항',ontap: (){}, detail3: '',
          ),
          SizedBox(
            height: 20,
          ),
          CommunityMain(ontap: (){
            Get.to(()=>JobHuntingScreen());
          }, title: '구인구직', detail1: '${js.jobTitle1.value}', detail2: '${js.jobTitle2.value}', detail3: '',),
          SizedBox(
            height: 20,
          ),
          CommunityMain(ontap: (){
            Get.to(()=>StoryMainScreen());
          }, title: '이야기   ', detail1: '${cs.comTitle.value}', detail2: '${cs.comTitle2.value}', detail3: '',)
        ],
      ),

    );
  }
  //커뮤니티 제목 가져오는 함수
  Future<void> communityTitleGet()async{
    final cs = Get.put(CommunityState());
    CollectionReference ref = FirebaseFirestore.instance.collection('story');
    QuerySnapshot snapshot = await ref.get();
    final allData = snapshot.docs.map((doc) => doc.data()).toList();
    List a = allData;
    print('how many : ${allData.length}');
    cs.comTitle.value = a[0]['title'];
    cs.comTitle2.value = a[1]['title'];
  }
  // 구인구직 제목 가져오는 함수
  Future<void> jobTitleGet() async{
  final js = Get.put(JobState());
  CollectionReference ref = FirebaseFirestore.instance.collection('jobHunting');
  QuerySnapshot snapshot = await ref.get();
  final allData = snapshot.docs.map((doc) => doc.data()).toList();
  List a = allData;
  print('how many 2: ${allData.length}');
  js.jobTitle1.value = a[0]['title'];
  js.jobTitle2.value = a[1]['title'];
  }
}
