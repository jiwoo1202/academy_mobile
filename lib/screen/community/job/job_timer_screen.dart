import 'package:academy/provider/job_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../provider/community_state.dart';
import '../../../util/cupertino_utill.dart';
import '../../../util/font/font.dart';

class JobTimerScreen extends StatefulWidget {
  static final String id = 'job_timer_screen';
  final int indexTime;
  final int indexTime2;
  const JobTimerScreen({Key? key,
    this.indexTime: 0,
    this.indexTime2: 0,
  }) : super(key: key);

  @override
  State<JobTimerScreen> createState() => _JobTimerScreenState();
}

class _JobTimerScreenState extends State<JobTimerScreen> {
  int setValue =0;
  int setValue2 =0;
  var hourList = new List<int>.generate(24, (i) => i);
  var minList = new List<int>.generate(60, (i) => i);

  @override
  void initState() {
    setState(() {
      setValue = widget.indexTime;
      setValue2 = widget.indexTime2;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Get.put(CommunityState());
    final js = Get.put(JobState());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
            '시간 설정',
            style: f21w700,
          ),
          centerTitle: false,
          backgroundColor: Colors.white,
          leading: GestureDetector(
              onTap: () {
                setState(() {Get.back();});
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          elevation: 0,
          actions: [
            GestureDetector(
              onTap: () {
                setState(() {Get.back(result: [setValue, setValue2]);});
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 28),
                child: Center(
                    child: Text(
                      '저장',
                      style: f16w700primary,
                    )),
              ),
            )
          ],
      ),
      body: Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Get.height * 0.352,
              width: Get.width * 0.4,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: setValue),
                itemExtent: 60,
                diameterRatio: 0.9,
                looping: true,
                onSelectedItemChanged: (index) {
                  setState(() {
                    setValue = hourList[index];
                  });
                },
                selectionOverlay: Container(),
                // selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                //   background: Colors.transparent,
                // ),
                children: Utils.modelBuilder<int>(
                  hourList,
                      (index, value) {
                    final isSelected = setValue == index;
                    final color = isSelected
                        ? Colors.black
                        : Colors.black.withOpacity(0.5);
                    final fontSize = isSelected ? 42 : 32;
                    return Center(
                      child: Text(value.toString().padLeft(2,'0'), style: TextStyle(
                          color: color, fontSize: fontSize.toDouble(), fontFamily: 'Pretendard'
                      ),),
                    );
                  },
                ),
              ),
            ),
            Text(':', style: f16w400,),
            SizedBox(
              height: Get.height * 0.352,
              width: Get.width * 0.4,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: setValue2),
                itemExtent: 60,
                diameterRatio: 0.9,
                looping: true,
                onSelectedItemChanged: (index) {
                  setState(() {
                    setValue2 = minList[index];
                  });
                },
                selectionOverlay: Container(),
                // selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                //   background: Colors.transparent,
                // ),
                children: Utils.modelBuilder<int>(
                  minList,
                      (index, value) {
                    final isSelected = setValue2 == index;
                    final color = isSelected
                        ? Colors.black
                        : Colors.black.withOpacity(0.5);
                    final fontSize = isSelected ? 42 : 32;
                    return Center(
                      child: Text(value.toString().padLeft(2,'0'), style: TextStyle(
                          color: color, fontSize: fontSize.toDouble(), fontFamily: 'Pretendard'
                      ),),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
}
