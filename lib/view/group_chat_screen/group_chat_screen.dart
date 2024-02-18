import 'dart:async';
import 'dart:io';
import 'dart:io' as io;
import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chat_app_with_myysql/controller/user/dashboard_controller.dart';
import 'package:chat_app_with_myysql/model/ChatModel.dart';
import 'package:chat_app_with_myysql/model/group_messages_model.dart';
import 'package:chat_app_with_myysql/model/interface.dart';
import 'package:chat_app_with_myysql/resources/myColors.dart';
import 'package:chat_app_with_myysql/service/network/ApiService.dart';
import 'package:chat_app_with_myysql/service/network/SocketManager.dart';
import 'package:chat_app_with_myysql/util/config.dart';
import 'package:chat_app_with_myysql/view/group_chat_screen/chat_components.dart';
import 'package:chat_app_with_myysql/view/group_chat_screen/components.dart';
import 'package:chat_app_with_myysql/view/group_chat_screen/controller.dart';
import 'package:chat_app_with_myysql/widget/ChatHolder.dart';
import 'package:chat_app_with_myysql/widget/my_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../service/socket.dart';

class GroupChatScreen extends StatefulWidget {
  String? groupImage;
  String? title;
  String? userCount;
  String? groupId;

  GroupChatScreen(
      {Key? key, this.groupImage, this.title, this.userCount, this.groupId})
      : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen>  with SocketMessageHandler {
  ApiService apiService = ApiService();
 late GroupMessageController groupChatController =
      Get.put(GroupMessageController());
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  ///Video Picker
  File? galleryFile;
  final picker = ImagePicker();

  ///AudioRecorder
  AnotherAudioRecorder? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  PlayerState playerState = PlayerState.stopped;

  String? _voicePat;
  bool _isPlaying = false;
  // final SocketService socket_service =
  // SocketService('https://xwavetechnologies.com');
 // final SocketService socketService=SocketService(AppConfig.SERVER);
  @override
  void initState() {
    super.initState();
    groupChatController =
        Get.put(GroupMessageController());
    // valuesPrint();
    // registerEvent('newGroupMessage', groupChatController.msgListner);
    //registerEvent('new-message',groupChatController.msgListner);

    dashboardController.socketService.emitData(SocketEvent.GROUP_CHAT_ROOM_JOIN,widget.groupId!);
    print("connectSocket connect successfully---");
    dashboardController.socketService.addEvent(SocketEvent.NEW_GROUP_MESSAGE);
    _init();

    groupChatController.fetchChat(widget.groupId!);
  }


  @override
  void dispose() {
   dashboardController.socketService.removeEvent(SocketEvent.NEW_GROUP_MESSAGE);
   //unregisterEvent('newGroupMessage');
    //unregisterEvent('new-group-chat');
    // audioPlayer.dispose();
    super.dispose();
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
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();
        _recorder =
            AnotherAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder?.initialized;
        // after initialization
        var current = await _recorder?.current(channel: 0);
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

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  getVideo(ImageSource.gallery, context);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getVideo(ImageSource.camera, context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarForChatScreen(context,
          image: widget.groupImage!,
          title: widget.title!,
          subtitle: widget.userCount),
      backgroundColor: AppColor.appBlack,
      resizeToAvoidBottomInset: true,
      body: Obx(
        () => Column(
          children: [
            //myappBar(),
            chatListWight(),
            Visibility(
              visible: !groupChatController.isMicTapped.value,
              child: chatOptionsWight(context),
              replacement: audioRecordingSheetWight(),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatListWight() {
    return Expanded(
      child: ListView.builder(
        controller: groupChatController.scrollController,
        itemCount: groupChatController.groupChatList.length,
        itemBuilder: (context, index) {
          GroupMessages model = groupChatController.groupChatList[index];
          if (model.sender!.sId == dashboardController.user_model!.id) {
            //if(model.sender.id==widget.senderId) {
            ///Right
            return Align(
                alignment: Alignment.centerRight,
                child: GroupChatHolder(model: model, chatBoxColor: appYellow));
          } else {
            ///Left
            return Align(
                alignment: Alignment.centerLeft,
                child:
                    GroupChatHolder(model: model, chatBoxColor: applightWhite));
          }
        },
      ),
    );
  }

  Widget chatOptionsWight(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.emoji_emotions_outlined)),
        chatInputWight(context),
        Visibility(
          visible: !groupChatController.isLoading.value,
          replacement: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: appYellow,
            ),
          ),
          child: IconButton(
              onPressed: () {
                groupChatController.sendMessageApi(widget.groupId!);
              },
              icon: Icon(
                Icons.send,
                color: appYellow,
              )),
        )
      ],
    );
  }

  Widget audioRecordingSheetWight() {
    return Row(
      children: [
        chatInputAudioWight(),
        Visibility(
          visible: !groupChatController.isLoading.value,
          replacement: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: appYellow,
            ),
          ),
          child: IconButton(
              onPressed: () async {
                if (_currentStatus != RecordingStatus.Unset) {
                  // _stop();
                  var result = await _recorder?.stop();
                  groupChatController.sendMessageApi(widget.groupId!,isVoice: true,voiceFile: result?.path);
                  groupChatController.isMicTapped.value = false;
                } else {
                  null;
                }
              },
              icon: Icon(
                Icons.send,
                color: appYellow,
              )),
        )
      ],
    );
  }

  Widget chatInputWight(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: my_inputWithHint(
                controler: groupChatController.messageController,
                hint: 'Message',
              ),
            )),
            InkWell(
              onTap: () {
                _showPicker(context: context);
              },
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(Icons.attach_file),
              ),
            ),
            InkWell(
              onTap: () {
                groupChatController.sendMessageApi(widget.groupId!,isImage: true);
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(Icons.camera_alt_outlined),
              ),
            ),
            InkWell(
              onTap: () {
                print("mic button tapped..");
                if (_currentStatus == RecordingStatus.Initialized) {
                  _start();
                  groupChatController.isMicTapped.value = true;
                } else if (_currentStatus == RecordingStatus.Stopped) {
                  _init();
                } else {
                  _start();
                  groupChatController.isMicTapped.value = true;
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(Icons.mic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatInputAudioWight() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
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
                onTap: () {
                  print("mic button tapped..");
                  groupChatController.isMicTapped.value = false;
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
            ],
          ),
        ),
      ),
    );
  }

  Future getVideo(ImageSource img, BuildContext context) async {
    final pickedFile = await picker.pickVideo(
        source: img,
        preferredCameraDevice: CameraDevice.front,
        maxDuration: const Duration(minutes: 10));
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
          if (galleryFile != null) {
            groupChatController.sendMessageApi(widget.groupId!,isVideo: true,videoPath: galleryFile!.path);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
