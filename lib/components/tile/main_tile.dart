import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainTile extends StatelessWidget {
  final tName;
  final tCreateDate;
  const MainTile({Key? key, this.tName:'박보검', this.tCreateDate:'2023-01-16 12:30'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container( width: Get.width,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.black,
        ),
      ),
      child: Column(
        children: [
          //Row(text 버튼(공개,비공개,대기)
          Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${tName} 선생님\n ${tCreateDate}', textAlign: TextAlign.center,),
              SizedBox(width: 50,),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff558E99),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '공개',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'NotoSansKr',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              )
          ],),
          Divider(height: 1, color: Colors.black,),

          TextButton (onPressed: () {  }, child: Text('시험 보기', style: TextStyle(color: Colors.black),),)
        ],
      ),
    );
  }
}
