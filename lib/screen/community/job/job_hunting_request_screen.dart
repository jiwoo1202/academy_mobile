import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../components/dialog/showAlertDialog.dart';
import '../../../firebase/firebase_job.dart';
import '../../../provider/job_state.dart';
import '../../../provider/user_state.dart';
import '../../../util/font/font.dart';
import '../../../util/loading.dart';

class JobHuntingRequestScreen extends StatefulWidget {
  static final String id = '/job_hunting_request_screen';
  const JobHuntingRequestScreen({Key? key}) : super(key: key);

  @override
  State<JobHuntingRequestScreen> createState() => _JobHuntingRequestScreenState();
}

class _JobHuntingRequestScreenState extends State<JobHuntingRequestScreen> {
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _pay = TextEditingController();
  TextEditingController _openH = TextEditingController();
  TextEditingController _openM = TextEditingController();
  TextEditingController _closeH = TextEditingController();
  TextEditingController _closeM = TextEditingController();
  var maskFormatter = new MaskTextInputFormatter(mask: '###-####-####');
  String payValue = '';
  String genderValue = '';
  String ageValue = '';
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList = [];
  List _firebaseImg = [];
  List _editImg = [];
  String _hasImageCheck = 'false';
  bool _imageLoading = false;
  bool _firstCheck = false;

