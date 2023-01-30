import 'package:academy/firebase/firebase_community.dart';
import 'package:academy/provider/community_state.dart';
import 'package:academy/util/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../components/dialog/showAlertDialog.dart';

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
      await blockGet('01081383877');
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
        body: _isLoading?LoadingBodyScreen():
        ListView.builder(
          itemCount: cs.comBlock.length,
            itemBuilder: (_, index){
          return Row(
            children: [
              Text('${cs.comBlock[index]['blockedId']}'),
              GestureDetector(
                onTap: () async {
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
                },
                child: Container(
                  height: 30,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Color(0xffd9f0f1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Center(
                    child: Text(
                      '차단 해제',
                      style: TextStyle(
                          fontFamily: 'NotoSansKr',
                          fontSize: 14,
                          height: 1,
                          color: Colors.blueGrey
                          ,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.right,
                    ),
                  ),
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
      await blockGet('01081383877');
      setState(() {});
    });
  }


}
