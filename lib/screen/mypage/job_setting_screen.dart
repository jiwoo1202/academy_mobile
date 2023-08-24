import 'package:academy/firebase/firebase_community.dart';
import 'package:academy/model/user.dart';
import 'package:academy/provider/community_state.dart';
import 'package:academy/util/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/dialog/showAlertDialog.dart';

import '../../components/switch/switch_button.dart';
import '../../firebase/firebase_job.dart';
import '../../provider/job_state.dart';
import '../../provider/user_state.dart';
import '../../util/colors.dart';
import '../../util/font/font.dart';

class JobSettingScreen extends StatefulWidget {
  static final String id = '/job_setting_screen';
  const JobSettingScreen({Key? key}) : super(key: key);

  @override
  State<JobSettingScreen> createState() => _JobSettingScreenState();
}

class _JobSettingScreenState extends State<JobSettingScreen> {
  bool _isLoading = true;
  List<bool> _alarm = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState(){
    Future.delayed(Duration.zero, () async {
      final us = Get.put(UserState());
      final js = Get.put(JobState());
      await jobFullGet('${us.userList[0].phoneNumber}').then((value) {
        _alarm.clear();
        for(int i=0; i< js.userL.length; i++) {
          _alarm.add(js.userL[i]['jobIs'] == 'true' ? true : false);
        }
      });

      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
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
      child: Scaffold(
          appBar: AppBar(
            title: Text('구인구직 설정',style: f21w700grey5,),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xff6f7072),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            backgroundColor: backColor,
            elevation: 0,
          ),
          body: _isLoading?LoadingBodyScreen():
          ListView.builder(
              itemCount: js.userL.length,
              itemBuilder: (_, index){
                return Column(
                  children: [
                    Container(color: backColor,
                      padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width*0.7,
                                height: 64,
                                decoration: BoxDecoration(
                                    color: textFormColor,
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${js.userL[index]['title']}', style: f18w400,textAlign: TextAlign.center,),
                                    const SizedBox(height: 4,),
                                    Flexible(child: Text('${js.userL[index]['body']}', style: f14w400 ,textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SwitchButton(
                                onTap: (){
                                  showComponentDialog(context, '구인구직 설정을 변경하시겠습니까?', ()async{
                                    Get.back();
                                    _isLoading = true;
                                    _refreshIndicatorKey.currentState?.show();
                                    // await _blockGet(rp.phoneNumber,rp);
                                    _alarm[index] = !_alarm[index];
                                    await _changeValue('${js.userL[index]['docId']}', '${_alarm[index]}');
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },);
                                },
                                value: _alarm[index],
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
          )),
    );
  }

  //차단 해제
  Future<void> _changeValue(String docId, String values) async {
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('jobHunting').doc(docId);
    await userDocRef.update({'jobIs': values});
  }

  Future<void> _refresh() async {
    Future.delayed(Duration.zero, () async {
      final us = Get.put(UserState());
      final js = Get.put(JobState());
      await jobFullGet('${us.userList[0].phoneNumber}').then((value) {
        _alarm.clear();
        for(int i=0; i< js.userL.length; i++) {
          _alarm.add(js.userL[i]['jobIs'] == 'true' ? true : false);
        }
      });

      setState(() {});
    });
  }


}
