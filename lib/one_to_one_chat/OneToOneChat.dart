import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chat_app_with_myysql/Models/ChatModel.dart';
import 'package:chat_app_with_myysql/Models/User_model.dart';
import 'package:chat_app_with_myysql/OnetoOneCall/VideoCallForCaller.dart';
import 'package:chat_app_with_myysql/helper/MyPraf.dart';
import 'package:chat_app_with_myysql/helper/apis/ApiService.dart';
import 'package:chat_app_with_myysql/helper/apis/SocketManager.dart';
import 'package:chat_app_with_myysql/helper/methods.dart';
import 'package:chat_app_with_myysql/helper/myColors.dart';
import 'package:chat_app_with_myysql/helper/widgets/myBtn.dart';
import 'package:chat_app_with_myysql/helper/widgets/myText.dart';
import 'package:chat_app_with_myysql/helper/widgets/my_input.dart';
import 'package:chat_app_with_myysql/helper/widgets/my_profile_container.dart';
import 'package:chat_app_with_myysql/one_to_one_chat/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../OnetoOneCall/MakingAudioCall.dart';
import '../helper/apis/apis.dart';
import '../helper/widgets/ChatHolder.dart';

class OneToOneChat extends StatefulWidget {

  final String chatID;
  final User_model sender,receiver;
  const OneToOneChat({super.key, required this.chatID, required this.sender, required this.receiver});

  @override
  State<OneToOneChat> createState() => _OneToOneChatState();
}

class _OneToOneChatState extends State<OneToOneChat> {
   ApiService apiService=ApiService();
  ChatController chatController = Get.put(ChatController());

  ///AudioRecorder
   AnotherAudioRecorder? _recorder;
   Recording? _current;
   RecordingStatus _currentStatus = RecordingStatus.Unset;
   AudioPlayer audioPlayer = AudioPlayer();

   PlayerState playerState = PlayerState.stopped;
   Duration _duration = Duration();
   Duration _position = Duration();
   String? _voicePat;
   bool _isPlaying = false;

   @override
   void initState() {

     audioPlayer.onDurationChanged.listen((Duration duration) {
       setState(() {
         _duration = duration;
       });
       print("listner-----onDurationChanged-");
     });


     // Set up listeners for player state changes
     audioPlayer.onPlayerStateChanged.listen((state) {
       setState(() {
         playerState = state;
       });
     });

     audioPlayer.onPositionChanged.listen((Duration position) {
       setState(() {
         _position = position;

       });
       print("listner-----onPositionChanged-");
     });

     super.initState();
     valuesPrint();
     registerEvent('new-message',chatController.msgListner);
     _init();
     //fetchChat();
   }




