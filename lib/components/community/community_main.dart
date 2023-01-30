import 'package:flutter/material.dart';

class CommunityMain extends StatelessWidget {
  final String title;
  final String detail1;
  final String detail2;
  final String detail3;
  final VoidCallback ontap;
  const CommunityMain({Key? key, required this.ontap, required this.title, required this.detail1, required this.detail2, required this.detail3}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(60, 50, 0, 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title,style: TextStyle(fontSize: 20),),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.5,
              ),
              TextButton(onPressed: ontap,
                  child: Text('더보기'))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(detail1),
          SizedBox(
            height: 20,
          ),
          Text(detail2),
          SizedBox(
            height: 20,
          ),
          Text(detail3)
        ],
      ),
    );
  }
}
