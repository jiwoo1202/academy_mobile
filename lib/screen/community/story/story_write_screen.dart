import 'dart:io';

import 'package:academy/components/font/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

import '../../../components/dialog/showAlertDialog.dart';
import '../../../util/loading.dart';

class StoryWriteScreen extends StatefulWidget {
  static final String id = '/story_write';

  const StoryWriteScreen({Key? key}) : super(key: key);

  @override
  State<StoryWriteScreen> createState() => _StoryWriteScreenState();
}

class _StoryWriteScreenState extends State<StoryWriteScreen> {
  TextEditingController _titleCon = TextEditingController();
  TextEditingController _bodyCon = TextEditingController();
  List<XFile>? _imageFileList = [];
  final ImagePicker _picker = ImagePicker();
  String _hasImageCheck = 'false';
  bool _imageLoading = false;

  @override
  void dispose() {
    _titleCon.dispose();
    _bodyCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar:  AppBar(
          title: Text('이야기 작성'),
          backgroundColor: Colors.lightGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleCon,
                keyboardType: TextInputType.multiline,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: '제목을 입력해주세요',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.grey)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
                        height: 26,
                        width: 40,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        '사진 추가',
                        style: const TextStyle(
                          fontSize: 20,
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
                          fontSize: 18,
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
              const SizedBox(
                height: 12,
              ),
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
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

              const SizedBox(height: 20,),
              TextField(
                controller: _bodyCon,
                keyboardType: TextInputType.multiline,
                minLines: 10,
                maxLines: null,
                decoration: InputDecoration(
                    hintText: '내용을 입력해주세요',
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey))),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GestureDetector(
            onTap: (){
              showComponentDialog(context, '업로드하시겠습니까?', () async {
                await communityUpload(_titleCon.text,_bodyCon.text);
              });
            },
            child: Container(
              color: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
              child: Text('업로드',textAlign: TextAlign.center,style: f20w500,)
            ),
          ),
        ),
      ),
    );
  }

  Future<void> communityUpload (String title,String body) async{
    CollectionReference ref = FirebaseFirestore.instance.collection('story');
    ref.add({
      'id' : '01048544580',
      'docId' : '',
      'title' : title,
      'body' : body,
      'hasImage' : 'false',
      'status' : '게시중',
      'type' : '학생',
      'name' : '김아무개',
      'images' : [],
      'createDate' : '${DateTime.now()}',
    }).then((doc) async {
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('story').doc(doc.id);
      await userDocRef.update({'docId': '${doc.id}'});
      if(_imageFileList!.length != 0){
        await userDocRef.update({'hasImage': 'true'});
        await uploadFile(doc.id,'01048544580');
      }

      Get.back();
      Get.back();
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
    )
        : Container();
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('story').doc(docId);
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
        "images": FieldValue.arrayUnion(['${element.name}'])
      });
    });

    setState(() {
      _imageLoading = false;
      Navigator.pop(context);
    });
  }
}
