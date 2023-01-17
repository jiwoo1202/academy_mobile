import 'package:academy/components/dialog/showAlertDialog.dart';
import 'package:academy/components/font/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../api/pdf/pdf_api.dart';
import '../../../components/tile/main_tile.dart';
import '../main_search_screen.dart';
import 'test/test_main_screen.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: Get.width*0.2, vertical: 30),
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
                        SizedBox(width: 50,),
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
              SizedBox(height: 40,),
              //조건 비어있으면 Text or 카드 있으면 카드 ListView 부르기
              // false ?
              // Text('선생님 이름 혹은\n코드를 검색해주세요', style: TextStyle(fontSize: 20),):
              ListView.builder(
                itemCount: 4,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      MainTile(
                        isOpened: true,
                        isStudent: true,
                        subject: '사회',
                        tName: '가나다',
                        onTap: ()async{
                          showPasswordDialog(context, '비밀번호', () async{
                            final url =
                                'https://firebasestorage.googleapis.com/v0/b/academy-957f7.appspot.com/o/%E1%84%89%E1%85%B5%E1%84%92%E1%85%A5%E1%86%B7%E1%84%8C%E1%85%A5%E1%86%BC%E1%84%83%E1%85%A1%E1%86%B8.pdf?alt=media&token=c5f13bcc-89be-4fc0-a84e-2a3eb5d27f6a';
                                // 'https://firebasestorage.googleapis.com/v0/b/miocr-82323.appspot.com/o/test.pdf?alt=media&token=0fd055a8-aa9d-41d8-970c-1c882ed6d5dc';
                            final file = await PDFApi.loadNetwork(url);
                            Get.back();
                            Get.to(()=>TestMainScreen(file: file));
                          });

                          print('index : $index');
                        },
                        switchOnTap: (){},
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
