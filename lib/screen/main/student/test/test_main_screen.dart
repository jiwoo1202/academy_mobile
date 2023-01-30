import 'dart:io';
import 'package:academy/firebase/firebase_answer.dart';
import 'package:academy/provider/answer_state.dart';
import 'package:academy/provider/test_state.dart';
import 'package:academy/util/loading.dart';
import 'package:get/get.dart';

import 'package:academy/components/dialog/showAlertDialog.dart';
import 'package:academy/components/font/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../../../../firebase/firebase_test.dart';
import 'test_check_screen.dart';

class TestMainScreen extends StatefulWidget {
  final File file;
  const TestMainScreen({Key? key, required this.file}) : super(key: key);

  @override
  State<TestMainScreen> createState() => _TestMainScreenState();
}

class _TestMainScreenState extends State<TestMainScreen> {
  bool isLoading = true;
  final as = Get.put(AnswerState());
  late PDFViewController controller;
  int pages = 0;
  int indexPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();
  List<String> number = ['1', '2', '3', '4', '5'];
  List<String> _answer = [];
  // doc('test')/ answer에 리스트 만드는 함수
    void addNumber() async{
    for(int i=0;i<as.answerlength.length;i++) {
      _answer.add('');
    }
  }
  @override
  void initState() {
      Future.delayed(Duration.zero,()async{
     addNumber();
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ts = Get.put(TestState());
    final as = Get.put(AnswerState());
    return Scaffold(
      key: _scaffoldKey,
        endDrawer: isLoading?LoadingBodyScreen():Drawer(
         elevation: 16.0,
         child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: as.answerlength.length,
            itemBuilder: (_, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${index + 1}번 문제', style: f18w500),
                  isLoading?LoadingBodyScreen():
                  Container(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: number.map((number) {
                          return TextButton(
                              onPressed: () {
                                _answer[index] = number;
                                setState(() {});
                              },
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                foregroundColor: Colors.transparent,
                                backgroundColor: Colors.transparent,
                                padding: EdgeInsets.only(right: 12, left: 12),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                '$number',
                                style: _answer[index] == number
                                    ? f20Greenw700
                                    : f18w500,
                              ));
                        }).toList(),
                      )),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showComponentDialog(context, '제출하시겠습니까?', () async {
            // answerListAdd('SIg3OP2qqovlBZROIaRr');
            ts.answer.value = _answer;
            Get.back();
            await firebaseTestUpload();
          });
        },
        icon: Icon(Icons.check),
        label: Text(
          '제출하기',
          style: f16Whitew500,
        ),
      ),
      appBar: AppBar(
        title: Text(
          '문제',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        flexibleSpace: GestureDetector(
          onTap: (){
            controller.setPage(0);
            print('hi');
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        // actions: [
        // ],
        // actions: pages >= 2
        //     ? [
        //         IconButton(
        //           icon: Icon(Icons.chevron_left, size: 32),
        //           onPressed: () {
        //             final page = indexPage == 0 ? pages : indexPage - 1;
        //             controller.setPage(page);
        //           },
        //         ),
        //         IconButton(
        //           icon: Icon(Icons.chevron_right, size: 32),
        //           onPressed: () {
        //             final page = indexPage == pages - 1 ? 0 : indexPage + 1;
        //             controller.setPage(page);
        //           },
        //         ),
        //       ]
        //     : null,
      ),
      body: PDFView(
        filePath: widget.file.path,
        // autoSpacing: false,
        // swipeHorizontal: true,
        // pageSnap: false,
        // pageFling: false,
        onRender: (pages) => setState(() => this.pages = pages!),
        onViewCreated: (controller) =>
            setState(() => this.controller = controller),
        onPageChanged: (indexPage, _) =>
            setState(() => this.indexPage = indexPage!),
      ),
    );
  }

}
