import 'dart:io';

import 'package:academy/components/dialog/showAlertDialog.dart';
import 'package:academy/util/padding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../components/tile/textform_field.dart';
import '../../../../firebase/firebase_answer.dart';
import '../../../../model/answer.dart';
import '../../../../provider/answer_state.dart';
import '../../../../provider/user_state.dart';
import '../../../../util/colors.dart';
import '../../../../util/font.dart';
import '../../../../util/font/font.dart';
import '../../../../util/loading.dart';
import '../../../login/login_main_screen.dart';
import 'pdf_upload_individual_screen.dart';

class PdfIndMainScreen extends StatefulWidget {
  static final String id = '/pdf_ind_main';
  final String edit;
  final String category;
  final String password;
  final String docId;
  final String? teacher;
  final List? answer;
  final List? body;
  final List? title;
  final List? image;
  final List? file;

  final List? audio;
  final List? pdfUploadName;
  final List? pdfUploadName2;
  final String? countdown;
  final String? state;

  const PdfIndMainScreen(
      {Key? key,
      this.edit: '',
      this.docId: '',
      this.answer,
      this.body,
      this.title,
      this.image,
      this.password: '',
      this.category: '',
      this.file, this.countdown, this.state, this.audio, this.pdfUploadName, this.pdfUploadName2, this.teacher})
      : super(key: key);

  @override
  State<PdfIndMainScreen> createState() => _PdfIndMainScreenState();
}

