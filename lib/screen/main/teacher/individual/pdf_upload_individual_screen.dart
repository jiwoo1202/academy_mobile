import 'package:academy/util/padding.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../provider/answer_state.dart';
import '../../../../provider/user_state.dart';
import '../../../../util/colors.dart';
import '../../../../util/font.dart';
import '../../../../util/font/font.dart';

class PdfUploadIndividualScreen extends StatefulWidget {
  final int idx;
  final String edit;

  const PdfUploadIndividualScreen({
    Key? key,
    required this.idx,
    this.edit: '',
  }) : super(key: key);

  @override
  State<PdfUploadIndividualScreen> createState() =>
      _PdfUploadIndividualScreenState();
}

class _PdfUploadIndividualScreenState extends State<PdfUploadIndividualScreen> {
  PlatformFile? pickedFile;
  PlatformFile? pickedFile2; // 듣기
  UploadTask? uploadTask;
  TextEditingController _testNameController = TextEditingController();
  TextEditingController _testBodyCon = TextEditingController();
  TextEditingController _testEssayCon = TextEditingController();
  String _answer = '0';
  String _fileName = '';
  String _fileName2 = '';
  List _answerList = [];
  bool firstTrue = false;
  bool secondTrue = false;
  bool titleTrue = false;
  bool contentTrue = false;
  List<String> number = ['1', '2', '3', '4', '5'];

  // List<String> _answer = ['', '', '','',''];

  @override
  void initState() {
    super.initState();
    final as = Get.put(AnswerState());

    if (as.essayList.value[widget.idx] != '') {
      firstTrue = true;
      _testEssayCon.text = as.essayList[widget.idx];
    }

    if (as.essayList.value[widget.idx] == '서술형') {
      secondTrue = true;
      _testEssayCon.text = '';
    }

    if (as.individualTitle.value[widget.idx] != '') {
      _testNameController.text = as.individualTitle.value[widget.idx];
    }

    if (as.individualBody.value[widget.idx] != '') {
      _testBodyCon.text = as.individualBody.value[widget.idx];
    }

    if (as.choiceList.value[widget.idx] != '') {
      _answer = as.choiceList.value[widget.idx];
    }

    if (as.individualFile.value[widget.idx] != '') {
      _fileName = as.individualFile.value[widget.idx];
    }

    if (as.individualFile2.value[widget.idx] != '') {
      _fileName2 = as.individualFile2.value[widget.idx];
    }
  }

