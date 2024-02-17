import 'package:chat_app_with_myysql/util/navigation.dart';
import 'package:chat_app_with_myysql/widget/popup_navigation.dart';
import 'package:flutter/material.dart';

class CommonMethods{
  static void showBottomOptions(BuildContext context,{required String title,
    required List<PopupNavigationItem> options}){

    AppOverlay.showPopupMenu(context,items:options,onSelect: (item){
      item.onTap?.call();
    });

  }
}