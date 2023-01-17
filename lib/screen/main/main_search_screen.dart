import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../util/loading.dart';
import '../../provider/user_state.dart';

class MainSearchScreen extends StatefulWidget {
  static final String id = '/drug_search_screen';

  const MainSearchScreen({Key? key}) : super(key: key);

  @override
  _MainSearchScreenState createState() => _MainSearchScreenState();
}

class _MainSearchScreenState extends State<MainSearchScreen> {
  List<Padding> lstResultItem = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final us = Get.put(UserState());
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
              child: Container(
                  height: 46,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 2), // changes position of shadow
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('', //pp.DrugSearchKeyword
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'NotoSansKr')),
                      SvgPicture.asset(
                        'assets/icon/search_drug_icon.svg',
                        fit: BoxFit.fill,
                        width: 24,
                        height: 24,
                      )
                    ],
                  )),
              onTap: () {
                showSearch(
                    context: context,
                    delegate: DrugSearch(),
                    query: us.searchText.toString()) //pp.DrugSearchKeyword
                    .then((value) async {
                  if (value != '') {
                    setState(() {
                      _isLoading = true;
                    });
                    // var url =
                    //     'http://apis.data.go.kr/1471000/DrugPrdtPrmsnInfoService02/getDrugPrdtPrmsnDtlInq01';
                    // url +=
                    // '?serviceKey=xrs4Sy2ofXtl0sdlhAXrMqesjtfXJ%2F7y%2BNjADRfhMkkNjENWNSw6Bmw6yFEIX3vRcWaUp8tseJdh0STV4vRRyA%3D%3D';
                    // url += '&item_name=' + value;
                    // url += '&numOfRows=100';
                    // url += '&type=json';
                    //
                    // var res = await http.get(Uri.parse(url));
                    // var resJson = json.decode(res.body);
                    // var items = resJson['body']['items'];
                    // lstResultItem = [];
                    // if (items != null) {
                    //   for (int i = 0; i < items.length; i++) {
                    //     var item = items[i];
                    //     String itemName = item['ITEM_NAME'].split('(')[0];
                    //     String company = item['ENTP_NAME'];
                    //     // String content = item['TOTAL_CONTENT'];
                    //     lstResultItem
                    //         .add(createDrugItem(context, itemName + ' ', company));
                    //   }
                    // }
                    // setState(() {
                    //   _isLoading = false;
                    // });
                  }
                });
              }),
          toolbarHeight: 78,
          leadingWidth: 0,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: _isLoading
                ? LoadingBodyScreen()
                : SingleChildScrollView(
                child: Column(children: lstResultItem))));
  }

  Padding createDrugItem(context, title, description) {
    return Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context, title);
          },
          child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 46,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: Colors.grey.withOpacity(0.5)))),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text: TextSpan(
                            text: title,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)))
                  ])),
        ));
  }
}

class DrugSearch extends SearchDelegate {
  //  로컬에 저장된 최근 검색한 약 목록 넣기
  List<String> searchTerms = [];
  var bVisible = false;
  var prefs;
  var lstSearchResult = [];

  // DrugSearch() {
  //   initSharedPreferences();
  // }

  // initSharedPreferences() async {
  //   prefs = await SharedPreferences.getInstance();
  //   var lstSearch = prefs.getStringList('search_list');
  //   if (lstSearch != null) {
  //     var length = lstSearch.length;
  //     for(var i=0; i<length; i++) {
  //       var search = jsonDecode(lstSearch[i]);
  //       var keyword = search['keyword'];
  //       var time = DateTime.parse(search['time']);
  //       var deleteData = DateTime.now();
  //       if(deleteData.difference(time).inDays > 30) {
  //         continue;
  //       }
  //       searchTerms.add(jsonEncode({'keyword': keyword, 'time': time.toString()}));
  //     }
  //   }
  // }

  @override
  String get searchFieldLabel => '선생님 혹은 코드를 검색해주세요';

  @override
  TextStyle get searchFieldStyle =>
      TextStyle(fontSize: 14.0, fontFamily: 'NotoSansKr');