  @override
  void dispose() {
    super.dispose();
    _testNameController.dispose();
    _testBodyCon.dispose();
    _testEssayCon.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final as = Get.put(AnswerState());
    final us = Get.put(UserState());

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xff6f7072),
            ),
            onPressed: () {
              as.individualTitle.value[widget.idx] = _testNameController.text;
              as.individualBody.value[widget.idx] = _testBodyCon.text;
              if (_testEssayCon.text == '' && firstTrue == true) {
                as.essayList.value[widget.idx] = '서술형';
              } else {
                as.essayList.value[widget.idx] = _testEssayCon.text;
              }
              if (firstTrue) {
                as.choiceList.value[widget.idx] = '';
              }
              Get.back();
            },
          ),
          centerTitle: false,
          actions: [
            GestureDetector(
              onTap: () {

                as.individualTitle.value[widget.idx] = _testNameController.text;
                as.individualBody.value[widget.idx] = _testBodyCon.text;

                if (_testEssayCon.text == '' && firstTrue == true) {
                  as.essayList.value[widget.idx] = '서술형';
                } else {
                  as.essayList.value[widget.idx] = _testEssayCon.text;
                  as.tmpidx.value[widget.idx] = _testEssayCon.text;

                }
                if (firstTrue) {
                  as.choiceList.value[widget.idx] = '';
                }
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.only(right: 28),
                child: const Center(
                    child: Text(
                  '저장',
                  style: f16w700primary,
                )),
              ),
            )
          ],
          title: Text(
            '문제 추가',
            style: f21w700grey5,
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            padding: ph24,
            width: Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '주관식 문제로 변경',
                      style: f18w400,
                    ),
                    Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        firstTrue = !firstTrue;
                        _testEssayCon.text = '';

                        setState(() {});
                      },
                      child: SvgPicture.asset(firstTrue
                          ? 'assets/checkBox.svg'
                          : 'assets/notcheckBox.svg'),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 24),
                //   child: Row(
                //     children: [
                //       // Spacer(),
                //       // GestureDetector(
                //       //   behavior: HitTestBehavior.opaque,
                //       //   onTap: () {
                //       //     print('제목');
                //       //     setState(() {
                //       //       titleTrue = !titleTrue;
                //       //     });
                //       //   },
                //       //   child: SvgPicture.asset(titleTrue
                //       //       ? 'assets/checkBox.svg'
                //       //       : 'assets/notcheckBox.svg'),
                //       // )
                //     ],
                //   ),
                // ),
                Text(
                  '문제 제목',
                  style: f18w400,
                ),
                const SizedBox(
                  height: 20,
                ),

                TextFormField(
                  controller: _testNameController,
                  minLines: 1,
                  maxLines: 10,
                  maxLength: 80,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Color(0xffEBEBEB),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8)),
                    hintText: '내용을 입력해주세요',
                    hintStyle: f16w400grey8,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                Text(
                  '내용',
                  style: f18w400,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _testBodyCon,
                  maxLines: null,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Color(0xffEBEBEB),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8)),
                    hintText: '내용을 입력해주세요',
                    hintStyle: f16w400grey8,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '문제 파일',
                  style: f18w400,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    pickedFile?.name != null || _fileName != ''
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              color: textFormColor,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            width: Get.width * 0.6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: new EdgeInsets.only(right: 13.0),
                                    child: widget.edit == 'true'
                                        ? Text(
                                            '${as.pdfUploadName[widget.idx]}',
                                            style: f16w500,
                                          )
                                        : Text('파일이 첨부돼있습니다', style: f16w500),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    pickedFile = null;
                                    _fileName = '';
                                    as.individualFile.value[widget.idx] = '';
                                    as.pdfUploadName.value[widget.idx] = '';
                                    if (widget.edit == 'true') {
                                      as.editIndividualImage.value[widget.idx] =
                                          'no';
                                    } else {
                                      as.individualFilePath.value[widget.idx] =
                                          '';
                                    }
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              color: textFormColor,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            width: Get.width * 0.6,
                            child: Text(
                              '시험 문제를 추가해 주세요',
                              style: f16w400grey8,
                            ),
                          ),
                    SizedBox(
                      width: 4,
                    ),
                    Container(
                      width: Get.width * 0.25,
                      child: ElevatedButton(
                          onPressed: () async {

                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              allowedExtensions: [
                                // 'pdf',
                                'png',
                                'jpg',
                                'jpeg',
                                // 'svg'
                              ],
                              type: FileType.custom,
                            );

                            if (result == null) return;

                            as.hasFile.value = true;
                            pickedFile = result.files.first;

                            if (widget.edit == 'true') {
                              as.editIndividualImage.value[widget.idx] =
                                  pickedFile!.path;
                              as.pdfUploadName.value[widget.idx] =
                                  pickedFile!.name;
                              as.individualFile.value[widget.idx] = 'yes';
                              as.indEditList.value[widget.idx] = 'edit';

                            } else {
                              as.individualFile.value[widget.idx] = 'yes';
                              as.individualFilePath.value[widget.idx] =
                                  pickedFile!.path;
                              as.pdfUploadName[widget.idx] = pickedFile!.name;
                            }
                            setState(() {});
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 20)),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(textFormColor),
                            splashFactory: NoSplash.splashFactory,
                            elevation: MaterialStateProperty.all<double>(0.0),
                          ),
                          child: Text('찾아보기', style: f16w700primary)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '듣기 파일',
                  style: f18w400,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    pickedFile2?.name != null || _fileName2 != ''
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              color: textFormColor,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            width: Get.width * 0.6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Container(
                                    padding: new EdgeInsets.only(right: 13.0),
                                    child: widget.edit == 'true'
                                        ? Text(
                                            '${as.pdfUploadName2[widget.idx]}')
                                        : Text('파일이 첨부돼있습니다', style: f16w500),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    pickedFile2 = null;
                                    _fileName2 = '';
                                    as.pdfUploadName2.value[widget.idx] = '';
                                    if (widget.edit == 'true') {

                                      as.editIndividualAudio.value[widget.idx] =
                                          'no';
                                    }
                                    as.individualFile2.value[widget.idx] = '';
                                    as.individualFilePath2.value[widget.idx] =
                                        '';
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              color: textFormColor,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            width: Get.width * 0.6,
                            child: Text(
                              '시험 문제를 추가해 주세요',
                              style: f16w400grey8,
                            ),
                          ),
                    SizedBox(
                      width: 4,
                    ),
                    Container(
                      width: Get.width * 0.25,
                      child: ElevatedButton(
                          onPressed: () async {

                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.audio,
                            );

                            if (result == null) return;
                            pickedFile2 = result.files.first;
                            if (widget.edit == 'true') {
                              as.editIndividualAudio.value[widget.idx] =
                                  pickedFile2!.path;
                              as.indEditList2.value[widget.idx] = 'edit';
                              as.pdfUploadName2.value[widget.idx] =
                                  pickedFile2!.name;

                            } else {
                              as.individualFile2.value[widget.idx] = 'yes';
                              as.individualFilePath2.value[widget.idx] =
                                  pickedFile2?.path;
                              as.pdfUploadName2[widget.idx] = pickedFile2?.name;

                            }
                            setState(() {});
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            )),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 20)),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(textFormColor),
                            splashFactory: NoSplash.splashFactory,
                            elevation: MaterialStateProperty.all<double>(0.0),
                          ),
                          child: Text('찾아보기', style: f16w700primary)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '답안',
                      style: f18w400,
                    ),
                    // firstTrue ? Spacer() : Container(),
                    // firstTrue
                    //     ? Text(
                    //         '서술형',
                    //         style: f18w400,
                    //       )
                    //     : Container(),
                    // firstTrue
                    //     ? SizedBox(
                    //         width: 10,
                    //       )
                    //     : Container(),
                    // firstTrue
                    //     ? GestureDetector(
                    //         behavior: HitTestBehavior.opaque,
                    //         onTap: () {
                    //           secondTrue = !secondTrue;
                    //           _testEssayCon.text = '';
                    //           // as.essayList.value[widget.idx] = '$secondTrue';
                    //           // print('주관식');
                    //           setState(() {});
                    //         },
                    //         child: SvgPicture.asset(secondTrue
                    //             ? 'assets/checkBox.svg'
                    //             : 'assets/notcheckBox.svg'),
                    //       )
                    //     : Container()
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                firstTrue
                    ? TextFormField(
                        controller: _testEssayCon,
                        maxLines: null,
                        enabled: !secondTrue,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Color(0xffEBEBEB),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8)),
                          hintText:
                              secondTrue ? '서술형은 입력할 수 없습니다' : '답을 입력해주세요',
                          hintStyle: f16w400grey8,
                        ),
                      )
                    : Container(
                        height: 60,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                              number.length,
                              (i) => Column(
                                    children: [
                                      Row(
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                as.choiceList
                                                        .value[widget.idx] =
                                                    '${i + 1}';
                                                _answer = '${i + 1}';
                                                setState(() {});
                                              },
                                              style: TextButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                side: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                                minimumSize: Size(52, 52),
                                                foregroundColor: Colors.black,
                                                backgroundColor:
                                                    _answer == number[i]
                                                        ? nowColor
                                                        : Colors.white,
                                                padding: EdgeInsets.only(
                                                    right: 12, left: 12),
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                              ),
                                              child: Text('${i + 1}',
                                                  style: _answer == number[i]
                                                      ? f16Whitew700
                                                      : f16w700)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                          // children: number.map((number) {
                          //   return Column(
                          //     children: [
                          //       Row(
                          //         children: [
                          //           TextButton(
                          //               onPressed: () {
                          //                 print('number : ${number}');
                          //                 _answer[int.parse(number)-1] = number;
                          //                 // _answer = number;
                          //                 setState(() {});
                          //               },
                          //               style: TextButton.styleFrom(
                          //                 shape: RoundedRectangleBorder(
                          //                     borderRadius:
                          //                         BorderRadius.circular(20)),
                          //                 side: BorderSide(
                          //                     width: 1, color: Colors.grey),
                          //                 minimumSize: Size(52, 52),
                          //                 foregroundColor: Colors.black,
                          //                 backgroundColor:   Colors.white,
                          //                 padding:
                          //                     EdgeInsets.only(right: 12, left: 12),
                          //                 tapTargetSize:
                          //                     MaterialTapTargetSize.shrinkWrap,
                          //               ),
                          //               child: Text('$number',
                          //                   style: _answer == number  ? f16w700 : f16w700primary)),
                          //           SizedBox(
                          //             width: 10,
                          //           ),
                          //         ],
                          //       ),
                          //     ],
                          //   );
                          // }).toList(),
                        )),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  height: 1,
                  color: cameraBackColor,
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _useBackKey(BuildContext context) async {
    final as = Get.put(AnswerState());

    as.individualTitle.value[widget.idx] = _testNameController.text;
    as.individualBody.value[widget.idx] = _testBodyCon.text;
    if (_testEssayCon.text == '' && firstTrue == true) {
      as.essayList.value[widget.idx] = '서술형';
    } else {
      as.essayList.value[widget.idx] = _testEssayCon.text;
    }

    if (firstTrue) {
      as.choiceList.value[widget.idx] = '';
    }
    Get.back();

    return false;
  }
}
