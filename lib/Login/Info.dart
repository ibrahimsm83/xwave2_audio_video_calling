import 'dart:io';

import 'package:chat_app_with_myysql/helper/apis/ApiService.dart';
import 'package:chat_app_with_myysql/helper/apis/SocketManager.dart';
import 'package:chat_app_with_myysql/helper/apis/apis.dart';
import 'package:chat_app_with_myysql/helper/myColors.dart';
import 'package:chat_app_with_myysql/helper/widgets/myBtn.dart';
import 'package:chat_app_with_myysql/helper/widgets/myText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Home.dart';
import '../helper/MyPraf.dart';
import '../helper/methods.dart';
import '../helper/widgets/my_input.dart';

class Info extends StatefulWidget {
  final String nbr;
  const Info({super.key, required this.nbr});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {

  File? img;
  var name=TextEditingController();
  var info=TextEditingController();

  ApiService apiService=ApiService();
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

              if(img==null)
                {
                  Get.snackbar('Error', 'Select image');

                  return;
                }

              if(name.text.isEmpty||info.text.isEmpty){
                Get.snackbar('Error', 'fill all the fields');

                return;
              }


              Map<String,dynamic> body={
                'username':name.text,
                'infoAbout':info.text,
                'phoneNumber':widget.nbr,
                'avatar':img!
              };

              EasyLoading.show();
              Response response=await apiService.postApiWithFromData(updateInfo, body);
              EasyLoading.dismiss();
              print(response.body);
              if(response.statusCode==200){
                print(response.body['userData']['user_id']);
                String id=response.body['userData']['user_id'];
                String token=response.body['token'];
                await saveDataToPraf(id, token);
                initSocket();
                await checkConected();
                close_all_go_next_page(Home());
              }
              else{
                Get.snackbar('error', 'try again');
              }






            },))


        ],)



      ],),



    );
  }

  checkConected()async{
    while(socket!=null&&!socket!.connected){
      await Future.delayed(Duration(milliseconds: 100));
    }
  }
}


