import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app_with_myysql/controller/user/controller.dart';
import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/model/create_group_user_model.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/assets_manager.dart';
import 'package:chat_app_with_myysql/util/sizer.dart';
import 'package:chat_app_with_myysql/widget/common.dart';
import 'package:chat_app_with_myysql/widget/custom_button.dart';
import 'package:chat_app_with_myysql/widget/profile_items.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_with_myysql/util/sizer.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/user/group_chat_controller.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final ContactController contactController = Get.find<ContactController>();
  final GroupChatController groupChatController = Get.find<GroupChatController>();
  final DashboardController dashboardController = Get.find<DashboardController>();
  List<User_model>? contactList;
  List<String> userIdsList = [];
  List<CreateGroupUserModel> userList = [];
  File? img;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  final _groupNameController = TextEditingController();
  void loadData() async {
   await contactController.loadApiContacts();
    contactList = contactController.users.value.data;

    if (contactList != null) {
      for (int i = 0; i < contactList!.length; i++) {
        userList.add(CreateGroupUserModel(
            id: contactList![i].id,
            name: contactList![i].username,
            isSelected: false,
            imageUrl: contactList![i].avatar));
      }
    }else{
      print("contact list is empty");
    }
  }

  @override
  void dispose() {
    userList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Create Group",
          style: TextStyle(
              fontSize: 16, fontFamily: "Roboto", fontWeight: FontWeight.w500),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(20.0),
          child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.yellow,
              )),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {
              userList=[];
              contactList=[];
              loadData();
            }, icon: Icon(Icons.refresh,color: AppColor.appYellow,)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Group Name",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500),
                ),
              ),
              searchFiled(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: groupWork("Group Work"),
                    ),
                    groupWork("Team  relationship"),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Group Admin",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500),
                ),
              ),
              groupAdminWidget(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Select Group Image",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500),
                ),
              ),

              ///Select Group Image
              Center(
                child: InkWell(
                  onTap: () async{
                    XFile? xfile=await ImagePicker().pickImage(source: ImageSource.gallery);
                    if(xfile!=null){
                      img=File(xfile.path);
                      setState(() {
                      });
                    }

                  },
                  child: Container(
                    width: 100,height: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                        image: img==null?DecorationImage(image: AssetImage('images/Group 468.png'),):
                        DecorationImage(image: FileImage(img!),fit: BoxFit.cover)
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "App Members",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500),
                ),
              ),

              Obx(() {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 20.0,
                    runSpacing: 10.0,
                    children: List.generate(contactController.isLoading.value?8: userList.length, (index) {
                      if (contactController.isLoading.value) {
                        return buildUserImageShimmer();
                      } else {
                        return userCircular(
                            userModel: userList[index],
                            onTap1: () {
                              if (userList[index].isSelected) {
                                userList[index].isSelected = false;
                                userIdsList.removeWhere(
                                    (e) => e == userList[index].id);
                              } else {
                                userList[index].isSelected = true;
                                userIdsList.add(userList[index].id);
                              }
                              setState(() {});
                            });
                      }
                    }),
                  ),
                );
                //}
              }),
              const SizedBox(height: 50.0),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: button(
                    text: "Create",
                    color: appYellow,
                    context: context,
                    onTap: () {

                      if (img == null) {
                        Get.snackbar('Error', 'Select image');
                        return;
                      }
                      if (_groupNameController.text.isNotEmpty && userIdsList.isNotEmpty) {
                        groupChatController.createChatGroupsApi(groupName: _groupNameController.text.trim(),usersList: userIdsList,imageFile: img!);
                      } else {
                        Get.snackbar('Error', 'Enter Group Name or Select Users',
                            backgroundColor: Colors.red);
                      }
                      //Navigator.pushNamed(context, CustomRouteNames.kWorkingHourScreenRoute);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserImageShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[300]!,
      child: Container(
        height: 75,
        width: 75,
        //margin: EdgeInsets.only(top: 50),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget userCircular(
      {dynamic Function()? onTap1, CreateGroupUserModel? userModel}) {
    return Container(
      height: 75,
      width: 75,
      //margin: EdgeInsets.only(top: 50),
      decoration: const BoxDecoration(
        color: Colors.yellow,
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2.0),
                image: DecorationImage(
                  // ImageAssets.likeImage20
                    image: NetworkImage(userModel!.imageUrl!),
                    fit: BoxFit.cover),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // CachedNetworkImage(
          //   fit: BoxFit.contain,
          //   imageUrl: userModel!.imageUrl!,
          //   imageBuilder:(context, imageProvider) => Container(
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       border: Border.all(color: Colors.grey, width: 2.0),
          //       image: DecorationImage(
          //         image: imageProvider,
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ) ,
          //   progressIndicatorBuilder: (context, url, downloadProgress) =>
          //       CircularProgressIndicator(value: downloadProgress.progress),
          //   errorWidget: (context, url, error) => const Icon(Icons.error),
          // ),
          //uploadeIcon
          InkWell(
            onTap: onTap1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2.0),
                    color: userModel!.isSelected
                        ? appYellow
                        : Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Icon(
                      userModel!.isSelected ? Icons.check : Icons.add,
                      size: 14,
                      color:
                          userModel!.isSelected ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget searchFiled() {
    return SizedBox(
      height: 45,
      child: InkWell(
        onTap: () {
          // Navigator.pushNamed(
          //   context,
          //   CustomRouteNames.kSearchResultScreenRoute,
          // );
        },
        child: TextField(
          controller: _groupNameController,
          style: TextStyle(),
          decoration: InputDecoration(
            focusColor: Colors.transparent,
            contentPadding: EdgeInsets.only(left: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: appYellow,
              ),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: appYellow,
                )),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: appYellow,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            // prefixIcon: Icon(
            //   Icons.search,
            //   color: Colors.lightBlueAccent,
            // ),
            hintText: 'Enter Group Name',
            // labelStyle: TextStyle(
            //   color: ColorManager.kGreyColor,
            // ),
          ),
        ),
      ),
    );
  }

  Widget groupWork(String text) {
    return Container(
      height: 34,
      //width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xff20A090).withOpacity(0.3),
      ),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
        ),
        child: Text(text, style: TextStyle(fontSize: 12)),
      )),
    );
  }

  Widget groupAdminWidget() {
    return  ListTile(
      leading: CircleAvatar(
        radius: 28.0,
        backgroundColor: AppColor.appYellow,
        child: CachedNetworkImage(
          fit: BoxFit.contain,
          imageUrl: dashboardController.user_model!.avatar,
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
      title: Text(
          dashboardController.user_model!.username,
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
          fontFamily: "Roboto",
        ),
      ),
      subtitle: Text(
        "Group Admin",
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }

  // Widget usersList(List<CreateGroupUserModel> userlist,) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //     child: Wrap(
  //       spacing: 8.0,
  //       runSpacing: 15.0,
  //       children: List.generate(userlist.length, (index) {
  //         return Align(
  //           alignment: Alignment.topCenter,
  //           child: Container(
  //             height: 60,
  //             width: 60,
  //             margin: EdgeInsets.only(top: 50),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               shape: BoxShape.circle,
  //             ),
  //             child: Stack(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(0.0),
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                       border: Border.all(color: Colors.red, width: 2.0),
  //                       image: DecorationImage(
  //                           // ImageAssets.likeImage20
  //                           image: AssetImage(ImageAssets.kDemoUserImage),
  //                           fit: BoxFit.cover),
  //                       shape: BoxShape.circle,
  //                     ),
  //                   ),
  //                 ),
  //                 //uploadeIcon
  //                 InkWell(
  //                   onTap: () async {
  //                     // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>const CreateMyProfilePg()));
  //                   },
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(bottom: 4.0),
  //                     child: Align(
  //                       alignment: Alignment.bottomRight,
  //                       child: Container(
  //                         height: 20,
  //                         width: 20,
  //                         decoration: BoxDecoration(
  //                           border: Border.all(color: Colors.green, width: 2.0),
  //                           color: Colors.red,
  //                           shape: BoxShape.circle,
  //                         ),
  //                         child: Padding(
  //                           padding: EdgeInsets.all(1.0),
  //                           child: Icon(
  //                             Icons.check,
  //                             size: 14,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       }),
  //     ),
  //   );
  // }

  Widget button(
      {Function()? onTap, String? text, Color? color, BuildContext? context}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context!).size.width * 0.05, vertical: 8.0),
      child: CustomButton(
          bgColor: color!,
          text: text ?? "",
          textColor: AppColor.colorWhite,fontsize: 14,
          onTap: onTap),
    );
  }
}
