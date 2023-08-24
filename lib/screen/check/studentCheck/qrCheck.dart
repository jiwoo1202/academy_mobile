import 'package:academy/components/dialog/showAlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../util/font/font.dart';

class QrCheck extends StatefulWidget {
  const QrCheck({Key? key}) : super(key: key);

  @override
  State<QrCheck> createState() => _QrCheckState();
}

class _QrCheckState extends State<QrCheck> {
  final GlobalKey _globalKey = GlobalKey();
  QRViewController? controller;
  Barcode? result;

  void qr(QRViewController controller){
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      setState(() {
       result=event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('qr출석',style: f21w700grey5,),
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
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.width,
                height: MediaQuery.of(context).size.height*0.7,
                child: QRView(
                  key: _globalKey,
                  onQRViewCreated: qr,
                ),
              ),
              // result!=null?Text('${result!.code}'):Text('코드')
              result !=null?showOnlyConfirmDialog(context, 'dd'):Text('코드')
            ],
          )
        ),
      ),
    );
  }
}