   _init() async {
     try {
       if (await AnotherAudioRecorder.hasPermissions) {
         String customPath = '/another_audio_recorder_';
         io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
         if (io.Platform.isIOS) {
           appDocDirectory = await getApplicationDocumentsDirectory();
         } else {
           appDocDirectory = (await getExternalStorageDirectory())!;
         }

         // can add extension like ".mp4" ".wav" ".m4a" ".aac"
         customPath = appDocDirectory.path + customPath + DateTime.now().millisecondsSinceEpoch.toString();

         // .wav <---> AudioFormat.WAV
         // .mp4 .m4a .aac <---> AudioFormat.AAC
         // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
         _recorder = AnotherAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

         await _recorder?.initialized;
         // after initialization
         var current = await _recorder?.current(channel: 0);
         print("-------recorder initilized...");
         print("-------Custom path--...$customPath");
         print("-------current path--...$current");

         // should be "Initialized", if all working fine
         setState(() {
           _current = current;
           _currentStatus = current!.status!;
           print(_currentStatus);
         });
       } else {
         return SnackBar(content: Text("You must accept permissions"));
       }
     } catch (e) {
       print(e);
     }
   }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Obx(()=>
        Column(children: [
          myappBar(),
          //--------------------Audio recording Start-------
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       switch (_currentStatus) {
          //         case RecordingStatus.Initialized:
          //           {
          //             _start();
          //             break;
          //           }
          //         case RecordingStatus.Recording:
          //           {
          //             _pause();
          //             break;
          //           }
          //         case RecordingStatus.Paused:
          //           {
          //             _resume();
          //             break;
          //           }
          //         case RecordingStatus.Stopped:
          //           {
          //             _init();
          //             break;
          //           }
          //         default:
          //           break;
          //       }
          //     },
          //     child: _buildText(_currentStatus),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.red,
          //     ),
          //   ),
          // ),
          // ElevatedButton(
          //   onPressed: _currentStatus != RecordingStatus.Unset ? _stop : null,
          //   child: Text("Stop", style: TextStyle(color: Colors.white)),
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.blueAccent.withOpacity(0.5),
          //   ),
          // ),
         const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _audioPlayerStart,
            //onPlayAudio,
            child: Text("Play", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent.withOpacity(0.5),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 100),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  if (playerState == PlayerState.playing)
                    IconButton(
                      onPressed: () => _pause(),
                      icon: Icon(Icons.pause),
                    )
                  else
                    IconButton(
                      onPressed: () =>_play(),
                      icon:Icon(Icons.play_arrow),
                    ),
                  SizedBox(height: 20),

                  Flexible(
                    child: Slider(
                      value:
                          _position.inMilliseconds.toDouble(),
                      onChanged: (double value) {
                        _seekTo(value);

                      },
                      min: 0.0,
                      max:

                          _duration.inMilliseconds.toDouble(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          new Text("Status : $_currentStatus"),
          new Text('Avg Power: ${_current?.metering?.averagePower}'),
          new Text('Peak Power: ${_current?.metering?.peakPower}'),
          // new Text("File path of the record: ${_current?.path}"),
          // new Text("Format: ${_current?.audioFormat}"),
          // new Text("isMeteringEnabled: ${_current?.metering?.isMeteringEnabled}"),
          // new Text("Extension : ${_current?.extension}"),
          // new Text("Audio recording duration : ${_current?.duration.toString()}"),
          //--------------------Audio recording end
          chatListWight(),
          Visibility(
              visible: !chatController.isMicTapped.value,
              child: chatOptionsWight(),
          replacement:audioRecordingSheetWight(),
          ),



        ],),
      )
    );
  }

  Widget myappBar(){
    return Container(
      width: Get.width,height: 100,
      decoration: BoxDecoration(
        color: appback
      ),
      child:Column(children: [

        SizedBox(height: 30,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(onPressed: () {
              Get.back();
            }, icon: Icon(Icons.arrow_back,color: appYellow,)),
            my_profile_container(img: widget.receiver.avatar),SizedBox(width: 10,),
            myText(text: widget.receiver.username,color: Colors.white,size: 16,fontWeight: FontWeight.w500,),
            Spacer(),
            IconButton(onPressed: () {

              next_page(MakingAudioCall(receiver: widget.receiver));


            }, icon: Icon(CupertinoIcons.phone,color: appYellow,)),
            IconButton(onPressed: () {

              next_page(VideoCallForCaller( user_model: widget.receiver, chanelName: '',));
            }, icon: Icon(CupertinoIcons.video_camera,color: appYellow,)),

          ],),
      ],)


    );
  }

  Widget chatListWight(){
    return Expanded(
      child: ListView.builder(
        controller: chatController.scrollController,
        itemCount: chatController.chatList.length,
          itemBuilder: (context, index) {
            ChatModel model=chatController.chatList[index];
// print(model.sender.id);
            if(model.sender.id==widget.sender.id) {

              return Align(
                  alignment: Alignment.centerRight,
                  child: chatHolder(model: model, chatBoxColor: appYellow));
            }
            else{
              return Align(
                  alignment: Alignment.centerLeft,
                  child: chatHolder(model: model, chatBoxColor: applightWhite));
            }


          },),
    );
  }
  
  Widget chatOptionsWight(){
    return Row(children: [
      IconButton(onPressed: () {
      }, icon: const Icon(Icons.emoji_emotions_outlined)),
      chatInputWight(),
      Visibility(
        visible: !chatController.isLoading.value,
        replacement: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(color: appYellow,),
        ),
        child: IconButton(onPressed: () {
           chatController.sendTextMSg(widget.receiver.id,widget.sender,widget.receiver);
        }, icon: Icon(Icons.send,color: appYellow,)),
      )
    ],);
  }

