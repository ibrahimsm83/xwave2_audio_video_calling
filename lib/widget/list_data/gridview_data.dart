import 'package:chat_app_with_myysql/widget/list_data/list_data.dart';
import 'package:flutter/material.dart';

class GridViewDataWidget<T> extends ListDataWidget<T> {
  final int crossAxisCount;
  final double mainAxisSpacing, crossAxisSpacing, childAspectRatio;

  const GridViewDataWidget({
    Key? key,
    required super.list,
    required super.itemBuilder,
    required this.crossAxisCount,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.childAspectRatio = 1.0,
    super.initialLoader,
    super.notFoundWidget,
    super.shrinkWrap = false,
    super.physics = const AlwaysScrollableScrollPhysics(),
    super.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget buildChild(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: mainAxisSpacing,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: childAspectRatio),
        shrinkWrap: shrinkWrap,
        physics: physics,
        padding: padding,
        itemBuilder: (con, ind) {
          return itemBuilder(ind, list![ind]);
        },
        itemCount: list!.length);
  }
}
