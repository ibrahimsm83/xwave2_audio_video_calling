import 'dart:convert';
import 'dart:io';

import 'package:chat_app_with_myysql/model/User_model.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/controller/user/dashboard_controller.dart';
import 'package:chat_app_with_myysql/service/network/ApiService.dart';
import 'package:chat_app_with_myysql/service/network/apis.dart';
import 'package:chat_app_with_myysql/util/MyPraf.dart';
import 'package:chat_app_with_myysql/util/helper_functions.dart';
import 'package:chat_app_with_myysql/util/navigation.dart';
import 'package:chat_app_with_myysql/view/user/dashboard/settings/settings.dart';
import 'package:chat_app_with_myysql/widget/myBtn.dart';
import 'package:chat_app_with_myysql/widget/my_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  const EditProfile({super.key,});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  File? img;
  var name=TextEditingController();
  var info=TextEditingController();

  ApiService apiService=ApiService();

  final DashboardController dashboardController=Get.find<DashboardController>();

  @override
  void initState() {
   name.text=dashboardController.user_model!.username;
   info.text=dashboardController.user_model!.infoAbout;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [

        Container(
            width: Get.width,height: Get.height,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Image.asset('images/Group 467.png',fit: BoxFit.cover,),
            )),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

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
                  width: 200,height: 200,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: img==null?DecorationImage(image: AssetImage('images/Group 468.png'),):
                      DecorationImage(image: FileImage(img!),fit: BoxFit.cover)
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: my_input(controler: name, label: 'Your Name'),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: my_input(controler: info, label: 'Your Info'),
            ),

            SizedBox(height: 30,),
            myBtn(text: 'Upload', color: appYellow, gestureDetector: GestureDetector(onTap: () async{
              if(name.text.isEmpty||info.text.isEmpty){
                Get.snackbar('Error', 'fill all the fields');

                return;
              }
              Map<String,String> body={
                'username':name.text,
                'infoAbout':info.text,
                'phoneNumber':dashboardController.user_model!.phoneNumber,
                //   'avatar':img!
              };

              EasyLoading.show();
              List<http.MultipartFile> files=[];
              if(img!=null){
                files.add(await http.MultipartFile.fromPath("avatar", img!.path));
              }
              var response=await apiService.postApiWithFromData(updateInfo, body,
                  files: files);
              EasyLoading.dismiss();
              if(response.statusCode==200){
                Stream stream = response.stream.transform(const Utf8Decoder());
                String body = await stream.first;
                var map=jsonDecode(body);
                print("update response: $map");
                if(map["status"]=="success"){
                  var user=User_model.fromJson2(map["userData"]);
                  dashboardController.user_model!.username=user.username;
                  dashboardController.user_model!.infoAbout=user.infoAbout;
                  dashboardController.user_model!.avatar=user.avatar;
                  AppNavigator.popUntil(SettingsScreen.route);
                }
                AppMessage.showMessage(map["message"]);
              }
              else{
                Get.snackbar('error', 'try again');
              }



            },))


          ],)



      ],),



    );
  }

}