  @override
  void initState() {
    super.initState();
    ageValue = '이상';
    payValue = '월급';
    setState(() {});
  }
  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _age.dispose();
    _pay.dispose();
    _openH.dispose();
    _openM.dispose();
    _closeH.dispose();
    _closeM.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final js =Get.put(JobState());
    final us = Get.put(UserState());
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 50),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('${us.id}',style: f16w500,),
                // Obx(() =>Text('${us.id}',style: f16w500,)),
                TextField(
                  controller: _title,
                  onChanged: (v){
                    // us.id.value = _title.text.trim();
                  },
                  decoration: InputDecoration(
                    labelText: '제목',
                    hintText: '제목을 입력해주세요',
                    labelStyle: TextStyle(color: Colors.blueGrey),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),

                const SizedBox(height: 24,),

                TextField(
                  controller: _body,
                  onChanged: (v){
                    // us.id.value = _title.text.trim();
                  },
                  decoration: InputDecoration(
                    labelText: '내용',
                    hintText: '내용을 입력해주세요',
                    labelStyle: TextStyle(color: Colors.blueGrey),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  maxLines: 5,
                ),

                const SizedBox(height: 24,),

                GestureDetector(
                  onTap: () async {
                    if (_imageFileList!.length > 9) {
                      showOnlyConfirmDialog(context, '사진은 10장까지 올리실 수 있습니다');
                    } else {
                      await _openImagePicker();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 13),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icon/image_icon.svg',
                          height: 18,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          '사진 추가',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NotoSansKr',
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          '최대 10장',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'NotoSansKr',
                            color: const Color(0xffA0A4A6),
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xffE9E9E9),
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 12,),

                SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        height: _firebaseImg.length == 0 ? 1 : 132,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _firebaseImg.length,
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: ExtendedImage.network(
                                        _firebaseImg[index],
                                        fit: BoxFit.fill,
                                        width: 132,
                                        height: 132,
                                        cache: false,
                                        enableLoadState: false,
                                      )),
                                  Positioned(
                                    child: GestureDetector(
                                      onTap: () {
                                        _firebaseImg.removeAt(index);
                                        _editImg.removeAt(index);

                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.4),
                                            borderRadius: BorderRadius.circular(100)),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                    top: 3,
                                    right: 5,
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                            );
                          },
                        ),
                      ),
                      Container(
                        height: _imageFileList!.length == 0 ? 1 : 132,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _imageFileList!.length,
                          physics: const ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.file(File(_imageFileList![index].path),
                                        width: 132, height: 132, fit: BoxFit.fill),
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
                                            color: Colors.grey.withOpacity(0.4),
                                            borderRadius: BorderRadius.circular(100)),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                    top: 3,
                                    right: 5,
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24,),

                Text('성별', style: f20w500,),
                const SizedBox(height: 12,),
                Center(
                  child: ToggleSwitch(
                    minWidth: Get.width*0.3,
                    minHeight: 70.0,
                    initialLabelIndex: 0,
                    cornerRadius: 20.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.white,
                    inactiveFgColor: Colors.black,
                    totalSwitches: 3,
                    animate: true,
                    animationDuration: 300,
                    fontSize: 25,
                    labels: ['남자', '여자', '성별 무관'],
                    borderWidth: 2.0,
                    borderColor: [Colors.black],
                    activeBgColors: [[Colors.blue], [Colors.pink], [Colors.purpleAccent]],
                    onToggle: (index) {
                      genderValue = index == 0 ? '남자' : index == 1 ? '여자' : '성별 무관';
                    },
                  ),
                ),

                const SizedBox(height: 24,),

                Row(
                  children: [
                    Container( width: Get.width * 0.5,
                      child: TextField(
                        controller: _age,
                        onChanged: (v){
                          // us.id.value = _title.text.trim();
                        },
                        decoration: InputDecoration(
                          labelText: '나이',
                          hintText: '나이를 입력해주세요',
                          labelStyle: TextStyle(color: Colors.blueGrey),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Container(width: 120,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: ageValue,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 60,
                        elevation: 16,
                        hint: Text(
                            '선택해주세요',
                            style: f14w500
                        ),
                        style: const TextStyle(color: Colors.black),

                        onChanged: (newValue) {
                          setState(() {
                            ageValue = '${newValue}';
                          });
                        },
                        items: <String>['이상', '이하'].map<DropdownMenuItem<String>>((String val) {
                          // ignore: missing_required_param
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                                val,
                                style: f24w500
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 24,),

                Row(
                  children: [
                    Container( width: Get.width * 0.5,
                      child: TextField(
                        controller: _pay,
                        enabled: !_firstCheck,
                        onChanged: (v){
                          // us.id.value = _title.text.trim();
                        },
                        decoration: InputDecoration(
                          labelText: '급여',
                          hintText: '급여를 입력해주세요',
                          labelStyle: TextStyle(color: Colors.blueGrey),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 20,),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        checkColor: Colors.white,
                        activeColor: const Color(0xff558E99),
                        side: MaterialStateBorderSide.resolveWith(
                              (states) => BorderSide(
                              width: 2.0, color: _firstCheck == false ? Color(0xffA0A4A6) : Color(0xff558E99)),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        value: _firstCheck,
                        onChanged: (v) {
                          setState(() {
                            _firstCheck = v!;
                          });
                          // _firstCheck == true ? sp.luxation = 'true' : sp.luxation = 'false';
                        },
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    GestureDetector(onTap: () {
                      setState(() {
                        _firstCheck = !_firstCheck;
                      });
                    },
                    child: Text('협의', style: f24w400)),
                    const SizedBox(width: 20,),
                    Container(width: 120,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: payValue,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 60,
                        elevation: 16,
                        hint: Text(
                            '선택해주세요',
                            style: f14w500
                        ),
                        style: const TextStyle(color: Colors.black),

                        onChanged: (newValue) {
                          setState(() {
                            payValue = '${newValue}';
                          });
                        },
                        items: <String>['월급', '주급', '시급'].map<DropdownMenuItem<String>>((String val) {
                          // ignore: missing_required_param
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                                val,
                                style: f24w500
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 24,),

                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container( width: 50,
                      child: TextField(
                        controller: _openH,
                        onChanged: (v){
                          // us.id.value = _title.text.trim();
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Text('시', style: f24w500,),
                    const SizedBox(width: 20,),
                    Container( width: 50,
                      child: TextField(
                        controller: _openM,
                        onChanged: (v){
                          // us.id.value = _title.text.trim();
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Text('분', style: f24w500,),
                    const SizedBox(width: 20,),
                    Text('~', style: f24w500,),
                    const SizedBox(width: 20,),
                    Container( width: 50,
                      child: TextField(
                        controller: _closeH,
                        onChanged: (v){
                          // us.id.value = _title.text.trim();
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Text('시', style: f24w500,),
                    const SizedBox(width: 20,),
                    Container( width: 50,
                      child: TextField(
                        controller: _closeM,
                        onChanged: (v){
                          // us.id.value = _title.text.trim();
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(width: 1, color: Colors.blueGrey),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Text('분', style: f24w500,),
                  ],
                ),

                const SizedBox(height: 24,),

                Row(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(onPressed: (){ Get.back();}, child: Text('취소')),
                    SizedBox(width: 40,),
                    ElevatedButton(onPressed: () async {
                      if(_title.text.trim().isEmpty==true || _body.text.trim().isEmpty ==true
                          || _age.text.trim().isEmpty==true || (_pay.text.trim().isEmpty==true && _firstCheck == false)
                          || _closeH.text.trim().isEmpty==true || _closeM.text.trim().isEmpty==true
                          || _openH.text.trim().isEmpty==true || _openM.text.trim().isEmpty==true){
                        showDialog(
                            context: context,
                            builder:(BuildContext context)=>AlertDialog(
                              content: Text('모든 칸에 입력해주세요'),
                              actions: [
                                ElevatedButton(
                                    onPressed:(){
                                      Navigator.of(context).pop();
                                    } , child: Text('네'))
                              ],
                            ));
                      }
                      else {
                        await firebaseJobCreate(
                            _age.text,
                            ageValue,
                            _body.text,
                            _closeH.text,
                            _closeM.text,
                            genderValue,
                            _hasImageCheck,
                            _openH.text,
                            _openM.text,
                            _firstCheck ? '협의': _pay.text,
                            payValue,
                            _title.text);//firebase 먼저 저장 후 docId 가져와
                        await uploadFile('${js.jobDocId}','${us.userList[0].phoneNumber}');
                        showDialog(
                            context: context,
                            builder:(BuildContext context)=>AlertDialog(
                              content: Text('저장 되었습니다.'),
                              actions: [
                                ElevatedButton(
                                    onPressed:(){
                                      Get.back();
                                      Get.back();
                                    } , child: Text('네'))
                              ],
                            ));
                      };

                    }, child: Text('저장')),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
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
            _hasImageCheck = 'true';
          }
        }
        setState(() {});
      } else {
        _hasImageCheck = 'false';
      }
      print('image finished');
    } catch (e) {
      print('image error : $e');
    }
  }

  Future uploadFile(String docId, String phoneNumber) async {
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
    ) : Container();
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('jobHunting').doc(docId);
    for (int i = 0; i < _imageFileList!.length; i++) {
      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('picture')
          .child('$phoneNumber')
          .child('$docId')
          .child('${DateTime.now()}');
      final uploadTask =
      firebaseStorageRef.putFile(File(_imageFileList![i].path), SettableMetadata(contentType: 'image/png'));
      await uploadTask;
    }
    final pathReference = FirebaseStorage.instance.ref().child('picture').child('$phoneNumber').child(docId);
    ListResult nestedResult = await pathReference.listAll();
    nestedResult.items.forEach((element) async {
      await userDocRef.update({
        "picture": FieldValue.arrayUnion(['${element.name}'])
      });
    });

    setState(() {
      _imageLoading = false;
      Navigator.pop(context);
    });
  }

  // Future<void> _editGet(String? docId, String collection) async {
  //   CollectionReference _hosRef = FirebaseFirestore.instance.collection(collection);
  //   QuerySnapshot snapshot = await _hosRef.where('id', isEqualTo: docId).get();
  //   final allData = snapshot.docs.map((doc) => doc.data()).toList();
  //   _myHospitalList = allData;
  //   if (_myHospitalList[0]['images'].length == 0) {
  //     _editImg = [];
  //   } else {
  //     _editImg = _myHospitalList[0]['images'];
  //   }
  // }
}