  Widget audioRecordingSheetWight(){
    return Row(children: [
      // IconButton(onPressed: () {
      // }, icon: const Icon(Icons.emoji_emotions_outlined)),
      chatInputAudioWight(),
      Visibility(
        visible: !chatController.isLoading.value,
        replacement: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(color: appYellow,),
        ),
        child: IconButton(onPressed:()async {
                if (_currentStatus != RecordingStatus.Unset) {
                  // _stop();
                  var result = await _recorder?.stop();
                  print("----------current path --1");
                  print(result?.path);
                  print("----------current path --2");
                  chatController.sendTextMSg(widget.receiver.id,widget.sender,widget.receiver,isVoice: true,voiceFile: result?.path);
                } else {
                  null;
                }

    },

        //     () {
        //    //chatController.sendTextMSg(widget.receiver.id,widget.sender,widget.receiver);
        //  // con.isMicTapped.value=false;
        //   print("-----button tapped--------1");
        //
        //    if(_currentStatus == RecordingStatus.Recording){
        //      print("-----button tapped------2");
        //      _stop;
        //    }
        //  //  if(_currentStatus != RecordingStatus.Unset){
        //  //
        //  //  _stop;
        //  // // _audioPlayerStart();
        //  //  }
        // //  _currentStatus
        //   //
        // }

         icon: Icon(Icons.send,color: appYellow,)),
      )
    ],);
  }

  Widget chatInputWight(){
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(children: [
          
          Expanded(child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: my_inputWithHint(controler: chatController.messageController, hint: 'Message',),
          )),

          const  Padding(
            padding:  EdgeInsets.all(2.0),
            child: Icon(Icons.attach_file),
          ),
          InkWell(
            onTap: (){
              chatController.sendTextMSg(widget.receiver.id,widget.sender,widget.receiver,isImage: true);
            },
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(Icons.camera_alt_outlined),
            ),
          ),
          InkWell(
            onTap: (){
              print("mic button tapped..");
              if(_currentStatus == RecordingStatus.Initialized){
                _start();
                chatController.isMicTapped.value=true;
              }else if(_currentStatus == RecordingStatus.Stopped){
                _init();

              }else{
                _start();
                chatController.isMicTapped.value=true;
              }
    },
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(Icons.mic),
            ),
          ),

        ],),
      ),
    ) ;
  }
   Widget chatInputAudioWight(){
     return Flexible(
       child: Padding(
         padding: const EdgeInsets.only(left: 10.0),
         child: Container(
           decoration: BoxDecoration(
               color: Colors.grey[200],
               borderRadius: BorderRadius.circular(20)
           ),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "Recording..................",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              InkWell(
               onTap: (){
                 print("mic button tapped..");
                 chatController.isMicTapped.value=false;
                 // if(_currentStatus == RecordingStatus.Recording){
                 //   print("-------resume called");
                 //   _resume();
                 // }else if(_currentStatus == RecordingStatus.Paused){
                 //   print("-------resume paused now start");
                 //
                 //   _start();
                 // }
               },
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Icon(Icons.cancel),
               ),
             ),

           ],),
         ),
       ),
     ) ;
   }


   Future<void> _seekTo(double value) async {
     await audioPlayer.seek(Duration(milliseconds: value.round()));
   }
  valuesPrint()async{

    print('chat id - '+widget.chatID);
    print('sender id - '+widget.sender.id);
    print('receiver id - '+widget.receiver.id);
    String token=await getToken_praf();
    print('token - $token');
  }
   _start() async {
     try {
       await _recorder?.start();
       var recording = await _recorder?.current(channel: 0);
       setState(() {
         _current = recording;
       });

       const tick = const Duration(milliseconds: 50);
       new Timer.periodic(tick, (Timer t) async {
         if (_currentStatus == RecordingStatus.Stopped) {
           t.cancel();
         }

         var current = await _recorder?.current(channel: 0);
         // print(current.status);
         setState(() {
           _current = current;
           _currentStatus = _current!.status!;
         });
       });
     } catch (e) {
       print(e);
     }
   }
   _resume() async {
     await _recorder?.resume();
     setState(() {});
   }
   _pause() async {
     await _recorder?.pause();
     setState(() {});
   }
   _stop() async {
     var result = await _recorder?.stop();
     print("Stop recording: ${result?.path}");
     print("Stop recording: ${result?.duration}");
    // File file = widget.localFileSystem.file(result?.path);
     //File file =LocalFileSystem().file(result?.path);
    // print("File length: ${await file.length()}");
     chatController.isMicTapped.value=false;
     setState(() {
       _current = result;
       _voicePat=result?.path;
       _currentStatus = _current!.status!;
       _isPlaying = false;

     });
   }

   // Call to play audio from the beginning
   _audioPlayerStart() async {
     Source source = DeviceFileSource(_current!.path!);
     await audioPlayer.play(source);

   }


   Widget _buildText(RecordingStatus status) {
     var text = "";
     switch (_currentStatus) {
       case RecordingStatus.Initialized:
         {
           text = 'Start';
           break;
         }
       case RecordingStatus.Recording:
         {
           text = 'Pause';
           break;
         }
       case RecordingStatus.Paused:
         {
           text = 'Resume';
           break;
         }
       case RecordingStatus.Stopped:
         {
           text = 'Init';
           break;
         }
       default:
         break;
     }
     return Text(text, style: TextStyle(color: Colors.black));
   }

   Future<void> _play() async {
     Source source = DeviceFileSource(_current!.path!);
          await audioPlayer.play(source);
     setState(() {
       _isPlaying = true;
     });
   }
   @override
  void dispose() {
    unregisterEvent('new-message');
    audioPlayer.dispose();
    super.dispose();
  }
}


