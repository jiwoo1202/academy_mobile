import 'package:academy/components/dialog/showAlertDialog.dart';
import 'package:academy/components/font/font.dart';
import 'package:academy/firebase/firebase_answer.dart';
import 'package:academy/provider/answer_state.dart';
import 'package:academy/provider/test_state.dart';
import 'package:academy/util/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../api/pdf/pdf_api.dart';
import '../../../components/tile/main_tile.dart';
import '../../../provider/user_state.dart';
import '../main_search_screen.dart';
import 'test/test_main_screen.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  TextEditingController _pwcontroller = TextEditingController();
  bool isLoading = true;
  @override
  void initState() {
    final as =Get.put(AnswerState());
    Future.delayed(Duration.zero,() async{
      as.getDocid.value = [];
      as.teacherList.value = [];
      as.createList.value=[];
      _pwcontroller;
      await getState('대기');
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }
  @override
  void dispose(){

    _pwcontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final as =Get.put(AnswerState());
    final ts = Get.put(TestState());
    return SingleChildScrollView(
      child: isLoading?LoadingBodyScreen():
      Container(width: Get.width,
        padding:  EdgeInsets.symmetric(horizontal: Get.width*0.2, vertical: 30),
        child: Column(
          children: [
            const SizedBox(height: 30,),
            Text(
              '학생',
              style: f32w500,
            ),
            const SizedBox(height: 30,),
            //검색
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                Get.to(() => MainSearchScreen());
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
                     const SizedBox(width: 50,),
                      Text(
                        '검색',
                        style: const TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontFamily: 'NotoSansKr',
                            fontWeight: FontWeight.w500),
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
           const  SizedBox(height: 40,),
            ListView.builder(
              itemCount: as.stateList.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    MainTile(
                      isOpened: true,
                      isStudent: true,
                      subject: as.state.value,
                      tName: as.teacherList[index],
                      tCreateDate:'${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(as.createList[index]))}',
                      onTap: ()async{
                        getAnswerLength('${as.getDocid[index]}');
                        ts.answerDocId.value = '${as.getDocid[index]}';
                        as.getTeacherName.value = '${as.teacherList[index]}';
                        as.getDate.value = '${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(as.createList[index]))}';
                        showPasswordDialog(context, '비밀번호', () async{
                          if(_pwcontroller.text =='11'){
                            final url =
                                'https://firebasestorage.googleapis.com/v0/b/academy-957f7.appspot.com/o/12345%2F12345%2F${as.getDocid[index]}.pdf?alt=media&token=5bcde09c-3145-4cdd-bbf8-886299c8a44f';
                            // print('${as.pdfUploadList[index]}');
                            //     'https://firebasestorage.googleapis.com/v0/b/academy-957f7.appspot.com/o/${as.getDocid[index]}.pdf?alt=media&token=c5f13bcc-89be-4fc0-a84e-2a3eb5d27f6a';
                            //     'https://firebasestorage.googleapis.com/v0/b/miocr-82323.appspot.com/o/test.pdf?alt=media&token=0fd055a8-aa9d-41d8-970c-1c882ed6d5dc';
                            final file = await PDFApi.loadNetwork(url);
                            Get.back();
                            Get.to(()=>TestMainScreen(file: file));
                          }else{print('꽝');}},
                            _pwcontroller
                        );
                        print('index : $index');
                      },
                      switchOnTap: (){}, title: '',
                    ),
                    SizedBox(height: 30,),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
