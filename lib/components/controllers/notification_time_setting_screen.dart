import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class NotificationTimeSetting extends StatefulWidget {
  static final String id = '/notification_setting_time';

  const NotificationTimeSetting({Key? key}) : super(key: key);

  @override
  _NotificationTimeSettingState createState() =>
      _NotificationTimeSettingState();
}

class _NotificationTimeSettingState extends State<NotificationTimeSetting> {
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    _dateTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xff6f7072),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '알람설정',
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontFamily: 'NotoSansKr'),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Color(0xfff3f5f9),
              ),
              child: TimePickerSpinner(
                is24HourMode: true,
                normalTextStyle: TextStyle(
                    fontSize: 30,
                    color: Color(0xff6f7072).withOpacity(0.7),
                    fontFamily: 'NotoSansKr'),
                highlightedTextStyle: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                    fontFamily: 'NotoSansKr'),
                spacing: 50,
                itemHeight: 80,
                isForce2Digits: true,
                onTimeChange: (time) {
                  setState(() {
                    _dateTime = time;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
