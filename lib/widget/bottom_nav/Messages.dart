import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_with_myysql/controller/user/dashboard_controller.dart';
import 'package:chat_app_with_myysql/model/OnetoOneChatRoomModel.dart';
import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/service/network/ApiService.dart';
import 'package:chat_app_with_myysql/service/network/SocketManager.dart';
import 'package:chat_app_with_myysql/service/network/apis.dart';
import 'package:chat_app_with_myysql/util/assets_manager.dart';
import 'package:chat_app_with_myysql/util/datetime.dart';
import 'package:chat_app_with_myysql/util/helper_functions.dart';
import 'package:chat_app_with_myysql/util/methods.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/navigation.dart';
import 'package:chat_app_with_myysql/view/story_view/all_users_story_view_screen.dart';
import 'package:chat_app_with_myysql/view/story_view/open_story_screen.dart';
import 'package:chat_app_with_myysql/view/story_view/story_view_controller.dart';
import 'package:chat_app_with_myysql/view/user/dashboard/Contacts.dart';
import 'package:chat_app_with_myysql/view/user/dashboard/one_to_one_chat/OneToOneChat.dart';
import 'package:chat_app_with_myysql/view/user/dashboard/one_to_one_chat/controller.dart';
import 'package:chat_app_with_myysql/view/user/dashboard/settings/settings.dart';
import 'package:chat_app_with_myysql/widget/my_profile_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final StoryController storyViewController = Get.find<StoryController>();

  // final StoryController storyViewController = Get.put(StoryController());

  bool uploading = false;
  bool next = false;
  final List<XFile> imageFileList = [];

  ///Choose MultiImages

  ApiService apiService = ApiService();
  bool isLoading = false;
  String message = "hello";
  bool isStatusList = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storyViewController.getStoryApi();
    storyViewController.getUserStoryApi();
    fetchRooms();
    getUserInfo();
    registerEvent('chatListUpdate', roomsUpdateListner);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: appBlack,
      floatingActionButton: flottingBtn(),
      body: SafeArea(
        child: ListView(
          children: [
            header(),
            Obx(()=> Visibility(visible: isStatusList, child: users())),
            chatRoomContainer(),
          ],
        ),
      ),
    );
  }

  Widget users() {
    return Container(
      height: 120,
      child: Row(
        children: [
          ownStatusWidget(),
          SizedBox(width: 10.0),
          Flexible(
            child:storyViewController.isUserStatusLoading.value?Center(child: CircularProgressIndicator(),):
            ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: storyViewController.allUsersStatusList.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            next_page(OpenUsersStoryView(status:storyViewController.allUsersStatusList[index].statuses,userName:storyViewController.allUsersStatusList[index].username,userAvatar: storyViewController.allUsersStatusList[index].avatar,));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColor.appYellow,
                                ),
                                image:  DecorationImage(
                                    image: NetworkImage(storyViewController.allUsersStatusList[index].avatar!),
                                    fit: BoxFit.cover),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(storyViewController.allUsersStatusList[index].username??"Jhon",
                      style: TextStyle(color: Colors.white, fontSize: 10)),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ownStatusWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Container(
          height: 70,
          width: 70,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: [
              InkWell(
                onTap: () {
                  print("object");
                  next_page(OpenStoryView(status:storyViewController.ownStatusList,));
                  // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>const OpenStoryView()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: dashboardController.user_model != null
                        ? BoxDecoration(
                            border: Border.all(color: AppColor.appYellow),
                            image: DecorationImage(
                                image: NetworkImage(
                                    dashboardController.user_model!.avatar),
                                fit: BoxFit.cover),
                            shape: BoxShape.circle,
                          )
                        : BoxDecoration(
                            border: Border.all(
                              color: AppColor.appYellow,
                            ),
                            image: const DecorationImage(
                                image: AssetImage(ImageAssets.person1),
                                fit: BoxFit.cover),
                            shape: BoxShape.circle,
                          ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  print("button Tapped...");
                  if (storyViewController.isOwnStatus.value) {
                    print("navigate to story view page");
                    print(storyViewController.ownStatusList.value);
                    next_page(OpenStoryView(
                        status: storyViewController.ownStatusList.value!));
                  } else {
                    final List<XFile>? selectedImages =
                        await ImagePicker().pickMultiImage();
                    if (selectedImages!.isNotEmpty) {
                      storyViewController.addStoryApi(
                          images: selectedImages, text: "");
                      imageFileList!.addAll(selectedImages!);
                    }
                    setState(() {});
                  }
                  // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>const CreateMyProfilePg()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2.0),
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Visibility(
                        visible: !storyViewController.isLoading.value,
                        child: Center(
                            child: Icon(
                          Icons.add,
                          size: 15,
                        )),
                        replacement: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 4.0),
        Text("Me", style: TextStyle(color: Colors.white, fontSize: 10)),
      ]),
    );
  }

  Widget header() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'images/Group 370.png',
            width: 36.2,
            height: 36.2,
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'images/Logo (1).png',
            width: 90,
            height: 30,
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
              onTap: () {
                AppNavigator.navigateTo(SettingsScreen());
              },
              child: my_profile_container(
                  img: dashboardController.user_model == null
                      ? 'https://static-00.iconduck.com/assets.00/profile-circle-icon-2048x2048-cqe5466q.png'
                      : dashboardController.user_model!.avatar)),
        )
      ],
    );
  }

  Widget chatRoomContainer() {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
        child: ListView.builder(
          itemCount: isLoading ? 4 : chatRoomsModels.length,
          itemBuilder: (context, index) {
            return isLoading
                ? buildUserShimmer()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        ChatController chatController =
                            Get.put(ChatController());
                        chatController
                            .fetchChat(chatRoomsModels[index].user_model.id);
                        chatController.senderUser =
                            dashboardController.user_model!;
                        chatController.receiverUser =
                            chatRoomsModels[index].user_model;
                        next_page(OneToOneChat(
                            chatID: chatRoomsModels[index].chatID,
                            sender: dashboardController.user_model!,
                            receiver: chatRoomsModels[index].user_model));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 28.0,
                                backgroundColor: AppColor.appYellow,
                                child: CachedNetworkImage(
                                  fit: BoxFit.contain,
                                  imageUrl:
                                      chatRoomsModels[index].user_model.avatar,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    chatRoomsModels[index].user_model.username,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontFamily: "Roboto",
                                    ),
                                  ),
                                  Text(
                                    chatRoomsModels[index].msg,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Column(
                              children: [
                                Text(
                                    DateTimeManager
                                        .getFormattedDateTimeFromDateTime(
                                      DateTime.parse(
                                          chatRoomsModels[index].time),
                                      isutc: true,
                                      format: DateTimeManager.timeFormat3,
                                    ),
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "Roboto",
                                        fontSize: 12)),
                                Container(
                                    decoration: const BoxDecoration(
                                      color: AppColor.appYellow,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("1",
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
                  );
          },
        ),
      ),
    );
  }

  Widget flottingBtn() {
    return FloatingActionButton(
      onPressed: () async {
        await Permission.contacts.request();
        bool b = await Permission.contacts.isGranted;
        if (b) next_page(Contacts());
        AppNavigator.navigateTo(Contacts());
      },
      backgroundColor: appYellow,
      child: Icon(
        CupertinoIcons.add,
        color: Colors.white,
      ),
    );
  }

  List<OnetoOneChatRoomModel> chatRoomsModels = [];

  fetchRooms() async {
    setState(() {
      isLoading = true;
    });
    var response = await apiService.getApiWithToken(fetch1To1chatRooms);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data.isEmpty) {
        AppMessage.showMessage("Please add Users in Your device contact");
      }
    }
    setState(() {
      isLoading = false;
    });
    if (response.statusCode != 200) return;

    chatRoomsModels.clear();

    var map = jsonDecode(response.body);
    List<dynamic> list = map;

    list.forEach((element) {
      String chatID = '';
      String time = '';
      String msg = '';

      chatID = element['_id'];
      time = element['updatedAt'];
      if (element['latestMessage'] != null &&
          element['latestMessage']['content'] != null)
        msg = element['latestMessage']['content'];

      List<dynamic> users = element['users'];
      User_model user_model = User_model.fromJson(users[0]);

      OnetoOneChatRoomModel model = OnetoOneChatRoomModel(
          chatID: chatID, time: time, msg: msg, user_model: user_model);
      chatRoomsModels.add(model);
    });
    setState(() {});
  }

  //User_model? user_model;
  getUserInfo() async {
    var response = await apiService.getApiWithToken(userInfo);
    print('info ' + response.body.toString());

    // {status: success, userData: {user_id: 65a65609ffdcd322af8fd0f1, phoneNumber: +92100, avatar: https://i.stack.imgur.com/34AD2.jpg, infoAbout: sdsdsd, username: n100}}

    var map = jsonDecode(response.body);
    if (map['userData'] == null) return;
    String id = map['userData']['user_id'];
    String name = map['userData']['username'];
    String phone = map['userData']['phoneNumber'];
    String avatar = map['userData']['avatar'];
    String infoAbout = map['userData']["infoAbout"];
    dashboardController.user_model = User_model(
        id: id,
        phoneNumber: phone,
        avatar: avatar,
        infoAbout: infoAbout,
        username: name);
    setState(() {});
  }

  roomsUpdateListner(dynamic newMessage) async {
    print('msg socket - ' + newMessage.toString());
    chatRoomsModels.clear();

    List<dynamic> list = newMessage;

    list.forEach((element) {
      String chatID = '';
      String time = '';
      String msg = '';

      chatID = element['_id'];
      time = element['updatedAt'];
      if (element['latestMessage'] != null &&
          element['latestMessage']['content'] != null)
        msg = element['latestMessage']['content'];

      List<dynamic> users = element['users'];
      User_model user_model = User_model.fromJson(users[0]);

      OnetoOneChatRoomModel model = OnetoOneChatRoomModel(
          chatID: chatID, time: time, msg: msg, user_model: user_model);
      chatRoomsModels.add(model);
    });
    setState(() {});
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

  @override
  void dispose() {
    unregisterEvent('chatListUpdate');
    super.dispose();
  }
}
