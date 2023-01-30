import 'package:academy/components/font/font.dart';
import 'package:academy/util/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../api/pdf/pdf_api.dart';
import '../../../components/tile/main_tile.dart';
import '../main_search_screen.dart';
import 'pdf_check_screen.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({Key? key}) : super(key: key);

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  // bool _isOpened = false;
  List _allData = [];
  List<bool> _isOpened = [];
  List<bool> _selection = List.generate(3, (_) => false);

  @override
  void initState() {
    // Future.delayed(Duration.zero,()async{
    //   await teacherGet();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: Get.width, height: Get.height,
      padding: EdgeInsets.symmetric(horizontal: Get.width*0.2, vertical: 30),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('answer').where('teacher', isEqualTo: '12345').snapshots(),
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting){
            return LoadingBodyScreen();
          }

          return Column(
            children: [
              SizedBox(height: 30,),
              Text(
                ' 선생님',
                style: f24w500,
              ),
              SizedBox(height: 30,),
              //검색
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  var drugName =
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainSearchScreen(),
                    ),
                  );
                  // Get.to(() => MainSearchScreen.id);
                  // setState(() {
                  //   if (drugName != null && drugName != '') createDrugItem(drugName);
                  // });
                },
                child: Container(
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 50,),
                        Text(
                          '검색', style: f24w500,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 24,
                            ),
                            SizedBox(
                              width: 15,
                            )
                          ],
                        ),
                      ],
                    )),
              ),
              SizedBox(height: 40,),
              //조건 비어있으면 Text or 카드 있으면 카드 ListView 부르기
              // false ?
              // Text('선생님 이름 혹은\n코드를 검색해주세요', style: TextStyle(fontSize: 20),):
              ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      MainTile(
                        isOpened: snapshot.data!.docs[index]['temp1'] == 'true' ? true : false,
                        isStudent: false,
                        onTap: () async {
                          final url =
                              'https://firebasestorage.googleapis.com/v0/b/academy-957f7.appspot.com/o/12345%2F12345%2F${snapshot.data!.docs[index]['docId']}.pdf?alt=media';
                          // 'https://firebasestorage.googleapis.com/v0/b/miocr-82323.appspot.com/o/test.pdf?alt=media&token=0fd055a8-aa9d-41d8-970c-1c882ed6d5dc';
                          final file = await PDFApi.loadNetwork(url);
                          Get.to(PdfCheckScreen(file: file,));
                          print('hey');
                        },
                        tName: '12345',
                        tCreateDate: '${DateFormat('y-MM-dd HH:mm').format(DateTime.parse('${snapshot.data!.docs[index]['createDate']}'))}',
                        title: '${snapshot.data!.docs[index]['pdfCategory']}',
                        switchOnTap: (){
                          if(snapshot.data!.docs[index]['temp1'] == 'true'){
                            updateData(snapshot.data!.docs[index]['docId'],false);
                          }else{
                            updateData(snapshot.data!.docs[index]['docId'],true);
                          }
                        },
                      ),
                      SizedBox(height: 30,),
                    ],
                  );
                },
              ),
            ],
          );
        }
      ),
    );
  }

  Future<void> teacherGet() async{
    CollectionReference ref = FirebaseFirestore.instance.collection('answer');
    QuerySnapshot snapshot = await ref.where('teacher', isEqualTo: '12345').get();
    final allData = snapshot.docs.map((doc) => doc.data()).toList();
    _allData = allData;
    print('all : ${_allData.length}');
  }

  Future<void> updateData(String docId,bool value) async{
    CollectionReference ref = FirebaseFirestore.instance.collection('answer');
    QuerySnapshot snapshot = await ref.where('docId', isEqualTo: docId).get();
    snapshot.docs[0].reference.update({
      'temp1' : '${value}'
    });
    // final allData = snapshot.docs.map((doc) => doc.data()).toList();
    // _allData = allData;
    // print('all : ${_allData.length}');
  }
}
