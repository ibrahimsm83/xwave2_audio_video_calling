import 'package:chat_app_with_myysql/widget/common.dart';
import 'package:chat_app_with_myysql/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'paged_view.dart';

class PaginatedListView<T> extends PagedView<T> {

  final Widget Function(BuildContext context,int ind,) separatorBuilder;

  const PaginatedListView({
    Key? key,
    required super.itemBuilder,
    required super.onFetchPage,
    required this.separatorBuilder,
    super.shrinkWrap = false,
    super.onDispose,
    super.initialItems,
    super.physics = const AlwaysScrollableScrollPhysics(),
    super.padding = EdgeInsets.zero,
    super.notFoundWidget,super.initialLoader,
  }) : super(key: key);

  @override
  _PagedListViewState<T> createState() => _PagedListViewState<T>();
}

class _PagedListViewState<T> extends PagedViewState<T> {

  @override
  PaginatedListView get widget => super.widget as PaginatedListView;

  @override
  Widget build(BuildContext context) {
    return PagedListView.separated(
      pagingController: pagingController,
      separatorBuilder: widget.separatorBuilder,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      builderDelegate: PagedChildBuilderDelegate<T>(
          firstPageProgressIndicatorBuilder: (con) {
        return widget.initialLoader??const ContentLoading();
      }, noItemsFoundIndicatorBuilder: (con) {
        return widget.notFoundWidget??const NotFoundText();
      }, itemBuilder: (context, dynamic item, index) {
        return widget.itemBuilder(index, item);
      }),
    );
  }
}
