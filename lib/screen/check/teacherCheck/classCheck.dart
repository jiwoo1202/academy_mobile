import 'package:academy/provider/check_state.dart';
import 'package:academy/provider/user_state.dart';
import 'package:academy/screen/check/teacherCheck/classCheckdetail.dart';
import 'package:academy/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../components/community/community_body.dart';
import '../../../components/tile/qna_tile.dart';
import '../../../firebase/firebase_check.dart';
import '../../../util/font/font.dart';

class ClassCheckPage extends StatefulWidget {
  const ClassCheckPage({Key? key}) : super(key: key);

  @override
  State<ClassCheckPage> createState() => _ClassCheckPageState();
}


class _ClassCheckPageState extends State<ClassCheckPage> {
  final cs = Get.put(CheckState());
  final us = Get.put(UserState());
  bool _isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  @override
  void initState(){
    Future.delayed(Duration.zero,()async{
      await getmyCheckUpload('${us.userList[0].id}');
      setState(() {
        _isLoading=false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading?LoadingBodyScreen():
      RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.white,
        onRefresh: ()async{
              return _refresh();
            },
        child: Scaffold(
          appBar: AppBar(
          title: Text('출석관리',style: f21w700grey5),
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
        body:CommunityBody(
          paddingSize: 24,
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20,),
                //
                ListView.builder(
                  itemCount: cs.myCheckList.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        QnaTile(
                          isOpened: cs.myCheckList[index]['state']=='대기'?false:true,
                          isStudent: true,
                          body: '${cs.myCheckList[index]['date']}',
                          title: '${us.userList[0].id}',
                          onTap: ()async{
                            Get.to(()=>CheckDetail(
                              qrcode: '${cs.myCheckList[index]['qrcode']}',
                              state: "수정",
                            createDate: '${cs.myCheckList[index]['date']}',));
                          },
                          isCheck: false,
                          switchOnTap: ()async{
                            if(cs.myCheckList[index]['state']=='대기'){
                              await updateState(cs.myCheckList[index]['docId'], '완료');
                              _refreshIndicatorKey.currentState?.show();
                              setState(() {

                              });
                            }
                            else if(cs.myCheckList[index]['state']=='완료'){
                              await updateState(cs.myCheckList[index]['docId'], '대기');
                              _refreshIndicatorKey.currentState?.show();
                            }
                            setState(() {
                             });
                            },
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
          floatingIcon: const Icon(Icons.add),
          floatingTap: (){
            print('22');
            Get.to(()=>CheckDetail());
          },
        )
    ),
      );
  }
  Future<void> _refresh() async {
    Future.delayed(Duration.zero, () async {
      await getmyCheckUpload('${us.userList[0].id}');
      setState(() {});
    });
  }
}
