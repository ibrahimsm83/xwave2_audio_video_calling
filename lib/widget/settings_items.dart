import 'package:chat_app_with_myysql/util/sizer.dart';
import 'package:chat_app_with_myysql/widget/myBtn.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:flutter/material.dart';

class SettingContainer extends StatelessWidget {
  final String text1, text2;
  final void Function()? onTap;
  const SettingContainer({Key? key, required this.text1, this.text2 = "",
    this.onTap,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizer.getWidth(15),
              vertical: AppSizer.getHeight(10)),
          child: Row(
            children: [
              CircularButton(diameter: AppSizer.getHeight(35), icon: ""),
              SizedBox(width: AppSizer.getWidth(10),),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                CustomText(text: text1,fontweight: FontWeight.w600,)
              ],))
            ],
          ),
        ),
      ),
    );
  }
}
