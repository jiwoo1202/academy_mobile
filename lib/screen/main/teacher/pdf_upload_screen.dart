import 'dart:io';

import 'package:academy/components/font/font.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../firebase/firebase_answer.dart';
import '../../../provider/answer_state.dart';
import '../../../provider/user_state.dart';

class PdfUploadScreen extends StatefulWidget {
  const PdfUploadScreen({Key? key}) : super(key: key);

  @override
  State<PdfUploadScreen> createState() => _PdfUploadScreenState();
}

class _PdfUploadScreenState extends State<PdfUploadScreen> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  TextEditingController _testNameController = TextEditingController();
  TextEditingController _testPwController = TextEditingController();
  TextEditingController _testCountController = TextEditingController();
  final _obscureText = false.obs;
  List _answerList = [];

  @override
  void initState() {
    super.initState();
    for (int i=0; i<20; i++) {
      _answerList.add('1');
    }
    _testCountController.text = '20';
  }

  @override
  void dispose() {
    super.dispose();
    _testNameController.dispose();
    _testPwController.dispose();
    _testCountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final as = Get.put(AnswerState());
    final us = Get.put(UserState());
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text('시험 명', style: f24w500,),
                  const SizedBox(width: 68,),
                  SizedBox(
                    child: TextFormField(
                      controller: _testNameController,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'NotoSansKr',
                          color: Color(0xff292929)),
                      enabled: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueGrey[200]!),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.black),
                          ),
                          prefixIconConstraints:
                          BoxConstraints(minWidth: 23),
                          hintText: '시험 명을 입력해주세요',
                          hintStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'NotoSansKr',
                              color: Colors.blueGrey[200])),
                    ),
                    width: Get.width * 0.75,
                  )
                ],
              ),
              const SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('문제 파일', style: f24w500,),
                  const SizedBox(width: 12,),
                  pickedFile?.name != null
                      ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Color(0xffE9E9E9),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            padding: new EdgeInsets.only(right: 13.0),
                            child: Text(
                              '${pickedFile?.name}',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: 'NotoSansKr'),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            pickedFile = null;
                            setState(() {});
                          },
                          child: Icon(
                            Icons.close,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  )
                      : Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffE9E9E9),
                          width: 1.0,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    width: MediaQuery.of(context).size.width * 0.51,
                    child: Text(
                      '시험 문제를 추가해주세요',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'NotoSansKr',
                          color: Colors.blueGrey[200]),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    child: ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'svg'],
                            type: FileType.custom,
                          );

                          if (result == null) return;

                          pickedFile = result.files.first;
                          setState(() {});
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 12)),
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xffD9F0F1)),
                          splashFactory: NoSplash.splashFactory,
                          elevation: MaterialStateProperty.all<double>(0.0),
                        ),
                        child: Text('찾아보기',
                            style: f16w500)),
                  ),
                ],
              ),
              const SizedBox(height: 12,),
              Row(
                children: [
                  Text('문항수', style: f24w500,),
                  const SizedBox(width: 54,),
                  SizedBox(
                    child: TextFormField(
                      onChanged: (value) {

                      },
                      controller: _testCountController,
                      style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'NotoSansKr',
                          color: const Color(0xff292929)),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      enabled: true,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueGrey[200]!),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.black),
                          ),
                          prefixIconConstraints:
                          BoxConstraints(minWidth: 23),
                          prefixIcon: IconButton(
                            icon: Icon(
                              Icons.remove,
                              size: 20,
                            ),
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            color: Colors.black,
                            onPressed: () {
                              _answerList.removeLast();
                              setState(() {
                                // final x = _testCountController.text.obs;

                                ///_testCountController -
                                _testCountController.text =
                                    (_testCountController.text != '0' ?
                                        int.parse(_testCountController.text) - 1 : 0).toString();
                              });
                            },
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 20,
                            ),
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            color: Colors.black,
                            onPressed: () {
                              _answerList.add('1');
                              setState(() {
                                ///_testCountController +
                                _testCountController.text = (int.parse(_testCountController.text) + 1).toString();
                              });
                            },
                          ),
                          hintText: '20',
                          hintStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'NotoSansKr',
                              color: Colors.blueGrey[200])),
                    ),
                    width: MediaQuery.of(context).size.width * 0.5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.23,
                    child: ElevatedButton(
                        onPressed: () async {
                          try {
                            if(int.tryParse(_testCountController.text) != null) {
                              if (int.parse(_testCountController.text) < _answerList.length) {
                              _answerList.removeRange(int.parse(_testCountController.text), _answerList.length);
                              }
                              if (int.parse(_testCountController.text) > _answerList.length) {
                                int diff= int.parse(_testCountController.text) - _answerList.length;
                                for(int i=0; i< diff; i++){
                                  _answerList.add('1');
                                }
                              }
                              setState(() {});
                            }
                          }catch(e){ print(e);}
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )),
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 12)),
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xffD9F0F1)),
                          splashFactory: NoSplash.splashFactory,
                          elevation: MaterialStateProperty.all<double>(0.0),
                        ),
                        child: Text('확인',
                            style: f16w500)),
                  )
                ],
              ),
              const SizedBox(height: 12,),
              Row(
                children: [
                  Text('비밀번호', style: f24w500,),
                  const SizedBox(width: 54,),
                  SizedBox(
                    child: TextFormField(
                      controller: _testPwController,
                      style: const TextStyle(
                          fontSize: 17,
                          fontFamily: 'NotoSansKr',
                          color: const Color(0xff292929)),
                      textAlign: TextAlign.start,
                      keyboardType: TextInputType.text,
                      obscureText: !_obscureText.isTrue,
                      enabled: true,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blueGrey[200]!),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.black),
                          ),
                          prefixIconConstraints:
                          BoxConstraints(minWidth: 23),
                          suffixIcon: !_obscureText.isTrue
                              ? IconButton(
                            icon: Icon(
                              Icons.visibility_off_outlined,
                              size: 20,
                            ),
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                _obscureText.value = !_obscureText.value;
                              });
                            },
                          )
                              : IconButton(
                            icon: Icon(
                              Icons.visibility_outlined,
                              size: 20,
                            ),
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                _obscureText.value = !_obscureText.value;
                              });
                            },
                          ),
                          hintText: '비밀번호를 입력해 주세요',
                          hintStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'NotoSansKr',
                              color: Colors.blueGrey[200])),
                    ),
                    width: MediaQuery.of(context).size.width * 0.75,
                  ),
                ],
              ),
              const SizedBox(height: 24,),
              Align(alignment: Alignment.topLeft, child: Text('답안', style: f24w500,)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: ListView.builder(
                  itemCount: _answerList.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${index+1} : ', style: f24w500,),
                        const SizedBox(width: 12,),
                        Container(
                          width: Get.width * 0.7,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Color(0xffE9E9E9), style: BorderStyle.solid, width: 0.80),
                          ),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _answerList[index],
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            elevation: 16,
                            hint: Text(
                                '답안을 선택해 주세요',
                                style: f14w500
                            ),
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 10,
                              color: Colors.transparent,
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                _answerList[index] = newValue!;
                              });
                            },
                            items: <String>['1', '2', '3', '4', '5'].map<DropdownMenuItem<String>>((String val) {
                              // ignore: missing_required_param
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(
                                    val,
                                    style: f16w500
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  },),
              ),
              SizedBox(height: 50,)
            ],
          ),
        ),
      ),
      bottomSheet: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () async {
            print('asd: ${pickedFile} , ${pickedFile?.name}');
            as.answer.clear();
            for (int i=0; i< _answerList.length; i++) {
              as.answer.add(_answerList[i]);
            }
            as.group.value = '';
            as.password.value = _testPwController.text;
            as.pdfCategory.value = _testNameController.text;
            as.pdfName.value = '${DateTime.now()}';
            as.pdfUploadName.value = '${pickedFile?.name}';
            as.teacher.value = '12345'; //us.userList[0].name;
            as.path.value = pickedFile!.path!;
            await firebaseAnswerUpload(uploadTask);
            // await _uploadFile('12345', as.docId.value);

            Get.back();
          },
          child: Container(height: Get.height * 0.08,
            child: Column(
              children: [
                Divider(height: 2, color: Colors.grey,),
                const SizedBox(height: 12,),
                Container(
                  child: Center(child: Text('저장하기', style: f20w500,)),),
              ],
            ),
          )),
    );
  }

  Future<void> _uploadFile(String teacher, String docid) async {
    final file = File(pickedFile!.path!);
    print('2: ${docid}');
    final ref = FirebaseStorage.instance
        .ref()
        .child('12345')
        .child('${teacher}')
        .child('${docid}.pdf');
    print('3: ${docid}');
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() => null);
  }
}
