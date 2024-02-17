import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/sizer.dart';
import 'package:chat_app_with_myysql/widget/icons.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:flutter/material.dart';

class PopupNavigation extends StatelessWidget {
  final List<PopupNavigationItem> items;
  final ResizableIcon icon;
  final Color popupBgColor;
  const PopupNavigation({Key? key,required this.items,
    this.popupBgColor=AppColor.colorWhite,
    required this.icon,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PopupMenuButton<PopupNavigationItem>(
        iconSize: icon.getIconSize,
        // padding: EdgeInsets.all(100),
        color: popupBgColor,offset: Offset.zero,
        //    constraints: BoxConstraints.expand(width: 1,height: 1),
        // offset: Offset(0,icon.getIconSize+20),
        icon: getIcon(),//enabled: true,
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        onSelected: (item){
          /*print("onTapped $item");
          if(item is HomeNavigationItem){
            print("onTapped");
            item.onTap!();
          }*/
        },
        itemBuilder: (con){
          return items.map((widget){
            return PopupMenuItem<PopupNavigationItem>(
                height: 0,padding: EdgeInsets.zero,
                child: widget);
          }).toList();
        },),
    );
  }

  Widget getIcon(){
    return icon;
  }

  double get radius=>10;
}

class PopupNavigationItem extends StatelessWidget {

  final String title;
//  final String? icon;
  final void Function()? onTap;
  final Color textColor;
  const PopupNavigationItem({Key? key,required this.title,this.onTap,
    this.textColor=AppColor.colorWhite,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(color: AppColor.colorTransparent,
      padding: EdgeInsets.symmetric(horizontal:AppSizer.getWidth(10),
          vertical: AppSizer.getHeight(10)),
      child: Row(children: [
        //getIcon(),
        Expanded(child: CustomText(text: title,fontweight: FontWeight.w500,
          fontcolor: textColor,fontsize: 13,)),
      ],),);
  }

/*  Widget getIcon(){
    const double img_width=20;
    return Padding(padding: const EdgeInsets.only(right: 10),
      child: Container(
        width: img_width,height: img_width,
        child: Image.asset(icon!),),
    );
  }*/

}