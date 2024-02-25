import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final Widget child;
  final bool safe;
  final Color bgColor;
  final String? bgImage;
  const CustomBackground(
      {Key? key,
      required this.child,
      this.safe = true,
      this.bgImage,
      this.bgColor = AppColor.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: AppColor.COLOR_GREY1,
      decoration: BoxDecoration(
          color: bgColor,
          image: bgImage != null
              ? DecorationImage(image: AssetImage(bgImage!))
              : null),
      child: SafeArea(
        child: child,
        bottom: safe,
      ),
    );
  }
}
