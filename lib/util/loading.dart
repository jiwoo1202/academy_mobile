import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'colors.dart';

class LoadingBodyScreen extends StatelessWidget {
  const LoadingBodyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child:  LoadingAnimationWidget.halfTriangleDot(
        color: nowColor,
        size: 50,
    ));
  }
}
