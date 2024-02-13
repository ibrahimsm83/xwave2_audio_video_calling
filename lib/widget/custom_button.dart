
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  String? text;
  FontWeight? fontWeight;
  final Color? color;
  Function()? onTap;
  TextStyle? style;

  CustomButton(
      {Key? key,
        this.onTap,
        this.text,
        this.style,
        this.fontWeight = FontWeight.normal,
        this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                text!,
                style: style,
                // TextStyle(color: AppColors.whiteColor, fontWeight: fontWeight),
              ),
            )),
      ),
    );
  }
}