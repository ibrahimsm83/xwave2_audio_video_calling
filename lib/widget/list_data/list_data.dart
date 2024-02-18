import 'package:chat_app_with_myysql/widget/common.dart';
import 'package:chat_app_with_myysql/widget/loader.dart';
import 'package:flutter/material.dart';

abstract class ListDataWidget<T> extends StatelessWidget {
  final List<T>? list;
  final Widget Function(int ind, T item) itemBuilder;
/*  final Widget Function(
      BuildContext context,
      int ind,
      ) separatorBuilder;*/
  final EdgeInsets padding;
  final Widget? initialLoader, notFoundWidget;
  final bool shrinkWrap;
  final ScrollPhysics physics;
  const ListDataWidget({
    Key? key,
    required this.list,
    required this.itemBuilder,
    this.initialLoader,
    this.notFoundWidget,
    this.shrinkWrap = false,
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (con, cons) {
        var size = cons.biggest;
        print("list size: $size ${size.height==double.infinity}");
        return list != null
            ? (list!.isNotEmpty
            ? buildChild(context)
            : buildScroll(size,notFoundWidget??const NotFoundText()))
            : buildScroll(size, initialLoader??const ContentLoading());
      },
    );
  }

  Widget buildChild(BuildContext context);

  Widget buildScroll(Size size,Widget widget){
    return !shrinkWrap?SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(height: size.height,
        child: widget,),):widget;
  }
}