  // 검색창 서치 버튼
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        return Visibility(
            visible: bVisible,
            child: IconButton(
                onPressed: () async {
                  query = '';
                  setState(() {
                    bVisible = false;
                  });
                },
                icon: SvgPicture.asset(
                  'assets/icon/cancel_drug_icon.svg',
                  fit: BoxFit.fill,
                  width: 20,
                  height: 20,
                )));
      }),
      IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () async {
            getDrugSearch(context);
          },
          icon: SvgPicture.asset(
            'assets/icon/search_drug_icon.svg',
            fit: BoxFit.fill,
            width: 24,
            height: 24,
          ))
    ];
  }

  // 검색창 리딩 버튼
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {
          close(context, '');
        },
        icon: SvgPicture.asset(
          'assets/icon/search_drug_logo.svg',
          fit: BoxFit.fill,
          width: 24,
          height: 24,
        ));
  }

  // 검색어 입력 시 하위 검색 결과
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    // for (var search in searchTerms) {
    //   var fruit = jsonDecode(search)['keyword'];
    //   if (fruit.toLowerCase().contains(query.toLowerCase())) {
    //     // print('m: ${matchQuery.contains(query.toLowerCase())} , ${query.toLowerCase()}');
    //     matchQuery.add(fruit);
    //   }
    // }
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 40,
              child: Text(matchQuery.length > 0 ? '최근 검색한 선생님 혹은 코드' : '최근 검색이 없습니다',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'NotoSansKr',
                      fontWeight: FontWeight.w500))),
          Expanded(
            child: ListView.builder(
                itemCount: matchQuery.length,
                itemBuilder: (context, index) {
                  var result = matchQuery[matchQuery.length - 1 - index];
                  return Container(
                      height: 34,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.07),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                child: Text(result,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'NotoSansKr',
                                        fontWeight: FontWeight.w500)),
                                onTap: () {
                                  query = result;
                                }),
                            GestureDetector(
                              child: SvgPicture.asset(
                                'assets/icon/cancel_black_icon.svg',
                                fit: BoxFit.fill,
                                width: 24,
                                height: 24,
                              ),
                              onTap: () {
                                print('query: ' + query);
                                // for(var i=0; i<searchTerms.length; i++) {
                                //   var search = jsonDecode(searchTerms[i]);
                                //   if(search['keyword'] == query) {
                                //     searchTerms.remove(search);
                                //     prefs.remove('search_list');
                                //     prefs.setStringList('search_list', searchTerms);
                                //     break;
                                //   }
                                // }
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                            )
                          ]));
                }),
          )
        ]));
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.length > 0) {
      bVisible = true;
    } else {
      bVisible = false;
    }
    List<String> matchQuery = [];
    // for (var search in searchTerms) {
    //   var fruit = jsonDecode(search)['keyword'];
    //   if (fruit.toLowerCase().contains(query.toLowerCase())) {
    //     if(matchQuery.contains(fruit.toLowerCase()) == false) {
    //       matchQuery.add(fruit);
    //     }
    //   }
    // }
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width * 0.9,
              height: 40,
              child: Text(matchQuery.length > 0 ? '최근 검색한 약' : '최근 검색한 약이 없습니다',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'NotoSansKr',
                      fontWeight: FontWeight.w500))),
          Expanded(
            child: ListView.builder(
                itemCount: matchQuery.length,
                itemBuilder: (context, index) {
                  var result = matchQuery[matchQuery.length - 1 - index];
                  return Container(
                      height: 34,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.07),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                child: Text(result,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'NotoSansKr',
                                        fontWeight: FontWeight.w500)),
                                onTap: () {
                                  query = result;
                                }),
                            GestureDetector(
                              child: SvgPicture.asset(
                                'assets/icon/cancel_black_icon.svg',
                                fit: BoxFit.fill,
                                width: 24,
                                height: 24,
                              ),
                              onTap: () {
                                print('query: ' + result);
                                // for(var i=0; i<searchTerms.length; i++) {
                                //   var search = jsonDecode(searchTerms[i]);
                                //   if(search['keyword'] == result) {
                                //     searchTerms.remove(jsonEncode(search));
                                //     prefs.remove('search_list');
                                //     prefs.setStringList('search_list', searchTerms);
                                //     break;
                                //   }
                                // }
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                            )
                          ]));
                }),
          )
        ]));
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        appBarTheme: AppBarTheme(
            color: Colors.white,
            toolbarHeight: 47,
            elevation: 5,
            shadowColor: Color(0xff558299),
            titleSpacing: 0),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
        ),
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.grey));
  }

  Future getDrugSearch(context) async {
    if (query == '') {
      return;
    }
    final us = Get.put(UserState());
    //  검색 결과 로컬 저장하고 searchTerms 담기
    us.searchText.value = query;
    // if (!searchTerms.contains(query)) {
    //   if(searchTerms.length == 5) {
    //     searchTerms.removeAt(0);
    //   }
    //   searchTerms.add(jsonEncode({'keyword': query, 'time': DateTime.now().toString()}));
    //   prefs.remove('search_list');
    //   prefs.setStringList('search_list', searchTerms);
    // }

    close(context, query);
  }

  @override
  void showResults(BuildContext context) {
    getDrugSearch(context);
  }
}