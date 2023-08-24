import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../components/dialog/showAlertDialog.dart';
import '../../provider/user_state.dart';
import '../../util/colors.dart';
import '../../util/font/font.dart';
import 'job/job_hunting_screen.dart';
import 'notice/notice_main_screen.dart';
import 'story/story_main_screen.dart';

class CommunityMainScreen extends StatefulWidget {
  static final String id = '/community_main';

  const CommunityMainScreen({Key? key}) : super(key: key);

  @override
  State<CommunityMainScreen> createState() => _CommunityMainScreenState();
}

class _CommunityMainScreenState extends State<CommunityMainScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool fixedScroll = false;

  // ScrollController _scrollController = ScrollController();
  bool _showbtn = false;
  List<Widget> _widgetOptions = [];
  int _currentIndex = 0;

  @override
  void initState() {
    final us = Get.put(UserState());
    _widgetOptions = us.userList[0].userType == '학생'
        ? [StoryMainScreen(), NoticeMainScreen()]
        : [StoryMainScreen(), JobHuntingScreen(), NoticeMainScreen()];
    _tabController = TabController(
        length: us.userList[0].userType == '학생' ? 2 : 3, vsync: this);
    _tabController.addListener(_smoothScrollToTop);

    // _scrollController.addListener(() {
    //   //scroll listener
    //   double showoffset = 10.0;
    //   if (_scrollController.offset > showoffset) {
    //     _showbtn = true;
    //     setState(() {
    //       //update state
    //     });
    //   } else {
    //     _showbtn = false;
    //     setState(() {
    //       //update state
    //     });
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  _smoothScrollToTop() {
    setState(() {
      fixedScroll = _tabController.index == 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final us = Get.put(UserState());

    return WillPopScope(
      onWillPop: () {
        return onTerminated(context);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, 80),
          child: TabBar(
              padding: const EdgeInsets.only(top: 60),
              onTap: (idx) {
                setState(() {
                  _currentIndex = idx;
                });
                // print('idx : ${_tabController.index}');
              },
              isScrollable: false,
              controller: _tabController,
              indicatorWeight: 10,
              indicatorSize: TabBarIndicatorSize.tab,
              overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
              unselectedLabelColor: blurColor,
              indicatorColor: nowColor,
              labelStyle: f16w700,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: nowColor,
                    width: 3.0,
                  ),
                ),
              ),
              labelColor: blackTextColor,
              tabs: us.userList[0].userType == '학생'
                  ? [
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '이야기',
                            style: _tabController.index == 1
                                ? f16w700greyA
                                : f16w700,
                          ),
                        ),
                      ),
                      Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            '공지사항',
                            style: _tabController.index == 0
                                ? f16w700greyA
                                : f16w700,
                          ),
                        ),
                      ),
                    ]
                  : [
                      Tab(
                        child: const Align(
                          alignment: Alignment.center,
                          child: const Text(
                            '이야기',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Pretendard'),
                          ),
                        ),
                      ),
                      Tab(
                        child: const Align(
                          alignment: Alignment.center,
                          child: const Text(
                            '구인구직',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Pretendard'),
                          ),
                        ),
                      ),
                      Tab(
                        child: const Align(
                          alignment: Alignment.center,
                          child: const Text(
                            '공지사항',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Pretendard'),
                          ),
                        ),
                      ),
                    ]),
        ),
        body: TabBarView(controller: _tabController, children: _widgetOptions),
      ),
    );
  }

  Future<bool> onTerminated(BuildContext context) async {
    return showComponentDialog(context, '앱을 종료하시겠습니까?', () {
      SystemNavigator.pop();
    });
  }
}
