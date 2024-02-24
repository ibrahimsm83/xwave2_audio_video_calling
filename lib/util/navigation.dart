import 'package:chat_app_with_myysql/resources/integer.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/widget/popup_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppNavigator{

  static void navigateTo(Widget widget,{Transition transition=Transition.native,
    int duration=AppInteger.STANDARD_DURATION_MILLI}){
    Get.to(widget,transition: transition,
        duration: Duration(milliseconds: duration),preventDuplicates: false);
  }

  static void popUntil(String route,){
    Navigator.popUntil(Get.context!,
        ModalRoute.withName(route));
    print("current route to ${Get.currentRoute}");
  }

  static void navigateToReplace(Widget Function() navigate,{Transition transition=Transition.native,
    int duration=AppInteger.STANDARD_DURATION_MILLI}){
    Get.off(navigate,transition: transition,duration: Duration(milliseconds: duration));
  }
  static void navigateToReplaceAll(Widget Function() navigate,{Transition transition=Transition.native,
    int duration=AppInteger.STANDARD_DURATION_MILLI}){
    Get.offAll(navigate,transition: transition,duration: Duration(milliseconds: duration));
  }

  static void pop(){
    Get.back();
  }

}

class AppDialog {

  static Future<T?> showDialog<T>(Widget widget, {bool disable_back = false,
    bool barrierDismissible=false,bool scrollable=true,bool backDrop=true}) {
    return Get.generalDialog(
        barrierDismissible: barrierDismissible,
        // barrierLabel: barrierDismissible?"aaaaa":null,
        barrierColor: backDrop==true?const Color(0x88000000,):AppColor.colorTransparent,
        transitionDuration: const Duration(milliseconds: AppInteger.STANDARD_DURATION_MILLI),

        pageBuilder: (context, anim1, anim2) {
          return widget;
        }, transitionBuilder: (context, anim1, anim2, child) {
      return ScaleTransition(
        scale: anim1, child: Opacity(
        opacity: anim1.value,
        child: WillPopScope(
          onWillPop: () async {
            return disable_back;
          },
          child: SafeArea(
            child: AlertDialog(
              scrollable: scrollable,
              backgroundColor: AppColor.colorTransparent,
              contentPadding: EdgeInsets.zero,
              insetPadding: EdgeInsets.zero,
              /*   shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(radius),
                        topRight: Radius.circular(radius),)
                  ),*/
              //useMaterialBorderRadius: true,
              //  title: Center(child: VariableText(text:"Payment",weight: FontWeight.bold,),),
              content: child,
            ),
          ),
        ),
      ),);
    });
    // Get.dialog(widget)
  }


  static Future<T?> showPlainDialog<T>(Widget widget, {bool disable_back = false,bool backDrop=true,}) {
    return Get.generalDialog(
        barrierDismissible: false,
        barrierColor: backDrop?const Color(0x88000000,):AppColor.colorTransparent,
        transitionDuration: const Duration(milliseconds: AppInteger.STANDARD_DURATION_MILLI),
        pageBuilder: (context, anim1, anim2) {
          return Center(
            child: Material(
                color: AppColor.colorTransparent,
                child: widget),
          );
        }, transitionBuilder: (context, anim1, anim2, child) {
      return ScaleTransition(
        scale: anim1, child: Opacity(
        opacity: anim1.value,
        child: WillPopScope(
          onWillPop: () async {
            return disable_back;
          },
          child: SafeArea(
            child: child,
          ),
        ),
      ),);
    });
    // Get.dialog(widget)
  }

  static Future<T?> showBottomPanel<T>(
      BuildContext context,
      Widget widget,{final bool isDismissible=true,}
      ) {
    var media = MediaQuery.of(Get.context!);
    return showModalBottomSheet<T>(
        context: context,
        backgroundColor: AppColor.colorTransparent,
        enableDrag: false,isDismissible: isDismissible,
        isScrollControlled: true,
        useSafeArea: false,
        elevation: 0,
        //constraints: BoxConstraints.tight(Size.fromHeight(AppSizer.getPerHeight(1))),
        builder: (con) {
          return Padding(
            padding: EdgeInsets.only(top: media.viewPadding.top),
            child: Container(child: widget),
          );
        });
  }

}

class AppOverlay{


  static OverlayEntry? _entry;

  static void showPopupMenu(BuildContext context,
      {required List<PopupNavigationItem> items,
        required void Function(PopupNavigationItem item) onSelect,
        Color bgColor=AppColor.colorBlack}){
    var offset=Offset.zero;
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    showMenu<PopupNavigationItem>(context: context, position: position,
      color: bgColor,
      items: items.map((widget) {
        return PopupMenuItem<PopupNavigationItem>(
            height: 0,value: widget,
            padding: EdgeInsets.zero,
            child: widget);
      }).toList(),).then((value) {
      print("value is: $value");
      if(value!=null){
        onSelect.call(value);
      }

    });
  }

  static Offset getGlobalTapPosition(BuildContext context){
    var offset=Offset.zero;
    var renderBox = context.findRenderObject();
    if(renderBox is RenderBox) {
      var size = renderBox.size;
      offset = renderBox.localToGlobal(Offset.zero);
    }
    return offset;
  }

  static OverlayEntry? showOverlay(BuildContext context,Widget widget,{Offset? position}){
    if(_entry==null) {
      var entry = OverlayEntry(builder: (con) {
        return GestureDetector(
          onTap: (){
            dissmissOverlay();
          },
          child: Container(
            color: Colors.transparent,
            child: Stack(children: [
              position != null ? Positioned(
                  top: position.dy, left: position.dx,
                  child: widget) : Center(child: widget,)
            ],),
          ),
        );


      });
      var overlay = Overlay.of(context);
      overlay.insert(entry);
      _entry = entry;
      return _entry;
    }
  }

  static void dissmissOverlay(){
    if(_entry!=null) {
      _entry!.remove();
      _entry=null;
    }
  }
}