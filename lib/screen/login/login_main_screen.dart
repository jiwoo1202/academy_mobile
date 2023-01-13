import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/button/main_button.dart';
import '../../components/font/font.dart';
import '../../firebase/firebase_user.dart';
import '../../provider/user_state.dart';
import '../main_screen.dart';
import '../register/register_main_screen.dart';

class LoginMainScreen extends StatefulWidget {
  static final String id = '/login_main';

  const LoginMainScreen({Key? key}) : super(key: key);

  @override
  State<LoginMainScreen> createState() => _LoginMainScreenState();
}

class _LoginMainScreenState extends State<LoginMainScreen>
    with TickerProviderStateMixin {
  late TabController _nestedTabController;
  TextEditingController _studentIdController = TextEditingController();
  TextEditingController _studentPwController = TextEditingController();
  TextEditingController _teacherIdController = TextEditingController();
  TextEditingController _teacherPwController = TextEditingController();
  bool _obscureText = false;
  bool _obscureText2 = false;

  @override
  void initState() {
    _nestedTabController = TabController(length: 2, vsync: this);

    userGet();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
    _studentIdController.dispose();
    _studentPwController.dispose();
    _teacherPwController.dispose();
    _teacherIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final us = Get.put(UserState());
    return GestureDetector(

      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        body: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 41,
              ),
              ColoredBox(
                color: Color(0xffE9E9E9),
                child: TabBar(
                  controller: _nestedTabController,
                  unselectedLabelColor: Color(0xffA0A4A6),
                  indicatorColor: Colors.transparent,
                  indicator: BoxDecoration(color: Colors.white),
                  labelColor: Colors.black,
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        '학생',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NotoSansKr'),
                      ),
                    ),
                    Tab(
                      child: Text(
                        '선생님',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NotoSansKr'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Container(
                constraints: BoxConstraints(minHeight: 200, maxHeight: 200),
                child: TabBarView(controller: _nestedTabController, children: [
                  ///일반 회원
                  Container(
                    child: Column(
                      children: [

                        const SizedBox(
                          height: 20,
                        ),

                        /// ID
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: TextFormField(
                                controller: _studentIdController,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'NotoSansKr',
                                    color: Color(0xff292929)),
                                enabled: true,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueGrey[200]!),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    prefixIconConstraints:
                                        BoxConstraints(minWidth: 23),
                                    hintText: '아이디를 입력해주세요',
                                    hintStyle: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'NotoSansKr',
                                        color: Colors.blueGrey[200])),
                              ),
                              width: MediaQuery.of(context).size.width * 0.9,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),

                        /// Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: TextFormField(
                                controller: _studentPwController,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'NotoSansKr',
                                    color: const Color(0xff292929)),
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.text,
                                obscureText: !_obscureText,
                                enabled: true,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueGrey[200]!),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    prefixIconConstraints:
                                        BoxConstraints(minWidth: 23),
                                    suffixIcon: !_obscureText
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.visibility_off_outlined,
                                              size: 20,
                                            ),
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            color: Colors.black,
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                          )
                                        : IconButton(
                                            icon: Icon(
                                              Icons.visibility_outlined,
                                              size: 20,
                                            ),
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            color: Colors.black,
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                          ),
                                    hintText: '비밀번호를 입력해 주세요',
                                    hintStyle: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'NotoSansKr',
                                        color: Colors.blueGrey[200])),
                              ),
                              width: MediaQuery.of(context).size.width * 0.9,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  ///Teacher
                  Container(
                    child: Column(
                      children: [

                        const SizedBox(
                          height: 20,
                        ),

                        /// ID
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: TextFormField(
                                controller: _teacherIdController,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'NotoSansKr',
                                    color: Color(0xff292929)),
                                enabled: true,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueGrey[200]!),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    prefixIconConstraints:
                                        BoxConstraints(minWidth: 23),
                                    hintText: '아이디를 입력해주세요',
                                    hintStyle: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'NotoSansKr',
                                        color: Colors.blueGrey[200])),
                              ),
                              width: MediaQuery.of(context).size.width * 0.9,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),

                        /// Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: TextFormField(
                                controller: _teacherPwController,
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'NotoSansKr',
                                    color: Color(0xff292929)),
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.text,
                                obscureText: !_obscureText2,
                                enabled: true,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueGrey[200]!),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    prefixIconConstraints:
                                        BoxConstraints(minWidth: 23),
                                    suffixIcon: !_obscureText2
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.visibility_off_outlined,
                                              size: 20,
                                            ),
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            color: Colors.black,
                                            onPressed: () {
                                              setState(() {
                                                _obscureText2 = !_obscureText2;
                                              });
                                            },
                                          )
                                        : IconButton(
                                            icon: Icon(
                                              Icons.visibility_outlined,
                                              size: 20,
                                            ),
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            color: Colors.black,
                                            onPressed: () {
                                              setState(() {
                                                _obscureText2 = !_obscureText2;
                                              });
                                            },
                                          ),
                                    hintText: '비밀번호를 입력해 주세요',
                                    hintStyle: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'NotoSansKr',
                                        color: Colors.blueGrey[200])),
                              ),
                              width: MediaQuery.of(context).size.width * 0.9,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MainButton(
                  onPressed: () async {
                    switch (_nestedTabController.index) {
                      case 0 :
                        us.name.value = 'i am student';
                        Get.toNamed(MainScreen.id);
                        print('go to student');
                        break;
                      case 1 :
                        us.name.value = 'i am teacher';
                        Get.toNamed(MainScreen.id);
                        print('go to teacher');
                        break;
                    }
                  },
                  text: '로그인하기',
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Get.toNamed(RegisterMainScreen.id);
                          },
                          child: Text(
                            '회원가입',
                            style: f14Greyw500,
                            textAlign: TextAlign.center,
                          )),
                    ),
                    VerticalDivider(
                      color: const Color(0xffE9E9E9),
                      thickness: 0.5,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                        },
                        child: Text(
                          '비밀번호 찾기',
                          style: f14Greyw500,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Obx(() => Text(
              //   '${us.count}',
              //   style: TextStyle(color: Colors.black),
              // )),
              //
              // TextButton(
              //   onPressed: () {
              //     us.increase();
              //     us.name.value = 'my name is ipad';
              //   },
              //   child: Text(
              //     'hello',
              //     style: TextStyle(color: Colors.black,fontSize: 24),
              //   ),
              // ),
              //
              // TextButton(
              //   onPressed: () {
              //     Get.toNamed(MainScreen.id);
              //   },
              //   child: Text(
              //     'move',
              //     style: TextStyle(color: Colors.black,fontSize: 24),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
