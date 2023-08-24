import 'dart:io';

import 'package:academy/components/tile/textform_field.dart';
import 'package:academy/util/colors.dart';
import 'package:academy/util/padding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

import '../../../components/button/choose_button.dart';
import '../../../components/dialog/showAlertDialog.dart';
import '../../../provider/community_state.dart';
import '../../../provider/job_state.dart';
import '../../../provider/user_state.dart';
import '../../../util/cupertino_utill.dart';
import '../../../util/font/font.dart';
import '../../../util/loading.dart';
import '../job/job_timer_screen.dart';

class StoryWriteScreen extends StatefulWidget {
  static final String id = '/story_write';
  final String? state;
  final String? whichScreen;

  const StoryWriteScreen({Key? key, this.whichScreen, this.state}) : super(key: key);

  @override
  State<StoryWriteScreen> createState() => _StoryWriteScreenState();
}

class _StoryWriteScreenState extends State<StoryWriteScreen> {
  TextEditingController _titleCon = TextEditingController();
  TextEditingController _bodyCon = TextEditingController();
  TextEditingController _ageCon = TextEditingController();
  TextEditingController _moneyCon = TextEditingController();
  List<XFile>? _imageFileList = [];
  List _firebaseImg = [];
  List _editImg = [];
  final ImagePicker _picker = ImagePicker();
  String? _dropdown = '이상';
  String? _dropdown2 = '월급';
  // String? _dropdown3 = '09:00';
  // String? _dropdown4 = '18:00';
  bool _imageLoading = false;
  int _gender = 0;
  bool _pay = false;
  // List<String> _timeList = ['01:00', '02:00', '03:00', '04:00', '05:00', '06:00'
  //   , '07:00', '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00'
  //   , '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00'
  //   , '23:00', '24:00'];
  int _indexTime = 0;
  int _indexTime2 = 0;
  int _indexTime3 = 0;
  int _indexTime4 = 0;
  var hourList = new List<int>.generate(24, (i) => i);
  var minList = new List<int>.generate(60, (i) => i);

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final cs = Get.put(CommunityState());
      final us = Get.put(UserState());
      final js = Get.put(JobState());
      if (widget.whichScreen == 'job') {
        _firebaseImg = [];
        if (widget.state == 'edit') {
          _titleCon.text = '${js.selectJobTile[0]['title']}';
          _bodyCon.text = '${js.selectJobTile[0]['body']}';
          _ageCon.text = '${js.selectJobTile[0]['age']}';
          _moneyCon.text = js.selectJobTile[0]['pay'] == '협의' ? '0' : '${js.selectJobTile[0]['pay']}';
          ///사진추가
          _editImg = js.selectJobTile[0]['images'];
          if (js.jobList.length != 0) {
            for (int i = 0; i < _editImg.length; i++) {
              _firebaseImg.add(
                  'https://firebasestorage.googleapis.com/v0/b/academy-957f7.appspot.com/o/picture%2F${us.userList[0].phoneNumber}%2F${js.jobDocId.value}%2F${_editImg[i]}?alt=media');
            }
          }
          _dropdown = '${js.selectJobTile[0]['ageValue']}';
          _dropdown2 = '${js.selectJobTile[0]['payValue']}';
          _gender = js.selectJobTile[0]['gender'] == '남자' ? 0 : js.selectJobTile[0]['gender'] == '여자' ? 1 : 2;
          _pay = js.selectJobTile[0]['pay'] == '협의' ? true : false;
          _indexTime = js.selectJobTile[0]['openH'];
          _indexTime2 = js.selectJobTile[0]['openM'];
          _indexTime3 = js.selectJobTile[0]['closeH'];
          _indexTime4 = js.selectJobTile[0]['closeM'];
        }
      } else {
        if (widget.state == 'edit') {
          _titleCon.text = cs.communityList[0]['title'];
          _bodyCon.text = cs.communityList[0]['body'];
          ///사진추가
          _editImg = cs.communityList[0]['images'];
          if (cs.communityList[0]['images'].length != 0) {
            for (int i = 0; i < cs.communityList[0]['images'].length; i++) {
              _firebaseImg.add(
                  'https://firebasestorage.googleapis.com/v0/b/academy-957f7.appspot.com/o/picture%2F${us.userList[0].phoneNumber}%2F${cs.communityList[0]['docId']}%2F${cs.communityList[0]['images'][i]}?alt=media');
            }
          }
        }
      }
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _titleCon.dispose();
    _bodyCon.dispose();
    _ageCon.dispose();
    _moneyCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            widget.whichScreen == 'job' ? '구인구직 작성' : '이야기 작성',
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
                if (_titleCon.text.trim().isEmpty == true ||
                    _bodyCon.text.trim().isEmpty == true) {
                  showOnlyConfirmDialog(context, '제목 또는 내용을 입력해주세요');
                } else {
                  if (widget.whichScreen == 'job' && (_ageCon.text.trim().isEmpty == true ||
                      (_indexTime == _indexTime3) && (_indexTime2 == _indexTime4) )) {
                    showOnlyConfirmDialog(context, '정확히 입력해주세요');
                  } else{
                    showComponentDialog(context, '업로드하시겠습니까?', () async {
                      if (widget.whichScreen == 'job') {
                        if(widget.state == 'edit'){
                          await _editWriting('jobHunting');
                        } else {
                          await jobUpload(_titleCon.text, _bodyCon.text,_gender, _ageCon.text, _dropdown!,
                              _dropdown2!, _pay, _moneyCon.text, _indexTime, _indexTime2, _indexTime3, _indexTime4);
                        }
                      } else {
                        if (widget.state == 'edit') {
                          await _editWriting('story');
                        } else {
                          await communityUpload(_titleCon.text, _bodyCon.text);
                        }
                      }

                      showConfirmTapDialog(context, '업로드 되었습니다', () {
                        setState(() {
                          if (widget.state == 'edit') {Get.back();}
                          Get.back();
                          Get.back();
                          Get.back();
                        });
                      });
                    });
                  }
                }
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
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.vertical(
          //     bottom: Radius.circular(30),
          //   ),
          // ),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormFields(
                    controller: _titleCon,
                    obscureText: true,
                    hintText: '제목을 입력해주세요',
                    surffixIcon: ''),
                const SizedBox(
                  height: 16,
                ),
                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (_imageFileList!.length + _firebaseImg.length > 9) {
                            showOnlyConfirmDialog(
                                context, '사진은 10장까지 올리실 수 있습니다');
                          } else {
                            await _openImagePicker();
                          }
                        },
                        child: Container(
                          height: Get.width * 0.23,
                          width: Get.width * 0.23,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xffE9E9E9),
                            ),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icon/camera.svg',
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text('${_imageFileList!.length + _firebaseImg.length}/10',
                                  style: f16w400),
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //   height: _firebaseImg.length == 0 ? 1 : 132,
                      //   child: ListView.builder(
                      //     shrinkWrap: true,
                      //     itemCount: _firebaseImg.length,
                      //     physics: const ClampingScrollPhysics(),
                      //     scrollDirection: Axis.horizontal,
                      //     itemBuilder: (context, index) {
                      //       return Container(
                      //         margin: EdgeInsets.only(right: 10),
                      //         child: Stack(
                      //           children: [
                      //             ClipRRect(
                      //                 borderRadius: BorderRadius.circular(10.0),
                      //                 child: ExtendedImage.network(
                      //                   _firebaseImg[index],
                      //                   fit: BoxFit.fill,
                      //                   width: 132,
                      //                   height: 132,
                      //                   cache: false,
                      //                   enableLoadState: false,
                      //                 )),
                      //             Positioned(
                      //               child: GestureDetector(
                      //                 onTap: () {
                      //                   _firebaseImg.removeAt(index);
                      //                   _editImg.removeAt(index);
                      //
                      //                   setState(() {});
                      //                 },
                      //                 child: Container(
                      //                   height: 24,
                      //                   width: 24,
                      //                   decoration: BoxDecoration(
                      //                       color: Colors.grey.withOpacity(0.4),
                      //                       borderRadius: BorderRadius.circular(100)),
                      //                   child: Icon(
                      //                     Icons.close,
                      //                     color: Colors.white,
                      //                     size: 14,
                      //                   ),
                      //                 ),
                      //               ),
                      //               top: 3,
                      //               right: 5,
                      //             ),
                      //           ],
                      //         ),
                      //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      //       );
                      //     },
                      //   ),
                      // ),
                      Container(
                        height:
                        _firebaseImg.length == 0 ? 1 : Get.width * 0.23,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _firebaseImg.length,
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                        child: ExtendedImage.network(
                                            _firebaseImg[index],
                                            width: Get.width * 0.23,
                                            height: Get.width * 0.23,
                                            cache: false,
                                            enableLoadState: false,
                                            fit: BoxFit.fill),
                                      ),
                                      Positioned(
                                        child: GestureDetector(
                                          onTap: () {
                                            // _firebaseImg.removeAt(index);
                                            _firebaseImg.removeAt(index);
                                            _editImg.removeAt(index);
                                            // FirebaseStorage.instance.refFromURL('https://firebasestorage.googleapis.com/v0/b/clicksound-af0c0.appspot.com/o/picture%2F$phoneNumber2FtqdmVbK9U8BDvZCS2Hpg%2FSimulator%20Screen%20Shot%20-%20iPhone%2013%20Pro%20-%202022-08-08%20at%2015.33.20.png?alt=media&token=ed9e8242-056e-4201-af95-d2ae609c924e').delete();
                                            setState(() {});
                                          },
                                          child: Container(
                                            height: 24,
                                            width: 24,
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                BorderRadius.circular(100)),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                        top: 3,
                                        right: 4,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8)),
                            );
                          },
                        ),
                      ),
                      Container(
                        height:
                            _imageFileList!.length == 0 ? 1 : Get.width * 0.23,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _imageFileList!.length,
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.file(
                                            File(_imageFileList![index].path),
                                            width: Get.width * 0.23,
                                            height: Get.width * 0.23,
                                            fit: BoxFit.fill),
                                      ),
                                      Positioned(
                                        child: GestureDetector(
                                          onTap: () {
                                            // _firebaseImg.removeAt(index);
                                            _imageFileList!.removeAt(index);
                                            // FirebaseStorage.instance.refFromURL('https://firebasestorage.googleapis.com/v0/b/clicksound-af0c0.appspot.com/o/picture%2F$phoneNumber2FtqdmVbK9U8BDvZCS2Hpg%2FSimulator%20Screen%20Shot%20-%20iPhone%2013%20Pro%20-%202022-08-08%20at%2015.33.20.png?alt=media&token=ed9e8242-056e-4201-af95-d2ae609c924e').delete();
                                            setState(() {});
                                          },
                                          child: Container(
                                            height: 24,
                                            width: 24,
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                        top: 3,
                                        right: 4,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8)),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _bodyCon,
                  keyboardType: TextInputType.multiline,
                  style: f16w400,
                  minLines: 10,
                  maxLines: null,
                  decoration: InputDecoration(
                      hintText: '내용을 입력해주세요',
                      hintStyle: f16w400greyA,
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.transparent))),
                ),
                widget.whichScreen == 'job'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          Text(
                            '성별',
                            style: f18w400,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ChooseButton(
                                  title: '남자',
                                  isTrue: _gender == 0 ? true : false,
                                  onTap: () {
                                    _gender = 0;
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: ChooseButton(
                                  title: '여자',
                                  isTrue: _gender == 1 ? true : false,
                                  onTap: () {
                                    _gender = 1;
                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: ChooseButton(
                                  title: '성별 무관',
                                  isTrue: _gender == 2 ? true : false,
                                  onTap: () {
                                    _gender = 2;
                                    setState(() {});
                                  },
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            '나이',
                            style: f18w400,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _ageCon,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: Color(0xffEBEBEB),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 14),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(8)),
                                    hintText: '나이',
                                    hintStyle: f16w400grey8,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 1,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color(0xffebebeb)),
                                  child: Padding(
                                    padding: ph20v14,
                                    child: DropdownButton<String>(
                                      focusColor: Colors.white,
                                      isDense: true,
                                      isExpanded: true,
                                      underline: Container(),
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Color(0xff535353),
                                      ),
                                      value: _dropdown,
                                      //elevation: 5,
                                      style: TextStyle(color: Colors.white),
                                      iconEnabledColor: Colors.black,
                                      items: <String>[
                                        '이상',
                                        '이하',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value, style: f16w400),
                                        );
                                      }).toList(),
                                      hint: Text(
                                        "나이",
                                        style: f14w500,
                                      ),
                                      onChanged: (v) {
                                        setState(() {
                                          _dropdown = v;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            '급여',
                            style: f18w400,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  enabled: !_pay,
                                  controller: _moneyCon,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: Color(0xffEBEBEB),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 14),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(8)),
                                    hintText: '만원 단위',
                                    hintStyle: f16w400grey8,
                                  ),
                                ),
                              ),
                              Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: Color(0xffdadada),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: Checkbox(
                                        value: _pay ,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(3)
                                        ),
                                        checkColor: Colors.white,
                                        activeColor: nowColor,
                                        onChanged: (v) {
                                          setState(() {
                                            _pay = !_pay;
                                          });
                                        },
                                      ),
                                    ),
                                    Text('협의', style: f16w400,),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Expanded(
                                flex: 1,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color(0xffebebeb)),
                                  child: Padding(
                                    padding: ph20v14,
                                    child: DropdownButton<String>(
                                      focusColor: Colors.white,
                                      isDense: true,
                                      isExpanded: true,
                                      underline: Container(),
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Color(0xff535353),
                                      ),
                                      value: _dropdown2,
                                      //elevation: 5,
                                      style: TextStyle(color: Colors.white),
                                      iconEnabledColor: Colors.black,
                                      items: <String>[
                                        '월급',
                                        '주급',
                                        '시급',
                                      ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value, style: f16w400),
                                            );
                                          }).toList(),
                                      hint: Text(
                                        "월급",
                                        style: f14w500,
                                      ),
                                      onChanged: (v) {
                                        setState(() {
                                          _dropdown2 = v;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            '시간',
                            style: f18w400,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              // Expanded(
                              //   flex: 1,
                              //   child: DecoratedBox(
                              //     decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(8),
                              //         color: Color(0xffebebeb)),
                              //     child: Padding(
                              //       padding: ph20v14,
                              //       child: DropdownButton<String>(
                              //         focusColor: Colors.white,
                              //         isDense: true,
                              //         isExpanded: true,
                              //         underline: Container(),
                              //         icon: Icon(
                              //           Icons.keyboard_arrow_down,
                              //           color: Color(0xff535353),
                              //         ),
                              //         value: _dropdown3,
                              //         //elevation: 5,
                              //         style: TextStyle(color: Colors.white),
                              //         iconEnabledColor: Colors.black,
                              //         items: _timeList.map<DropdownMenuItem<String>>(
                              //                 (String value) {
                              //               return DropdownMenuItem<String>(
                              //                 value: value,
                              //                 child: Text(value, style: f16w400),
                              //               );
                              //             }).toList(),
                              //         hint: Text(
                              //           "월급",
                              //           style: TextStyle(
                              //               color: Colors.black,
                              //               fontSize: 14,
                              //               fontWeight: FontWeight.w500),
                              //         ),
                              //         onChanged: (v) {
                              //           setState(() {
                              //             _dropdown3 = v;
                              //           });
                              //         },
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Expanded(
                                flex: 1,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color(0xffebebeb)),
                                  child: GestureDetector(
                                    onTap: () async {
                                      var ls = await Get.to(() => JobTimerScreen(
                                        indexTime: _indexTime,
                                        indexTime2: _indexTime2,
                                      ));


                                      setState(() {
                                        _indexTime = ls[0];
                                        _indexTime2 = ls[1];
                                      });
                                    },
                                    child: Padding(
                                      padding: ph20v14,
                                      child: Text('${_indexTime.toString().padLeft(2,'0')} : '
                                          '${_indexTime2.toString().padLeft(2,'0')}', style: f16w400,
                                        textAlign: TextAlign.center,),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Text(' ~ ', style: f16w400,),
                              const SizedBox(width: 10,),
                              Expanded(
                                flex: 1,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Color(0xffebebeb)),
                                  child: GestureDetector(
                                    onTap: () async {
                                      var ls = await Get.to(() => JobTimerScreen(
                                        indexTime: _indexTime3,
                                        indexTime2: _indexTime4,
                                      ));


                                      setState(() {
                                        _indexTime3 = ls[0];
                                        _indexTime4 = ls[1];
                                      });
                                    },
                                    child: Padding(
                                        padding: ph20v14,
                                        child: Text('${_indexTime3.toString().padLeft(2,'0')} : '
                                            '${_indexTime4.toString().padLeft(2,'0')}', style: f16w400,
                                        textAlign: TextAlign.center,),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30,),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> jobUpload(String title, String body, int gender, String age, String ageValue, String payValue, bool pay,
      String money, int openH, int openM, int closeH, int closeM) async {
    final us = Get.put(UserState());
    CollectionReference ref = FirebaseFirestore.instance.collection('jobHunting');
    ref.add({
      'age' : age,
      'ageValue' : ageValue,
      'body' : body,
      'closeH' : closeH,
      'closeM' : closeM,
      'docId' : '',
      'gender' : gender == 0 ? '남자' : gender == 1 ? '여자' : '성별 무관',
      'hasImage' : 'false',
      'openH' : openH,
      'openM' : openM,
      'pay' : pay ? '협의' : money,
      'payValue' : payValue,
      'teacher' : '${us.userList[0].phoneNumber}',
      'title' : title,
      'images' : [],
      'jobIs' : true,
      'createDate' : '${DateTime.now()}',
    }).then((doc) async {
      DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('jobHunting').doc(doc.id);
      await userDocRef.update({'docId': '${doc.id}'});
      if (_imageFileList!.length != 0) {
        await userDocRef.update({'hasImage': 'true'});
        await uploadFile(doc.id, '${us.userList[0].phoneNumber}', 'jobHunting');
      }
    });
  }

  Future<void> communityUpload(String title, String body) async {
    final us = Get.put(UserState());
    CollectionReference ref = FirebaseFirestore.instance.collection('story');
    ref.add({
      'id': '${us.userList[0].phoneNumber}',
      'docId': '',
      'title': title,
      'body': body,
      'hasImage': 'false',
      'status': '게시중',
      'type': '${us.userList[0].userType}',
      'name': '${us.userList[0].name}',
      'images': [],
      'createDate': '${DateTime.now()}',
    }).then((doc) async {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('story').doc(doc.id);
      await userDocRef.update({'docId': '${doc.id}'});
      if (_imageFileList!.length != 0) {
        await userDocRef.update({'hasImage': 'true'});
        await uploadFile(doc.id, '${us.userList[0].phoneNumber}', 'story');
      }
    });
  }

  Future<void> _openImagePicker() async {
    try {
      final List<XFile>? selectedImages = await _picker.pickMultiImage();
      if (selectedImages!.isNotEmpty) {
        if (selectedImages.length > 10) {
          showOnlyConfirmDialog(context, '사진은 10장까지 올리실 수 있습니다');
        } else {
          if (_imageFileList!.length + selectedImages.length > 10) {
            showOnlyConfirmDialog(context, '사진은 10장까지 올리실 수 있습니다');
          } else {
            _imageFileList!.addAll(selectedImages);

          }
        }
        setState(() {});
      }

    } catch (e) {

    }
  }

  Future uploadFile(String docId, String phoneNumber, String category) async {
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
    DocumentReference userDocRef = FirebaseFirestore.instance.collection(category).doc(docId);
    List<String> ls = [];
    for (int i = 0; i < _imageFileList!.length; i++) {
      ls.add('${DateTime.now()}');
      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('picture')
          .child('$phoneNumber')
          .child('$docId')
          .child(ls[i]);
      final uploadTask = firebaseStorageRef.putFile(
          File(_imageFileList![i].path),
          SettableMetadata(contentType: 'image/png'));
      await uploadTask;
    }
    final pathReference = FirebaseStorage.instance.ref().child('picture').child('$phoneNumber').child(docId);
    ListResult nestedResult = await pathReference.listAll();
    nestedResult.items.forEach((element) async {
      for(int i=0; i<ls.length; i++) {
        if('${element.name}' == ls[i]) {
          await userDocRef.update({
            "images": FieldValue.arrayUnion(['${element.name}'])
          });
        }
      }
    });
    // ListResult nestedResult = await pathReference.listAll();
    // nestedResult.items.forEach((element) async {
    //   await userDocRef.update({
    //     "images": FieldValue.arrayUnion(['${element.name}'])
    //   });
    // });

    setState(() {
      _imageLoading = false;
      Navigator.pop(context);
    });
  }

  Future<void> _editWriting(String collection) async {
    final cs = Get.put(CommunityState());
    final js = Get.put(JobState());
    final us = Get.put(UserState());
    DocumentReference userRef = FirebaseFirestore.instance.collection(collection)
        .doc(collection == 'jobHunting' ? '${js.jobDocId}' : cs.communityList[0]['docId']);
    if (_editImg.length != 0 && _imageFileList!.length == 0) {

      collection == 'jobHunting' ? await userRef.update({
        'title': _titleCon.text,
        'body': _bodyCon.text,
        'hasImage': 'true',
        'images': _editImg,
        'age' : _ageCon.text,
        'ageValue' : _dropdown!,
        'closeH' : _indexTime3,
        'closeM' : _indexTime4,
        'gender' : _gender == 0 ? '남자' : _gender == 1 ? '여자' : '성별 무관',
        'openH' : _indexTime,
        'openM' : _indexTime2,
        'pay' : _pay ? '협의' : _moneyCon.text,
        'payValue' : _dropdown2!,
      }) :
      await userRef.update({
        'title': _titleCon.text,
        'body': _bodyCon.text,
        'hasImage': 'true',
        'images': _editImg,
      });
    } else if (_editImg.length == 0 && _imageFileList!.length != 0) {


      collection == 'jobHunting' ? await userRef.update({
        'title': _titleCon.text,
        'body': _bodyCon.text,
        'hasImage': 'true',
        'images': [],
        'age' : _ageCon.text,
        'ageValue' : _dropdown!,
        'closeH' : _indexTime3,
        'closeM' : _indexTime4,
        'gender' : _gender == 0 ? '남자' : _gender == 1 ? '여자' : '성별 무관',
        'openH' : _indexTime,
        'openM' : _indexTime2,
        'pay' : _pay ? '협의' : _moneyCon.text,
        'payValue' : _dropdown2!,
      }) :
      await userRef.update({
        'title': _titleCon.text,
        'body': _bodyCon.text,
        'hasImage': 'true',
        'images': [],
      });
      await deleteFolder(path: "picture/${us.userList[0].phoneNumber}/${collection == 'jobHunting' ? '${js.jobDocId}' : cs.communityList[0]['docId']}");
      await uploadFile(collection == 'jobHunting' ? '${js.jobDocId}' : cs.communityList[0]['docId'],
          '${us.userList[0].phoneNumber}', collection);
    } else if (_editImg.length != 0 && _imageFileList!.length != 0) {


      collection == 'jobHunting' ? await userRef.update({
        'title': _titleCon.text,
        'body': _bodyCon.text,
        'hasImage': 'true',
        'images': _editImg,
        'age' : _ageCon.text,
        'ageValue' : _dropdown!,
        'closeH' : _indexTime3,
        'closeM' : _indexTime4,
        'gender' : _gender == 0 ? '남자' : _gender == 1 ? '여자' : '성별 무관',
        'openH' : _indexTime,
        'openM' : _indexTime2,
        'pay' : _pay ? '협의' : _moneyCon.text,
        'payValue' : _dropdown2!,
      }) :
      await userRef.update({
        'title': _titleCon.text,
        'body': _bodyCon.text,
        'hasImage': 'true',
        'images': _editImg,
      });
      await uploadFile(collection == 'jobHunting' ? '${js.jobDocId}' : cs.communityList[0]['docId'],
          '${us.userList[0].phoneNumber}', collection);
    } else if (_editImg.length == 0 && _imageFileList!.length == 0) {

      collection == 'jobHunting' ? await userRef.update({
        'title': _titleCon.text,
        'body': _bodyCon.text,
        'hasImage': 'false',
        'images': [],
        'age' : _ageCon.text,
        'ageValue' : _dropdown!,
        'closeH' : _indexTime3,
        'closeM' : _indexTime4,
        'gender' : _gender == 0 ? '남자' : _gender == 1 ? '여자' : '성별 무관',
        'openH' : _indexTime,
        'openM' : _indexTime2,
        'pay' : _pay ? '협의' : _moneyCon.text,
        'payValue' : _dropdown2!,
      }) :
      await userRef.update({
        'title': _titleCon.text,
        'body': _bodyCon.text,
        'hasImage': 'false',
        'images': [],
      });
      await deleteFolder(path: "picture/${us.userList[0].phoneNumber}/${collection == 'jobHunting' ? '${js.jobDocId}' : cs.communityList[0]['docId']}");
    }
  }

  Future<void> deleteFolder({required String path}) async {
    List<String> paths = [];
    paths = await _deleteFolder(path, paths);
    for (String path in paths) {
      await FirebaseStorage.instance.ref().child(path).delete();
    }
  }

  Future<List<String>> _deleteFolder(String folder, List<String> paths) async {
    ListResult list = await FirebaseStorage.instance.ref().child(folder).listAll();
    List<Reference> items = list.items;
    List<Reference> prefixes = list.prefixes;
    for (Reference item in items) {
      paths.add(item.fullPath);
    }
    for (Reference subfolder in prefixes) {
      paths = await _deleteFolder(subfolder.fullPath, paths);
    }
    return paths;
  }
}
