import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingBodyScreen extends StatelessWidget {
  const LoadingBodyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child:  LoadingAnimationWidget.discreteCircle(
        color: Color(0xffD0EFB1),
        size: 50,
        secondRingColor: Color(0xffB3D89C),
        thirdRingColor:Color(0xff9DC3C2),),
    );
  }
}
