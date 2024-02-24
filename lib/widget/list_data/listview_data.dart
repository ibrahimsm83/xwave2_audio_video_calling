import 'package:chat_app_with_myysql/widget/common.dart';
import 'package:chat_app_with_myysql/widget/list_data/list_data.dart';
import 'package:chat_app_with_myysql/widget/loader.dart';
import 'package:flutter/material.dart';

class ListViewDataWidget<T> extends ListDataWidget<T> {
  final Widget Function(
      BuildContext context,
      int ind,
      ) separatorBuilder;
  const ListViewDataWidget({
    Key? key,
    required super.list,
    required super.itemBuilder,
    super.initialLoader,
    super.notFoundWidget,
    super.shrinkWrap = false,
    super.physics = const AlwaysScrollableScrollPhysics(),
    required this.separatorBuilder,
    super.padding = EdgeInsets.zero,
  }) : super(key: key);


  @override
  Widget buildChild(BuildContext context) {
    return ListView.separated(
        shrinkWrap: shrinkWrap,physics: physics,
        padding: padding,
        itemBuilder: (con, ind) {
          return itemBuilder(ind, list![ind]);
        },
        separatorBuilder: separatorBuilder,
        itemCount: list!.length);
  }

}

