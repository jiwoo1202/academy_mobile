import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../util/font/font.dart';
import '../switch/switch_button.dart';

class TextFormFields extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final String hintText;
  final bool? enableTrue;
  final VoidCallback? onTap;
  final VoidCallback? textOnTap;
  final String? surffixIcon; //0 없음, 1 눈 아이콘, 2 등록
  final TextInputType? keyboardType;
  final int? maxLength;
  const TextFormFields(
      {Key? key,
        required this.controller,
        this.onChanged,
        required this.obscureText,
        this.inputFormatters,
        required this.hintText,
        this.onTap,
        required this.surffixIcon,
        this.textOnTap, this.keyboardType, this.enableTrue,this.maxLength,

      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Color(0xffEBEBEB),
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        obscureText: !obscureText,
        keyboardType: keyboardType,
        style: f16w400,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          isDense: true,
          counterText: "",
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          border: InputBorder.none,
          suffixIcon: surffixIcon == '1'
              ? !obscureText
                  ? IconButton(
                      icon: SvgPicture.asset('assets/icon/visiual.svg'),
                      color: Colors.black,
                      onPressed: onTap,
                    )
                  : IconButton(
                      icon: SvgPicture.asset('assets/icon/visiualOff.svg'),
                      color: Colors.black,
                      onPressed: onTap,
                    )
              : surffixIcon == '2'
                  ? TextButton(
                      onPressed: textOnTap,
                      child: Text(
                        '등록',
                        style: f16w700primary,
                      ))
                  : null,
          hintText: hintText,
          hintStyle: f16w400grey8,
        ),
      ),
    );
  }
}