class _PdfIndMainScreenState extends State<PdfIndMainScreen> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  TextEditingController _testNameController = TextEditingController();
  TextEditingController _testPwController = TextEditingController();
  TextEditingController _testCountController = TextEditingController();
  TextEditingController _testCountController2 = TextEditingController();

  bool _obscureText = false;
  bool _imageLoading = false;
  bool _titleCheck = true; // 제목입력했는지 검사하는 bool
  bool _bodyCheck = true; // 내용입력했는지 검사하는 bool
  List _answerList = [];
  List _imagesList = [];

  @override
  void initState() {
    super.initState();
    final as = Get.put(AnswerState());
    as.essayList.value = [''];
    as.individualTitle.value = [''];
    as.individualFilePath2.value=[''];
    as.individualBody.value = [''];
    as.individualFile.value = [''];
    as.individualFilePath.value = [''];
    as.individualFile2.value = [''];
    as.choiceList.value = [''];
    as.pdfUploadName.value=[''];
    as.pdfUploadName2.value=[''];
    as.tmpidx.value= ['']; // tmpidx 주관식만 답는 용도
    // for (int i = 0; i < 20; i++) {
    //   _answerList.add('1');
    // }
    _answerList.add('1');
    _testCountController.text = '1';
    _testCountController2.text = '100';

    if (widget.edit == 'true') {
      as.individualFile.value = [];
      as.individualFile2.value = [];

      as.individualFilePath.value = [];
      as.individualFilePath2.value = [];
      as.indEditList.value = [];
      as.indEditList2.value = [];

      as.pdfUploadName.value=[]; // pdf 이름
      as.pdfUploadName2.value=[]; // 오디오 이름
      _testPwController.text = widget.password;
      _testNameController.text = widget.category;
      _testCountController.text = '${widget.answer!.length}';
      _testCountController2.text = widget.countdown!;
      _answerList = widget.answer!;
      as.individualTitle.value = widget.title!;
      as.individualBody.value = widget.body!;
      for(int i = 0; i < widget.file!.length; i++){

        widget.file![i] == 'edit' ||  widget.file![i] == 'yes' ? as.individualFile.value.add('yes') : as.individualFile.value.add('');
        widget.file![i] == 'edit' ||  widget.file![i] == 'yes' ? as.individualFilePath.value.add('yes') : as.individualFilePath.value.add('');
        widget.file![i] == 'edit' ||  widget.file![i] == 'yes' ? as.indEditList.value.add('yes') : as.indEditList.value.add('');
      }
      for(int i = 0; i < widget.audio!.length; i++){
        widget.audio![i].contains('no')?as.individualFile2.add(''):as.individualFile2.add('yes'); //
        widget.audio![i].contains('no')?as.individualFilePath2.add(''):as.individualFilePath2.add('yes');//파일업로드
        widget.audio![i].contains('no')?as.indEditList2.add(''):as.indEditList2.add('yes');//파일업로드
      }


      as.editIndividualImage.value = widget.image!;

      as.editIndividualAudio.value = widget.audio!;
      as.pdfUploadName.value= widget.pdfUploadName!; //pdf이름 담기
      as.pdfUploadName2.value = widget.pdfUploadName2!; // 오디오 이름 담기



      as.essayList.value = List.generate(widget.answer!.length, (index) => '');
      as.tmpidx.value = List.generate(widget.answer!.length, (index) => ''); // 수정할 때 tmpidx길이도 증가
      as.choiceList.value = List.generate(widget.answer!.length, (index) => '');
      for (int i = 0; i < widget.answer!.length; i++) {
        if (isNumeric(widget.answer![i]) && widget.answer![i].length == 1) {
          as.choiceList.value[i] = widget.answer![i];
        } else {
          as.essayList.value[i] = widget.answer![i];
        }
      }
      // as.essayList.value = widget.answer!;
      // print('file : ${as.essayList}');
      // for(int i = 0; i < widget.answer!.length; i++){
      //   _answerList.add('1');
      // }
    }
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  void dispose() {
    super.dispose();
    _testNameController.dispose();
    _testPwController.dispose();
    _testCountController.dispose();
    _testCountController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final as = Get.put(AnswerState());
    final us = Get.put(UserState());
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: () {
          return _useBackKey(context);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                showComponentDialog(context, '작성을 취소하시겠습니까?', () {
                  Get.back();
                  Get.back();
                });
              },
            ),
            centerTitle: false,
            title: Text(
              '문제 추가(개별)',
              style: f21w700grey5,
            ),
            actions: [
              // GestureDetector(
              //   onTap: (){
              //     FirebaseFirestore.instance
              //         .collection('answer')
              //         .get()
              //         .then(
              //           (value) => value.docs.forEach(
              //             (element) {
              //           var docRef = FirebaseFirestore.instance
              //               .collection('answer')
              //               .doc(element.id);
              //           docRef.update({'pdfUploadName': '엠아이'});
              //         },
              //       ),
              //     );
              //   },
              //     child: Text('dd',style: f16w500,)),
              widget.state=='임시'||widget.edit!='true'?
              GestureDetector(
                onTap: (){

                  as.answer.clear();
                  for (int i = 0; i < _answerList.length; i++) {
                    if (as.essayList[i] != '') {
                      as.answer.add('');
                    } else {
                      as.answer.add(as.choiceList[i]);
                    }
                  }
                  as.group.value = '';
                  as.password.value = _testPwController.text;
                  as.pdfCategory.value = _testNameController.text;
                  as.pdfName.value = '${DateTime.now()}';
                  as.teacher.value = us.userList[0].id!;



                  showComponentDialog(context,
                      widget.edit == 'true' ? '수정하시겠습니까?' : '임시저장하시겠습니까?',
                          () async {
                        Get.back();
                        if (widget.edit == 'true') {
                          await _update(widget.docId);
                          await _updateTimer('${widget.docId}');
                          showConfirmTapDialog(context, '업로드를 완료했습니다', () {
                            Get.offAll(() => BottomNavigator());
                          });
                        } else {
                          var contain = as.individualFile.where((element) => element != "");
                          await firebaseAnswerUploadIndividualSave(
                              uploadTask, contain.isEmpty);
                          // print(contain.isEmpty);
                        }
                      });
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 28),
                  child: const Center(
                      child: Text(
                        '임시저장',
                        style: f16w700primary,
                      )),
                )

              ):Container(),
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {

                    as.answer.clear();
                    for (int i = 0; i < _answerList.length; i++) {
                      if (as.essayList[i] != '') {
                        as.answer.add('');
                      } else {
                        as.answer.add(as.choiceList[i]);
                      }
                    }

                    as.group.value = '';
                    as.password.value = _testPwController.text;
                    as.pdfCategory.value = _testNameController.text;
                    as.pdfName.value = '${DateTime.now()}';
                    as.teacher.value = us.userList[0].id!;

                    //임시일때 저장버튼
                    if(widget.state=='임시'){
                      _titleCheck = true;
                      _bodyCheck = true;
                      for(int i=0;i<_answerList.length;i++){
                        if(as.individualTitle[i]==''){
                          setState(() {
                            _titleCheck = false;
                          });
                        }
                        if(as.individualBody[i] ==''){
                          setState(() {
                            _bodyCheck=false;
                          });
                        }
                      }
                      if(_titleCheck==true&&_bodyCheck==true){
                      showComponentDialog(context, '업로드하시겠습니까?', () async{
                        Get.back();
                        await updateState('${widget.docId}');
                        showConfirmTapDialog(context, '업로드를 완료했습니다', () {
                          Get.offAll(() => BottomNavigator());
                        });
                      });}
                      else{
                        showOnlyConfirmDialog(context, '문제를 입력해주세요');
                      }
                    }
                    else{
                    showComponentDialog(context,
                        widget.edit == 'true' ? '수정하시겠습니까?' : '업로드하시겠습니까?',
                        () async {
                      Get.back();
                      if (widget.edit == 'true') {
                        await _update(widget.docId);
                        await _updateTimer('${widget.docId}');
                        showConfirmTapDialog(context, '업로드를 완료했습니다', () {
                          Get.offAll(() => BottomNavigator());
                        });
                      } else {
                        var contain =
                            as.individualFile.where((element) => element != "");
                        await firebaseAnswerUploadIndividual(
                            uploadTask, contain.isEmpty);
                        // print(contain.isEmpty);
                      }
                    });};
                    // as.pdfUploadName.value = '${pickedFile?.name}';
                    // as.path.value = pickedFile!.path!;
                    // await _uploadFile('12345', as.docId.value);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(right: 28),
                    child: const Center(
                        child: Text(
                      '등록',
                      style: f16w700primary,
                    )),
                  ))
            ],
          ),
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        '시험명',
                        style: f18w400,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: TextFormFields(
                      controller: _testNameController,
                      hintText: '시험 명을 입력해주세요',
                      surffixIcon: '0',
                      obscureText: true,
                    ),
                    width: Get.width,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        '문항수',
                        style: f18w400,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.edit=='true'
                            ?Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8.0)),
                              color: testCountColor,
                            ),
                            width: Get.width * 0.6,
                            child: TextFormField(
                              controller: _testCountController,
                              style: f16w400,
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: InkWell(
                                  onTap: () {
                                    if(widget.state=='임시'){
                                      _answerList.removeLast();
                                      as.essayList.value.removeLast();
                                      as.tmpidx.value.removeLast(); // tmp마지막 지우기
                                      as.individualTitle.value.removeLast();
                                      as.individualBody.value.removeLast();
                                      as.individualFile.value.removeLast();
                                      as.individualFilePath.value.removeLast();

                                      as.editIndividualImage.value.removeLast(); // 이미지 지우기
                                      as.editIndividualAudio.value.removeLast(); // 오디오 지우기

                                      as.individualFile2.value.removeLast();
                                      as.individualFilePath2.value.removeLast();
                                      as.pdfUploadName2.value.removeLast();
                                      as.pdfUploadName.value.removeLast();

                                      as.choiceList.value.removeLast();
                                      if(widget.edit == 'true'){
                                        as.indEditList.value.removeLast();
                                        as.indEditList2.value.removeLast();
                                      }
                                      setState(() {
                                        // final x = _testCountController.text.obs;

                                        ///_testCountController -
                                        _testCountController.text =
                                            (_testCountController.text != '0'
                                                ? int.parse(
                                                _testCountController
                                                    .text) -
                                                1
                                                : 0)
                                                .toString();
                                      });
                                    }
                                  },
                                  child: Material(
                                    elevation: 0.0,
                                    color: textFormColor,
                                    shadowColor: textFormColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      bottomLeft: Radius.circular(8.0),
                                    ),
                                    child: Container(
                                      width: 40,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 14),
                                      child: SvgPicture.asset(
                                        'assets/icon/minus.svg',
                                        height: 20,
                                        width: 20,
                                        color: teacherColor,
                                      ),
                                    ),
                                  ),
                                ),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    if(widget.state=='임시'){
                                      _answerList.add('1');
                                      as.essayList.value.add('');
                                      as.tmpidx.value.add(''); //tmp 길이 증가
                                      as.individualTitle.value.add('');
                                      as.individualBody.value.add('');
                                      as.individualFile.value.add('');
                                      as.individualFilePath.value.add('');
                                      as.choiceList.value.add('');

                                      as.editIndividualImage.value.add(''); // 이미지 넣기
                                      as.editIndividualAudio.value.add(''); // 오디오 넣기

                                      as.individualFile2.value.add('');
                                      as.individualFilePath2.value.add('');
                                      as.pdfUploadName2.value.add('');
                                      as.pdfUploadName.value.add('');
                                      if(widget.edit == 'true'){
                                        as.indEditList.value.add('');
                                        as.indEditList2.value.add('');
                                      }
                                      setState(() {
                                        ///_testCountController +
                                        _testCountController.text = (int.parse(
                                            _testCountController.text) +
                                            1)
                                            .toString();
                                      });
                                    }
                                  },
                                  child: Material(
                                    elevation: 0.0,
                                    color: textFormColor,
                                    shadowColor: textFormColor,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8.0),
                                      bottomRight: Radius.circular(8.0),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 14),
                                      child: SvgPicture.asset(
                                        'assets/icon/plus.svg',
                                        height: 20,
                                        width: 20,
                                        color: teacherColor,
                                      ),
                                    ),
                                  ),
                                ),
                                hintText: '20',
                                hintStyle: f16w400grey8,
                              ),
                            ))
                        :Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              color: testCountColor,
                            ),
                            width: Get.width * 0.6,
                            child: TextFormField(
                              controller: _testCountController,
                              style: f16w400,
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: InkWell(
                                  onTap: () {
                                    _answerList.removeLast();
                                    as.essayList.value.removeLast();
                                    as.tmpidx.value.removeLast(); // tmp마지막 지우기
                                    as.individualTitle.value.removeLast();
                                    as.individualBody.value.removeLast();
                                    as.individualFile.value.removeLast();
                                    as.individualFilePath.value.removeLast();

                                    as.individualFile2.value.removeLast();
                                    as.individualFilePath2.value.removeLast();
                                    as.pdfUploadName2.value.removeLast();
                                    as.pdfUploadName.value.removeLast();
                                    as.choiceList.value.removeLast();
                                    if(widget.edit == 'true'){
                                      as.indEditList.value.removeLast();
                                      as.indEditList2.value.removeLast();
                                    }
                                    setState(() {
                                      // final x = _testCountController.text.obs;

                                      ///_testCountController -
                                      _testCountController.text =
                                          (_testCountController.text != '0'
                                                  ? int.parse(
                                                          _testCountController
                                                              .text) -
                                                      1
                                                  : 0)
                                              .toString();
                                    });
                                  },
                                  child: Material(
                                    elevation: 0.0,
                                    color: textFormColor,
                                    shadowColor: textFormColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      bottomLeft: Radius.circular(8.0),
                                    ),
                                    child: Container(
                                      width: 40,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 14),
                                      child: SvgPicture.asset(
                                        'assets/icon/minus.svg',
                                        height: 20,
                                        width: 20,
                                        color: teacherColor,
                                      ),
                                    ),
                                  ),
                                ),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    _answerList.add('1');
                                    as.essayList.value.add('');
                                    as.tmpidx.value.add(''); //tmp 길이 증가
                                    as.individualTitle.value.add('');
                                    as.individualBody.value.add('');
                                    as.individualFile.value.add('');
                                    as.individualFilePath.value.add('');
                                    as.choiceList.value.add('');

                                    as.individualFile2.value.add('');
                                    as.individualFilePath2.value.add('');
                                    as.pdfUploadName2.value.add('');
                                    as.pdfUploadName.value.add('');

                                    if(widget.edit == 'true'){
                                      as.indEditList.value.add('');
                                      as.indEditList2.value.add('');
                                    }
                                    setState(() {
                                      ///_testCountController +
                                      _testCountController.text = (int.parse(
                                                  _testCountController.text) +
                                              1)
                                          .toString();
                                    });
                                  },
                                  child: Material(
                                    elevation: 0.0,
                                    color: textFormColor,
                                    shadowColor: textFormColor,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8.0),
                                      bottomRight: Radius.circular(8.0),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 14),
                                      child: SvgPicture.asset(
                                        'assets/icon/plus.svg',
                                        height: 20,
                                        width: 20,
                                        color: teacherColor,
                                      ),
                                    ),
                                  ),
                                ),
                                hintText: '20',
                                hintStyle: f16w400grey8,
                              ),
                            )),
                        SizedBox(
                          width: 4,
                        ),
                        Container(
                          width: Get.width * 0.25,
                          child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  if (int.tryParse(_testCountController.text) !=
                                      null) {
                                    if (int.parse(_testCountController.text) <
                                        _answerList.length) {
                                      _answerList.removeRange(
                                          int.parse(_testCountController.text),
                                          _answerList.length);
                                      as.essayList.value.removeRange(
                                          int.parse(_testCountController.text),
                                          _answerList.length);
                                      as.tmpidx.value.removeRange(int.parse(_testCountController.text), _answerList.length);
                                      as.individualTitle.value.removeRange(
                                          int.parse(_testCountController.text),
                                          _answerList.length);
                                      as.individualBody.value.removeRange(
                                          int.parse(_testCountController.text),
                                          _answerList.length);
                                      as.individualFile.value.removeRange(
                                          int.parse(_testCountController.text),
                                          _answerList.length);
                                      as.individualFilePath.value.removeRange(
                                          int.parse(_testCountController.text),
                                          _answerList.length);
                                      as.choiceList.value.removeRange(
                                          int.parse(_testCountController.text),
                                          _answerList.length);
                                      as.individualFile2.value.removeRange(
                                          int.parse(_testCountController.text),
                                          _answerList.length);
                                      as.individualFilePath2.value.removeRange(
                                          int.parse(_testCountController.text),
                                          _answerList.length);
                                      as.pdfUploadName2.value.removeRange(
                                          int.parse(_testCountController.text),
                                          _answerList.length);
                                      as.pdfUploadName.value.removeRange(
                                          int.parse(_testCountController.text),
                                          _answerList.length);
                                    }

                                    if (int.parse(_testCountController.text) >
                                        _answerList.length) {
                                      int diff =
                                          int.parse(_testCountController.text) -
                                              _answerList.length;
                                      for (int i = 0; i < diff; i++) {
                                        _answerList.add('1');
                                        as.essayList.value.add('');
                                        as.individualTitle.value.add('');
                                        as.tmpidx.value.add('');
                                        as.individualBody.value.add('');

                                        as.individualFile.value.add('');
                                        as.individualFilePath.value.add('');

                                        as.individualFile2.value.add('');
                                        as.individualFilePath2.value.add('');
                                        as.pdfUploadName2.value.add('');
                                        as.pdfUploadName.value.add('');
                                        as.choiceList.value.add('');
                                        if(widget.edit == 'true'){
                                          as.indEditList.value.add('');
                                          as.indEditList2.value.add('');
                                        }
                                      }
                                    }
                                    setState(() {});
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                )),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 20)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        textFormColor),
                                splashFactory: NoSplash.splashFactory,
                                elevation:
                                    MaterialStateProperty.all<double>(0.0),
                              ),
                              child: Text('확인', style: f16w700primary)),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        '시간 설정 (초단위)',
                        style: f18w400,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(8.0)),
                          color: testCountColor,
                        ),
                        width: Get.width * 0.6,
                        child: TextFormField(
                          maxLength: 4,
                          controller: _testCountController2,
                          enabled: true,
                          style: f16w400,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            counterText: '',
                            isDense:  false,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  // final x = _testCountController.text.obs;

                                  ///_testCountController -
                                  _testCountController2.text =
                                      (_testCountController2.text != '0'
                                          ? int.parse(_testCountController2.text) - 1 : 0).toString();
                                });
                              },
                              child: Icon(
                                Icons.exposure_minus_1,
                                color: Colors.black,
                              ),
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  ///_testCountController +
                                  _testCountController2.text = (int.parse(_testCountController2.text) + 1).toString();
                                });
                              },
                              child: Icon(
                                Icons.plus_one,
                                color: Colors.black,
                              ),
                            ),
                            hintText: '100',
                            hintStyle: f16w400grey8,
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        '비밀번호',
                        style: f18w400,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: TextFormFields(
                      controller: _testPwController,
                      hintText: '비밀번호를 입력해 주세요',
                      surffixIcon: '1',
                      obscureText: _obscureText,
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: ph24,
                    child: ListView.builder(
                        itemCount: _answerList.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (c, idx) {
                          return widget.edit=='true'?
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              //임시일때 수정
                              if(widget.state=='임시'){
                                Get.to(() => PdfUploadIndividualScreen(
                                  idx: idx,
                                  edit: widget.edit,
                                ))!
                                    .then((value) {
                                  setState(() {});
                                });
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '문항 ${idx + 1}.',
                                  style: f18w700,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  as.individualFile[idx] != ''
                                      ? '제목(파일첨부)'
                                      : '제목',
                                  style: f18w400,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: Get.width,
                                  padding: ph24v12,
                                  decoration: BoxDecoration(
                                    color: Color(0xffEBEBEB),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Text(
                                    as.individualTitle[idx] == ''
                                        ? '문제를 입력해주세요'
                                        ''
                                        : '${as.individualTitle[idx]}',
                                    style: f16w400,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '답안 :',
                                      style: f18w400,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      as.essayList[idx] != ''
                                          ? '${as.essayList[idx]}'
                                          : as.choiceList[idx] == ''
                                          ? '답을 입력해주세요'
                                          : '${as.choiceList[idx]}',
                                      style: f18w700,
                                    ),
                                    // Obx(() =>Text('${as.essayList[idx]}',style: f18w700,)),
                                    // as.essayList[idx] == 'true' ? Text('주관식',style: f18w700,):  Text(
                                    //   '1',
                                    //   style: f18w700,
                                    // ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Divider(),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ):
                            GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {

                              Get.to(() => PdfUploadIndividualScreen(
                                        idx: idx,
                                        edit: widget.edit,
                                      ))!
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '문항 ${idx + 1}.',
                                  style: f18w700,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  as.individualFile[idx] != ''
                                      ? '제목(파일첨부)'
                                      : '제목',
                                  style: f18w400,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: Get.width,
                                  padding: ph24v12,
                                  decoration: BoxDecoration(
                                    color: Color(0xffEBEBEB),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Text(
                                    as.individualTitle[idx] == ''
                                        ? '문제를 입력해주세요'
                                            ''
                                        : '${as.individualTitle[idx]}',
                                    style: f16w400,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '답안 :',
                                      style: f18w400,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      as.essayList[idx] != ''
                                          ? '${as.essayList[idx]}'
                                          : as.choiceList[idx] == ''
                                              ? '답을 입력해주세요'
                                              : '${as.choiceList[idx]}',
                                      style: f18w700,
                                    ),
                                    // Obx(() =>Text('${as.essayList[idx]}',style: f18w700,)),
                                    // as.essayList[idx] == 'true' ? Text('주관식',style: f18w700,):  Text(
                                    //   '1',
                                    //   style: f18w700,
                                    // ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Divider(),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _uploadFile(String teacher, String docid) async {
  //   final file = File(pickedFile!.path!);
  //   print('2: ${docid}');
  //   final ref = FirebaseStorage.instance
  //       .ref()
  //       .child('12345')
  //       .child('${teacher}')
  //       .child('${docid}.pdf');
  //   print('3: ${docid}');
  //   uploadTask = ref.putFile(file);
  //   final snapshot = await uploadTask!.whenComplete(() => null);
  // }

  Future<void> _update(String docId) async {
    final as = Get.put(AnswerState());
    final us = Get.put(UserState());

    DocumentReference ref =
        FirebaseFirestore.instance.collection('answer').doc(docId);
    ref.update({
      'password': _testPwController.text,
      'pdfCategory': _testNameController.text,
      'answer': as.answer.toList(),
      'individualBody': as.individualBody,
      'individualTitle': as.individualTitle,
      'pdfUploadName' : as.pdfUploadName,
      'pdfUploadName2' : as.pdfUploadName2,
      'temp1':as.tmpidx
    });
    var contain =  as.indEditList.where((element) => element == "edit");
    var contain2 = as.indEditList2.where((element) => element=='edit');

    if(!contain.isEmpty){
      print('what1111 : ${as.individualFile}');
      await ref.update({
        "images": [],
        'individualFile' : as.individualFile,
      });
      setState(() {
        _imageLoading = true;
      });
      _imageLoading == true
          ? showDialog(
        barrierDismissible: false,
        builder: (ctx) {
          return Center(child: LoadingBodyScreen());
        },
        context: context,
      )
          : Container();
      for(int i = 0; i < as.individualFile.length; i++){

        if(as.indEditList[i] == 'edit'){
          var time = DateTime.now();
          final firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child('teacher')
              .child('${us.userList[0].id}')
              .child('$docId')
              .child('${time}');
          final uploadTask = firebaseStorageRef.putFile(
              File(as.editIndividualImage[i]),
              SettableMetadata(contentType: 'image/png'));
          await uploadTask.then((p0) => null);
          await ref.update({
            "images": FieldValue.arrayUnion(['${time}']),
          });
        }else{
          if(as.editIndividualImage[i].contains('no')){
            await ref.update({
              "images": FieldValue.arrayUnion(['no$i']),
            });
          }
          else {
            await ref.update({
              "images": FieldValue.arrayUnion(['${as.editIndividualImage[i]}']),
            });
          }
        }
      }
    }else{
      await ref.update({
        "images": as.editIndividualImage,
        'individualFile' :  as.individualFile,
      });
    }
    if(!contain2.isEmpty){
      await ref.update({
        "audio": [],
      });
      setState(() {
        _imageLoading = true;
      });
      _imageLoading == true
          ? showDialog(
        barrierDismissible: false,
        builder: (ctx) {
          return Center(child: LoadingBodyScreen());
        },
        context: context,
      )
          : Container();
      DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('answer').doc(docId);
      for (int i = 0; i < as.individualFile2.length; i++) {
        if (as.indEditList2[i] == 'edit') {

          var time = DateTime.now();
          final firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child('teacher')
              .child('audio')
              .child('${widget.teacher}')
              .child('${widget.docId}')
              .child('${time}');
          final uploadTask = firebaseStorageRef.putFile(File('${as.editIndividualAudio[i]}'),
              SettableMetadata(contentType: 'audio/mpeg'));
          await uploadTask.then((p0) => null);

          await userDocRef.update({
            "audio": FieldValue.arrayUnion(['${time}'])
          });

        } else {
          if(as.editIndividualAudio[i].contains('no')){
            await userDocRef.update({
              "audio": FieldValue.arrayUnion(['no$i'])
            });
          }
          else {
            await userDocRef.update({
              "audio": FieldValue.arrayUnion(['${as.editIndividualAudio[i]}'])
            });
          }
        }
      }
    }else{

      await ref.update({
        "audio": as.editIndividualAudio,
      });
    }
  }

  Future<void> firebaseAnswerUploadIndividual(
      UploadTask? uploadTask, bool image) async {
    final as = Get.put(AnswerState());
    final us = Get.put(UserState());

    CollectionReference ref = FirebaseFirestore.instance.collection('answer');
    Answer ass = Answer(
        isIndividual: 'true',
        individualBody: as.individualBody,
        individualTitle: as.individualTitle,
        individualFile: as.individualFile,
        images: [],
        student : [],
        nickName:us.userList[0].nickName,
        createDate: '${DateTime.now()}',
        answer: as.answer.toList(),
        answerCount: '',
        docId: '',
        group: '',
        password: '${as.password}',
        pdfCategory: '${as.pdfCategory}',
        pdfName: '${as.pdfName}',
        pdfUploadName: as.pdfUploadName,
        pdfUploadName2: as.pdfUploadName2,
        state: '완료',
        teacher: '${as.teacher}',
        temp1: as.tmpidx,
        temp2: _testCountController2.text,
        audio :[]);
    ref.add(ass.toMap()).then((doc) async {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('answer').doc(doc.id);
      as.docId.value = doc.id;
      // as.individualFile.removeWhere((item) => item == '');
      // as.individualFilePath.removeWhere((item) => item == '');
      await userDocRef.update({'docId': '${doc.id}'});


      // if(as.individualFile2.contains('yes')){

        await _uploadFile2(doc.id, '${us.userList[0].id}');
      // }

      // if (image == false) {
        await _uploadFile(doc.id, '${us.userList[0].id}');
        showConfirmTapDialog(context, '업로드를 완료했습니다', () {
          Get.offAll(() => BottomNavigator());
        });
      // } else {
      //   showConfirmTapDialog(context, '업로드를 완료했습니다', () {
      //     Get.offAll(() => BottomNavigator());
      //   });
      // }
    });
  }

  Future<void> firebaseAnswerUploadIndividualSave(
      UploadTask? uploadTask, bool image) async {
    final as = Get.put(AnswerState());
    final us = Get.put(UserState());
    print('시작');
    print(image);
    CollectionReference ref = FirebaseFirestore.instance.collection('answer');
    Answer ass = Answer(
        isIndividual: 'true',
        individualBody: as.individualBody,
        individualTitle: as.individualTitle,
        individualFile: as.individualFile,
        images: [],
        student : [],
        nickName:us.userList[0].nickName,
        createDate: '${DateTime.now()}',
        answer: as.answer.toList(),
        answerCount: '',
        docId: '',
        group: '',
        password: '${as.password}',
        pdfCategory: '${as.pdfCategory}',
        pdfName: '${as.pdfName}',
        pdfUploadName: as.pdfUploadName,
        pdfUploadName2: as.pdfUploadName2,
        state: '임시',
        teacher: '${as.teacher}',
        temp1: as.tmpidx,
        temp2: _testCountController2.text,
        audio :[]);
    ref.add(ass.toMap()).then((doc) async {
      DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('answer').doc(doc.id);
      as.docId.value = doc.id;
      // as.individualFile.removeWhere((item) => item == '');
      // as.individualFilePath.removeWhere((item) => item == '');
      await userDocRef.update({'docId': '${doc.id}'});
      print('파일의 길이는?? ${as.individualFile2}');
      print('파일의 길이는 어케돼? ${as.individualFilePath2}');
      // if(as.individualFile2.contains('yes')){
        print('오디오가 들어갔을까요?');
        await _uploadFile2(doc.id, '${us.userList[0].id}');
      // }

      // if (image == false) {
        await _uploadFile(doc.id, '${us.userList[0].id}');
        showConfirmTapDialog(context, '업로드를 완료했습니다', () {
          Get.offAll(() => BottomNavigator());
        });
      // } else {
      //   showConfirmTapDialog(context, '업로드를 완료했습니다', () {
      //     Get.offAll(() => BottomNavigator());
      //   });
      // }
    });
  }






  Future _uploadFile(String docId, String phoneNumber) async {
    final as = Get.put(AnswerState());
    setState(() {
      _imageLoading = true;
    });
    _imageLoading == true
        ? showDialog(
            barrierDismissible: false,
            builder: (ctx) {
              return Center(child: LoadingBodyScreen());
            },
            context: context,
          )
        : Container();

    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('answer').doc(docId);
    for (int i = 0; i < as.individualFile.length; i++) {
      if (as.individualFile[i] != '') {
        print('-------exist');
        var time = DateTime.now();
        final firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('teacher')
            .child('$phoneNumber')
            .child('$docId')
            .child('${time}');
        final uploadTask = firebaseStorageRef.putFile(
            File(as.individualFilePath[i]),
            SettableMetadata(contentType: 'image/png'));
        await uploadTask.then((p0) => null);

        await userDocRef.update({
          "images": FieldValue.arrayUnion(['${time}']),
        });
        print('-------exist22');
      } else {
        print('-------nothing : $i');
        await userDocRef.update({
          "images": FieldValue.arrayUnion(['no$i']),
        });
      }
    }
    setState(() {
      _imageLoading = false;
      Navigator.pop(context);
    });
  }

  // 오디오 업로드
  Future _uploadFile2(String docId, String phoneNumber) async {
    final as = Get.put(AnswerState());
    _imageLoading == true
        ? showDialog(
      barrierDismissible: false,
      builder: (ctx) {
        return Center(child: LoadingBodyScreen());
      },
      context: context,
    )
        : Container();

    DocumentReference userDocRef =
    FirebaseFirestore.instance.collection('answer').doc(docId);

    for (int i = 0; i < as.individualFile2.length; i++) {
      if (as.individualFile2[i] != '') {
        print('-------exist');

        var time = DateTime.now();
        final firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child('teacher')
            .child('audio')
            .child('$phoneNumber')
            .child('$docId')
            .child('${time}');
        final uploadTask = firebaseStorageRef.putFile(File('${as.individualFilePath2[i]}'),
            SettableMetadata(contentType: 'audio/mpeg'));
        await uploadTask.then((p0) => null);
        print('성공');
        await userDocRef.update({
          "audio": FieldValue.arrayUnion(['${time}'])
        });
        print('-------exist22');
      } else {
        print('-------nothing : $i');
        await userDocRef.update({
          "audio": FieldValue.arrayUnion(['no$i'])
        });
      }
    }
  }


  Future<void> _updateTimer(String docId) async {
    final as = Get.put(AnswerState());
    DocumentReference ref =
    FirebaseFirestore.instance.collection('answer').doc(docId);
    ref.update({
      'temp2' : _testCountController2.text,
    });
  }


  Future<bool> _useBackKey(BuildContext context) async {
    return await showComponentDialog(context, '작성을 취소하시겠습니까?', () {
      Get.back();
      Get.back();
    });
  }

// 임시저장일 때 저장버튼 클릭시 상태 임시 -> 대기로 변하는 함수
  Future<void> updateState(String docId) async{
    final as = Get.put(AnswerState());
    final us = Get.put(UserState());
    DocumentReference ref = FirebaseFirestore.instance.collection('answer').doc(docId);
    ref.update({
      'password': _testPwController.text,
      'pdfCategory': _testNameController.text,
      'answer': as.answer.toList(),
      'individualBody': as.individualBody,
      'individualTitle': as.individualTitle,
      'pdfUploadName' : as.pdfUploadName,
      'pdfUploadName2' : as.pdfUploadName2,
      'temp1':as.tmpidx,
      'state' : '대기'
    });
    var contain =  as.indEditList.where((element) => element == "edit");
    var contain2 = as.indEditList2.where((element) => element=='edit');
    if(!contain.isEmpty){
      print('what1111 : ${as.individualFile}');
      await ref.update({
        "images": [],
        'individualFile' : as.individualFile,
      });
      setState(() {
        _imageLoading = true;
      });
      _imageLoading == true
          ? showDialog(
        barrierDismissible: false,
        builder: (ctx) {
          return Center(child: LoadingBodyScreen());
        },
        context: context,
      )
          : Container();
      for(int i = 0; i < as.individualFile.length; i++){
        print('$i번함---------');
        if(as.indEditList[i] == 'edit'){
          var time = DateTime.now();
          final firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child('teacher')
              .child('${us.userList[0].id}')
              .child('$docId')
              .child('${time}');
          final uploadTask = firebaseStorageRef.putFile(
              File(as.editIndividualImage[i]),
              SettableMetadata(contentType: 'image/png'));
          await uploadTask.then((p0) => null);
          await ref.update({
            "images": FieldValue.arrayUnion(['${time}']),
          });
        }else{
          if(as.editIndividualImage[i].contains('no')){
            await ref.update({
              "images": FieldValue.arrayUnion(['no$i']),
            });
          }
          else {
            await ref.update({
              "images": FieldValue.arrayUnion(['${as.editIndividualImage[i]}']),
            });
          }
        }
      }
    }else{
      await ref.update({
        "images": as.editIndividualImage,
        'individualFile' :  as.individualFile,
      });
    }
    if(!contain2.isEmpty){
      await ref.update({
        "audio": [],
      });
      setState(() {
        _imageLoading = true;
      });
      _imageLoading == true
          ? showDialog(
        barrierDismissible: false,
        builder: (ctx) {
          return Center(child: LoadingBodyScreen());
        },
        context: context,
      )
          : Container();
      DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('answer').doc(docId);
      for (int i = 0; i < as.individualFile2.length; i++) {
        if (as.indEditList2[i] == 'edit') {
          print('-------exist');
          var time = DateTime.now();
          final firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child('teacher')
              .child('audio')
              .child('${widget.teacher}')
              .child('${widget.docId}')
              .child('${time}');
          final uploadTask = firebaseStorageRef.putFile(File('${as.editIndividualAudio[i]}'),
              SettableMetadata(contentType: 'audio/mpeg'));
          await uploadTask.then((p0) => null);
          print('성공');
          await userDocRef.update({
            "audio": FieldValue.arrayUnion(['${time}'])
          });
          print('-------exist22');
        } else {
          if(as.editIndividualAudio[i].contains('no')){
            await userDocRef.update({
              "audio": FieldValue.arrayUnion(['no$i'])
            });
          }
          else {
            await userDocRef.update({
              "audio": FieldValue.arrayUnion(['${as.editIndividualAudio[i]}'])
            });
          }
        }
      }
    }else{
      print('오디오들어감 ${as.editIndividualAudio}');
      await ref.update({
        "audio": as.editIndividualAudio,
      });
    }
  }

}
