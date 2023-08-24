import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../util/colors.dart';
import '../../util/font/font.dart';


class PrivatePolicy extends StatefulWidget {
  static final String id = '/privatePolicy';
  const PrivatePolicy({Key? key}) : super(key: key);

  @override
  State<PrivatePolicy> createState() => _PrivatePolicyPageState();
}

class _PrivatePolicyPageState extends State<PrivatePolicy> {

  late InAppWebViewController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('개인정보취급방침',style: f21w700grey5),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xff6f7072),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: backColor,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse('http://misnetwork.iptime.org:8880/policy')),
        onWebViewCreated: (InAppWebViewController webviewController){
          controller = webviewController;
          initialOptions: InAppWebViewGroupOptions(
            android: AndroidInAppWebViewOptions(
              useHybridComposition: true,
              allowContentAccess: true,
              builtInZoomControls: true,
              thirdPartyCookiesEnabled: true,
            ),
            ios: IOSInAppWebViewOptions(
              allowsInlineMediaPlayback: true,
              allowsBackForwardNavigationGestures: true,
            ),
          );
          onEnterFullscreen: (controller) async {
            await SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeRight,
              DeviceOrientation.landscapeLeft,
            ]);
          };
        },
      ),
    );
  }
}
