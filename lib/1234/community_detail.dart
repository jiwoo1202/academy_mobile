import 'package:academy/components/font/font.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommunityDetail extends StatefulWidget {
  final String id;
  final String? docId;
  final String who;
  final String title;
  final String body;
  final String hasImage;
  final String createDate;

  final int anonymousCount;
  final int commentCount;

  final bool anonymous;
  // final int current;
  final List image;
  final CarouselController carouselCon;
  final DateTime dateTime;

  const CommunityDetail(
      {Key? key,
      required this.who,
      required this.dateTime,
      required this.hasImage,
      required this.createDate,
      required this.image,
      required this.id,
      required this.carouselCon,
      required this.title,
      required this.body,
      required this.commentCount,
      required this.anonymous,
      required this.anonymousCount,
      this.docId})
      : super(key: key);

  @override
  State<CommunityDetail> createState() => _CommunityDetailState();
}

class _CommunityDetailState extends State<CommunityDetail> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      // key: _refreshIndicatorKey,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async {
        // await _refresh();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.who}',
            style: f32w500,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            int.parse(widget.dateTime
                        .difference(DateTime.parse('${widget.createDate}'))
                        .inMinutes
                        .toString()) <
                    60
                ? '${int.parse(widget.dateTime.difference(DateTime.parse('${widget.createDate}')).inMinutes.toString())}분 전'
                : int.parse(widget.dateTime
                            .difference(DateTime.parse('${widget.createDate}'))
                            .inHours
                            .toString()) <
                        24
                    ? '${int.parse(widget.dateTime.difference(DateTime.parse('${widget.createDate}')).inHours.toString())}시간 전'
                    : '${int.parse(widget.dateTime.difference(DateTime.parse('${widget.createDate}')).inDays.toString())}일 전',
            style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontFamily: 'NotoSansKr'),
          ),
          const SizedBox(
            height: 10,
          ),
          widget.hasImage == 'true'
              ? CarouselSlider(
                  items: [
                    for (int i = 0; i < widget.image.length; i++)
                      'https://firebasestorage.googleapis.com/v0/b/academy-957f7.appspot.com/o/picture%2F${widget.id}%2F${widget.docId}%2F${widget.image[i]}?alt=media'
                    // 'https://firebasestorage.googleapis.com/v0/b/academy-957f7.appspot.com/o/asd.png?alt=media&token=d3708419-809b-4c8e-bd69-bd6bdfa002a6'
                  ]
                      .map((item) => ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            child: InkWell(
                                onTap: () {
                                  // Navigator.of(context).push(
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             clickFullImages(
                                  //                 listImagesModel: [
                                  //                   for (int i = 0;
                                  //                       i <
                                  //                           _myStoryList[0]
                                  //                                   [
                                  //                                   'images']
                                  //                               .length;
                                  //                       i++)
                                  //                     'https://firebasestorage.googleapis.com/v0/b/clicksound-af0c0.appspot.com/o/picture%2F${_myStoryList[0]['createId']}%2F${_myStoryList[0]['id']}%2F${image[i]}?alt=media'
                                  //                 ],
                                  //                 current:
                                  //                     _current)));
                                },
                                child: ExtendedImage.network(
                                  item,
                                  fit: BoxFit.cover,
                                  cache: true,
                                  enableLoadState: false,
                                )),
                          ))
                      .toList(),
                  carouselController: widget.carouselCon,
                  options: CarouselOptions(
                    autoPlay: false,
                    padEnds: false,
                    enlargeCenterPage: false,
                    disableCenter: true,
                    height: MediaQuery.of(context).size.width * 0.9,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      // setState(() {
                      //   widget.current = index;
                      // });
                    },
                  ),
                )
              : Container(),
          const SizedBox(
            height: 20,
          ),
          Text(
            '${widget.title}',
            style: f32w500,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '${widget.body}',
            style: f24w500,
          ),
          Divider(),
          Text(
            '댓글(${widget.commentCount})',
            style: f24w500,
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
