import 'package:academy/firebase/firebase_community.dart';
import 'package:academy/model/user.dart';
import 'package:academy/provider/community_state.dart';
import 'package:academy/util/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/dialog/showAlertDialog.dart';

import '../../provider/user_state.dart';
import '../../util/colors.dart';
import '../../util/font/font.dart';

class BlockPage extends StatefulWidget {
  static final String id = '/Block_check';
  const BlockPage({Key? key}) : super(key: key);

  @override
  State<BlockPage> createState() => _BlockPageState();
}

class _BlockPageState extends State<BlockPage> {
  bool _isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState(){
    Future.delayed(Duration.zero, () async {
      final us = Get.put(UserState());
      await blockGet('${us.userList[0].phoneNumber}');

      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Get.put(CommunityState());
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async {
        await _refresh();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('차단 설정',style: f21w700grey5,),
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
          itemCount: cs.comBlock.length,
            itemBuilder: (_, index){
          return Column(
            children: [
              Container(color: backColor,
                padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
                child: Column(
                  children: [
                    Row(
                     children: [
                       Expanded(
                         flex: 2,
                         child: Container(
                           height: 64,
                           decoration: BoxDecoration(
                             color: textFormColor,
                             borderRadius: BorderRadius.circular(8)
                           ),
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Text('${cs.comBlock[index]['blockedId']}',textAlign: TextAlign.center,),
                             ],
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 10,
                       ),
                       Expanded(
                         flex: 1,
                         child: Container(
                           height: 64,
                           decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(8),
                         ),
                           child: ElevatedButton(
                             child: Center(
                               child: Text(
                                 '차단 해제',
                                 style: f16w700primary,
                                 textAlign: TextAlign.right,
                               ),
                             ),
                             onPressed: () async {
                               showComponentDialog(context, '해당 유저를 차단 해제하시겠습니까?', ()async{
                                 Navigator.pop(context);
                                 _isLoading = true;
                                 await _removeBlock('${cs.comBlock[index]['docId']}');
                                 _refreshIndicatorKey.currentState?.show();
                                 // await _blockGet(rp.phoneNumber,rp);
                                 setState(() {
                                   _isLoading = false;
                                 });
                               },);
                             },style:ElevatedButton.styleFrom(
                             backgroundColor: textFormColor,elevation: 0
                           ) ,
                           ),
                         ),
                       ),
                     ],
                    ),
                    // Container(
                    //   height: 64,
                    //   decoration:  BoxDecoration(
                    //       color: buttonTextColor,
                    //       borderRadius: BorderRadius.circular(8.0),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.grey.withOpacity(0.25),
                    //           offset: Offset(0,1),
                    //         )
                    //       ]
                    //   ),
                    //   child: ListTile(
                    //     title : Text('${cs.comBlock[index]['blockedId']}'),
                    //     trailing: GestureDetector(
                    //       onTap: () async {
                    //         showComponentDialog(context, '해당 유저를 차단 해제하시겠습니까?', ()async{
                    //           Navigator.pop(context);
                    //           _isLoading = true;
                    //           await _removeBlock('${cs.comBlock[index]['docId']}');
                    //           _refreshIndicatorKey.currentState?.show();
                    //           // await _blockGet(rp.phoneNumber,rp);
                    //           setState(() {
                    //             _isLoading = false;
                    //           });
                    //         },);
                    //       },
                    //       child: Padding(
                    //         padding: const EdgeInsets.only(top: 7),
                    //         child: Container(
                    //           height: 56,
                    //           width: 88,
                    //           decoration: BoxDecoration(
                    //             color: Color(0xffd9f0f1),
                    //             borderRadius: BorderRadius.circular(7),
                    //           ),
                    //           child: Center(
                    //             child: Text(
                    //               '차단 해제',
                    //               style: TextStyle(
                    //                   fontFamily: 'NotoSansKr',
                    //                   fontSize: 14,
                    //                   height: 1,
                    //                   color: Colors.blueGrey,
                    //                   fontWeight: FontWeight.w500),
                    //               textAlign: TextAlign.right,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
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
  Future<void> _removeBlock(String docId) async {
    final CollectionReference ref = FirebaseFirestore.instance.collection('block');
   await ref.doc(docId).delete();
  }

  Future<void> _refresh() async {
    Future.delayed(Duration.zero, () async {
      final us = Get.put(UserState());
      await blockGet('${us.userList[0].phoneNumber}');
      setState(() {});
    });
  }


}
