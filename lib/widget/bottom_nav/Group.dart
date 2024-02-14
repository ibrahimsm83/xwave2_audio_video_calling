import 'package:chat_app_with_myysql/util/methods.dart';
import 'package:chat_app_with_myysql/view/create_group/create_group_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../../resources/myColors.dart';
import '../../util/assets_manager.dart';

class Group extends StatefulWidget {
  const Group({super.key});

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
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
              Expanded(
                child: ListView.separated(
                    padding: EdgeInsets.zero,
                    separatorBuilder: ((context, index) => SizedBox(
                          height: 10.0,
                        )),
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => InnerChat(
                          //           image: storiesprofile[index],
                          //           name: storiesname[index],
                          //         )));
                        },
                        child: buildUserShimmer(),

                        // chatUser(
                        //     "TeamAlign", ImageAssets.kDemoUserImage)
                      );
                    }),
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
                  child:
                  Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ))

              ),
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
                child:  Shimmer.fromColors(
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

  Widget chatUser(String? name, String? img) {
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
                radius: 30.0,
                backgroundImage: AssetImage(img!),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name!,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: "Roboto",
                    ),
                  ),
                  Text(
                    "Hey, I was wondering if you could…",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 5.0),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text("8:00 AM",
                    style: TextStyle(
                      color: Colors.grey,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
