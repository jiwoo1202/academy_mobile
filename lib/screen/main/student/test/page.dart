import 'package:academy/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';



class ScrollTestPage extends StatefulWidget {
  const ScrollTestPage({Key? key}) : super(key: key);

  @override
  State<ScrollTestPage> createState() => _ScrollTestPageState();
}

class _ScrollTestPageState extends State<ScrollTestPage> {
  final controller = PageController();
  int _pageIndex = 0;
  List<String> number = ['1', '2', '3', '4', '5'];
  List<String> _answer = ['','',''];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('테스트'),
        centerTitle: true,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                '나가기',
                style: TextStyle(color: Colors.black),
              ))
        ],
      ),
      body: PageView.builder(
        controller: controller,
        itemCount: 3,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.only(
                top: 32,right: 24,left: 24
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text('문제\t1/20'),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 10,
                        percent: 0.1, // 리스트 별로
                        animation: true,
                        barRadius: Radius.circular(10),
                        progressColor: nowColor,
                      ),
                    )
                  ],
                ),
                Spacer(),
                Text('정답'),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: 60,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: number.map((number) {
                        return Column(
                          children: [
                            Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    _answer[index] = number;
                                    setState(() {});
                                  },
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    side: BorderSide(width: 1,color: Colors.grey),
                                    minimumSize: Size(52, 52),
                                    foregroundColor: Colors.black,
                                    backgroundColor: _answer[index]==number?nowColor:buttonTextColor,
                                    padding: EdgeInsets.only(right: 12, left: 12),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    '$number',
                                    style: TextStyle(
                                      color: _answer[index] == number
                                          ? buttonTextColor
                                          : blackTextColor,
                                    )
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                            ),
                          ],
                        );
                      }).toList(),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
