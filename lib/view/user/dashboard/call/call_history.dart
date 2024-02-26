import 'package:chat_app_with_myysql/controller/user/call_controller.dart';
import 'package:chat_app_with_myysql/model/voice_call.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/sizer.dart';
import 'package:chat_app_with_myysql/widget/app_bar.dart';
import 'package:chat_app_with_myysql/widget/background.dart';
import 'package:chat_app_with_myysql/widget/call_items.dart';
import 'package:chat_app_with_myysql/widget/list_data/listview_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  State<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> {

  final CallController callController=Get.find<CallController>();

  @override
  void initState() {
    callController.initialLoadCallHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      bgColor: AppColor.appBlack,
      child: Scaffold(
          backgroundColor: AppColor.colorTransparent,
          appBar: DashboardAppbar(text: "Calls"),
          body: Padding(
            padding: EdgeInsets.only(top: AppSizer.getHeight(15)),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColor.colorWhite,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 4,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColor.colorGrey2,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Obx((){
                    final List<VoiceCall>? list= callController.callHistory.value.data;
                    return RefreshIndicator(
                      onRefresh: () async{
                        callController.refreshList();
                      },
                      child: ListViewDataWidget(list:list,
                        itemBuilder: (ind,model){
                          return CallHistoryContainer(call: model,onCallTap: (){
                            callController.audioCall(model.receiver!);
                          },onVideoTap: (){
                            callController.videoCall(model.receiver!);
                          },);
                        },separatorBuilder: (con,ind){
                          return const SizedBox.shrink();
                        },),
                    );
                  }))
                ],
              ),
            ),
          )),
    );
  }
}
