import 'dart:io';
import 'package:academy/provider/test_state.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../../../../firebase/firebase_test.dart';


class PdfCheckScreen extends StatefulWidget {
  final File file;

  const PdfCheckScreen({Key? key, required this.file}) : super(key: key);

  @override
  State<PdfCheckScreen> createState() => _PdfCheckScreenState();
}

class _PdfCheckScreenState extends State<PdfCheckScreen> {
  late PDFViewController controller;
  int pages = 0;
  int indexPage = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();


  // String _n1 = '';
  // String _n2 = '';
  // String _n3 = '';
  // String _n4 = '';
  // String _n5 = '';
  // String _n6 = '';
  // String _n7 = '';
  // String _n8 = '';
  // String _n9 = '';
  // String _n10 = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ts = Get.put(TestState());

    return Scaffold(
      key: _scaffoldKey,
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
