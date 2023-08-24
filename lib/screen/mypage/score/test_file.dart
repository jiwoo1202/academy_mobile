

import 'dart:io';

import 'package:academy/screen/main/student/test/test_check_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../util/font/font.dart';

class TestFilePage extends StatefulWidget {
  final File file;
  const TestFilePage({Key? key, required this.file}) : super(key: key);

  @override
  State<TestFilePage> createState() => _TestFilePageState();
}

class _TestFilePageState extends State<TestFilePage> {
  int pages = 0;
  late PDFViewController controller;
  int indexPage = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('시험지',style: f21w700grey5,),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xff6f7072),
          ),
          onPressed: () {
            Get.offAll(()=>TestCheckScreen());
          },
        ),elevation: 0,),
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
