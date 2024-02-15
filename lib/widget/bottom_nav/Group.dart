import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_with_myysql/controller/user/group_chat_controller.dart';
import 'package:chat_app_with_myysql/model/group_chat_users_model.dart';
import 'package:chat_app_with_myysql/util/methods.dart';
import 'package:chat_app_with_myysql/view/create_group/create_group_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import '../../resources/myColors.dart';
import '../../util/assets_manager.dart';
import '../../view/group_chat_screen/group_chat_screen.dart';

class Group extends StatefulWidget {
  const Group({super.key});

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
  final GroupChatController apiController = Get.put(GroupChatController());

  @override
  void initState() {
    apiController.loadChatGroupsApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBlack,
      floatingActionButton: floatingBtn(),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xff363F3B))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(ImageAssets.kSearchIcon),
              )),
        ),
        title: Image.asset(
          'images/Logo (1).png',
          width: 90,
          height: 30,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ClipOval(
                child: Image.asset(
              ImageAssets.kDemoUserImage,
              height: 45,
              width: 45,
              fit: BoxFit.contain,
            )),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              Obx(
                () => Expanded(
                  child: ListView.separated(
                      padding: EdgeInsets.zero,
                      separatorBuilder: ((context, index) => const SizedBox(
                            height: 10.0,
                          )),
                      itemCount: apiController.isLoading.value
                          ? 8
                          : apiController.groupsChatList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              next_page(
                                GroupChatScreen(
                                  groupImage: apiController
                                      .groupsChatList[index].groupAvatar,
                                  title: apiController
                                      .groupsChatList[index].chatName,
                                  userCount: apiController
                                      .groupsChatList[index].userCount.toString(),
                                ),
                              );
                            },
                            child: apiController.isLoading.value
                                ? buildUserShimmer()
                                : chatUser(
                                    apiController.groupsChatList[index]));
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer.fromColors(
                  baseColor: Colors.grey[400]!,
                  highlightColor: Colors.grey[300]!,
                  child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                      baseColor: Colors.grey[400]!,
                      highlightColor: Colors.grey[300]!,
                      child: Container(
                          height: 10,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                          ))),
                  SizedBox(height: 10.0),
                  Shimmer.fromColors(
                      baseColor: Colors.grey[400]!,
                      highlightColor: Colors.grey[300]!,
                      child: Container(
                          height: 10,
                          width: 200,
                          //width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            //shape: BoxShape.circle,
                          ))),
                ],
              ),
              const SizedBox(width: 5.0),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[400]!,
                  highlightColor: Colors.grey[300]!,
                  child: Container(
                      height: 10,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget floatingBtn() {
    return FloatingActionButton(
      onPressed: () async {
        await Permission.contacts.request();
        bool b = await Permission.contacts.isGranted;
        if (b) next_page(CreateGroupScreen());
      },
      backgroundColor: appYellow,
      child: Icon(
        CupertinoIcons.add,
        color: Colors.white,
      ),
    );
  }

  Widget chatUser(GroupChatUsersModel groupModel) {
    DateTime dateTime = DateTime.parse(groupModel.createdAt);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 28.0,
                backgroundColor: AppColor.appYellow,
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  imageUrl: groupModel.groupAvatar,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    groupModel.chatName ?? "",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: "Roboto",
                    ),
                  ),
                  const Text(
                    "Don’t miss to attend the meeting.",
                    //"Participants ${groupModel.userCount}",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 5.0),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Column(
                  children: [
                    Text(DateFormat('HH:mm').format(dateTime),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontFamily: "Roboto",
                        )),
                    Container(
                        decoration: const BoxDecoration(
                          color: AppColor.appYellow,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(groupModel.userCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "Roboto",
                              )),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
