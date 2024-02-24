import 'package:chat_app_with_myysql/controller/user/call_controller.dart';
import 'package:chat_app_with_myysql/controller/user/contact_controller.dart';
import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/resources/asset_path.dart';
import 'package:chat_app_with_myysql/resources/dimen.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/navigation.dart';
import 'package:chat_app_with_myysql/util/sizer.dart';
import 'package:chat_app_with_myysql/widget/bottom_sheet.dart';
import 'package:chat_app_with_myysql/widget/call_items.dart';
import 'package:chat_app_with_myysql/widget/custom_button.dart';
import 'package:chat_app_with_myysql/widget/icons.dart';
import 'package:chat_app_with_myysql/widget/list_data/gridview_data.dart';
import 'package:chat_app_with_myysql/widget/myBtn.dart';
import 'package:chat_app_with_myysql/widget/myText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddParticipantsSheet extends StatefulWidget {
  const AddParticipantsSheet({Key? key}) : super(key: key);

  @override
  State<AddParticipantsSheet> createState() => _AddParticipantsSheetState();
}

class _AddParticipantsSheetState extends State<AddParticipantsSheet> {
  final Set<String> participants = {};

  final ContactController contactController = Get.find<ContactController>();

  final CallController callController=Get.find<CallController>();

  @override
  void initState() {
    contactController.initialLoadApiContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.colorBlack,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildHeader(),
          SizedBox(
            height: AppSizer.getHeight(30),
          ),
          Obx(() {
            final List<User_model>? list = contactController.users.value.data;
            return GridViewDataWidget<User_model>(
                shrinkWrap: true,
                list: list,
                itemBuilder: (ind, item) {
                  return UserGroupContainer(
                    user: item,
                    selected: participants.contains(item.id),
                    onTap: () {
                      addRemovePart(item.id);
                    },
                  );
                },
                crossAxisCount: 4);
          }),
/*      Flexible(
        child: Obx(
          () {
            final List<User_model>? list=contactController.users.value.data;
            return GridViewDataWidget<User_model>(
                shrinkWrap: true,
                list: list, itemBuilder: (ind,item){
              return UserGroupContainer(user: item,);
            }, crossAxisCount: 4);
          }
        ),
      )*/
        ],
      ),
    );
  }

  void addRemovePart(String id) {
    setState(() {
      if (participants.contains(id)) {
        participants.remove(id);
      } else {
        participants.add(id);
      }
    });
  }

  Widget buildHeader() {
    final double iconsize = AppSizer.getHeight(8);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizer.getWidth(10)),
      child: Row(
        children: [
          CustomIconButton(
              onTap: () {
                AppNavigator.pop();
              },
              icon: CustomMonoIcon(
                icon: AssetPath.ICON_DROPDOWN,
                size: iconsize,
                color: AppColor.colorWhite,
                isSvg: true,
              )),
          Expanded(
              child: CustomText(
            text: "Add To Call",
            fontsize: 17,
            fontweight: FontWeight.w600,
            fontcolor: AppColor.colorWhite,
            textAlign: TextAlign.center,
          )),
          participants.isNotEmpty
              ? CustomButton(
                  text: "Ok",
                  radius: 0,
                  onTap: () {
                    callController.inviteCallParticipants(participants.toList());
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSizer.getWidth(10),
                      vertical: AppSizer.getHeight(
                          AppDimen.LOGIN_BUTTON_VERT_PADDING)),
                )
              : Container(
                  width: AppSizer.getWidth(AppDimen.APPBAR_ICON_BUTTON_SIZE),
                ),
        ],
      ),
    );
  }
}
