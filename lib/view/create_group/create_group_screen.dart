import 'package:chat_app_with_myysql/model/create_group_user_model.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/util/assets_manager.dart';
import 'package:chat_app_with_myysql/widget/custom_button.dart';
import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _groupNameController = TextEditingController();
  List<CreateGroupUserModel> userList = [
    CreateGroupUserModel(
        id: "0", name: "ali", isSelected: false, imageUrl: ImageAssets.person1),
    CreateGroupUserModel(
        id: "1",
        name: "kashif",
        isSelected: false,
        imageUrl: ImageAssets.person2),
    CreateGroupUserModel(
        id: "2",
        name: "jhon",
        isSelected: false,
        imageUrl: ImageAssets.person3),
    CreateGroupUserModel(
        id: "3",
        name: "smith",
        isSelected: false,
        imageUrl: ImageAssets.person4),
    CreateGroupUserModel(
        id: "4", name: "tom", isSelected: false, imageUrl: ImageAssets.person5),
    CreateGroupUserModel(
        id: "5",
        name: "james",
        isSelected: false,
        imageUrl: ImageAssets.person6),
    CreateGroupUserModel(
        id: "6",
        name: "wick",
        isSelected: false,
        imageUrl: ImageAssets.person7),
  ];

  List<String> userIdsList=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Create Group",
          style: TextStyle(
              fontSize: 16, fontFamily: "Roboto", fontWeight: FontWeight.w500),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(20.0),
          child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                Icons.arrow_back,
                color: Colors.yellow,
              )),
        ),
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
                  "Members",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500),
                ),
              ),
              // Row(
              //   children: [
              //     usersList(userList),
              //   ],
              // ),
              Container(
                width: MediaQuery.of(context).size.width,
                //color: Colors.red,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 20.0,
                  runSpacing: 10.0,
                  children: List.generate(userList.length, (index) {
                    return userCircular(
                        userModel: userList[index],
                        onTap1: () {
                          print("--onTap---");
                        if(userList[index].isSelected){
                          userList[index].isSelected=false;
                          userIdsList.removeWhere((e) => e==userList[index].id);
                        }else{
                          userList[index].isSelected=true;
                          userIdsList.add(userList[index].id);
                        }
                          print(userIdsList);
                          setState(() {});
                        });

                  }),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: button(
                    text: "Create",
                    color: appYellow,
                    context: context,
                    onTap: () {
                      //Navigator.pushNamed(context, CustomRouteNames.kWorkingHourScreenRoute);
                    }),
              ),
            ],
          ),
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
      decoration: BoxDecoration(
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
                    image: AssetImage(userModel!.imageUrl!),
                    fit: BoxFit.cover),
                shape: BoxShape.circle,
              ),
            ),
          ),
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
                    color:  userModel!.isSelected?appYellow:Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Icon(
                      userModel!.isSelected ? Icons.check : Icons.add,
                      size: 14,
                      color: userModel!.isSelected?Colors.black: Colors.white,
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
    return const ListTile(
      leading: CircleAvatar(
        radius: 30.0,
        backgroundImage: AssetImage(ImageAssets.kDemoUserImage),
      ),
      title: Text(
        "Rashid Khan",
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
          color: color!,
          text: text ?? "",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          onTap: onTap),
    );
  }
}
