import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SwitchButton extends StatefulWidget {
  final bool value;
  final VoidCallback onTap;

  const SwitchButton({Key? key, this.value: false, required this.onTap}) : super(key: key);

  @override
  _SwitchButtonState createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  final animationDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        height: 40,
        width: 70,
        duration: animationDuration,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: widget.value ? Color(0xff558E99) : Color(0xffBFBFBF),
          border: Border.all(color: Colors.white, width: 2),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.shade400,
          //     spreadRadius: 2,
          //     blurRadius: 10,
          //   ),
          // ],
        ),
        child: AnimatedAlign(
          duration: animationDuration,
          alignment: widget.value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2,vertical: 4),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                widget.value
                    ? SvgPicture.asset(
                  'assets/icon/check_icon.svg',
                  width: 10,
                  height: 10,
                  fit: BoxFit.fill,
                )
                    : SvgPicture.asset(
                  'assets/icon/x_icon.svg',
                  width: 10,
                  height: 10,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
