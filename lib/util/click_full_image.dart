import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ClickFullImage extends StatefulWidget {
  final List listImagesModel;
  final int current;

  const ClickFullImage({Key? key, required this.listImagesModel, required this.current}) : super(key: key);

  @override
  _ClickFullImageState createState() => _ClickFullImageState();
}

class _ClickFullImageState extends State<ClickFullImage> {
  int _current = 0;
  bool _stateChange = false;

  @override
  void initState() {
    super.initState();
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    _current = (_stateChange == false) ? widget.current : _current;
    return new Container(
        color: Colors.transparent,
        child: new Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(
                        autoPlay: false,
                        height: MediaQuery.of(context).size.height / 1.3,
                        viewportFraction: 1.0,
                        onPageChanged: (index, data) {
                          setState(() {
                            _stateChange = true;
                            _current = index;
                          });
                        },
                        initialPage: widget.current),
                    items: map<Widget>(widget.listImagesModel, (index, url) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '${_current+1}/${widget.listImagesModel.length}',
                              style: TextStyle(color: Colors.white,fontSize: 16,height: 1),
                            ),
                            SizedBox(height: 12,),
                            Expanded(
                              child: Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                                  child: ExtendedImage.network(
                                    url,
                                    fit: BoxFit.cover,
                                    cache: false,
                                    enableLoadState: false,
                                  ),
                                ),
                              ),
                            )
                          ]);
                    }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: map<Widget>(widget.listImagesModel, (index, url) {
                      return Container(
                        width: 10.0,
                        height: 9.0,
                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (_current == index) ? Colors.white : Colors.white.withOpacity(0.3),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            )));
  }
}
