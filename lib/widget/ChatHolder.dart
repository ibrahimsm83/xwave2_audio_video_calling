
import 'package:audioplayers/audioplayers.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import '../Models/ChatModel.dart';
import 'myText.dart';

// ignore: camel_case_types
class chatHolder extends StatefulWidget {



  final ChatModel model;
  final Color chatBoxColor;
  const chatHolder({super.key, required this.model, required this.chatBoxColor});

  @override
  State<chatHolder> createState() => _chatHolderState();
}

class _chatHolderState extends State<chatHolder> {
  AudioPlayer audioPlayer = AudioPlayer();
  late VideoPlayerController _controller;
  bool isPlaying=false;
  Duration duration=Duration.zero;
  Duration position=Duration.zero;
  late Chewie _chewie;
  late ChewieController _chewieController;

  @override
  void initState() {


     /// Set up listeners for player state changes
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        // playerState = state;
        isPlaying = state == PlayerState.playing;
      });
    });

    /// Listen to Audio Duration
    audioPlayer.onDurationChanged.listen((Duration newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    /// Listen to Audio position
    audioPlayer.onPositionChanged.listen((Duration newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    ///Video player controller initalize
    /////'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
    if(widget.model.mediaType=="video") {
      _controller = VideoPlayerController.networkUrl(Uri.parse(
          widget.model.url))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: false,
        looping: false,
      );
      _chewie = Chewie(
        controller: _chewieController,
      );
      _chewieController.addListener(() {
        if (!_chewieController.isFullScreen) {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        }
      });
    }else{

    }

    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime=DateTime.parse(widget.model.time);
    return widget.model.mediaType == "none"
        ? textWidget(dateTime)
        : widget.model.mediaType == "audio"
            ? audioWidget(dateTime): widget.model.mediaType=="video"? videoWidget(dateTime)
            : imageWidget(dateTime);
  }

  Widget textWidget(DateTime dateTime) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.chatBoxColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
                 Container(
                  child: myText(text: widget.model.content,
                    size: 16,
                    fontWeight: FontWeight.w500,),
          constraints:BoxConstraints(
            minWidth: 0.0,
            maxWidth: MediaQuery.of(context).size.width/1.5,
                ),
              ),
              myText(text: DateFormat('HH:mm').format(dateTime),
                size: 11,
                color: Colors.black38,)
            ],),
        ),
      ),
    );
  }

  Widget imageWidget(DateTime dateTime) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
            decoration: BoxDecoration(
              color: widget.chatBoxColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (childContext) => Scaffold(
                            body: PhotoView(
                              imageProvider: NetworkImage(widget.model.url),
                            ),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.network(
                          widget.model.url,
                          fit: BoxFit.fitWidth,
                          height: 300,
                          width: 250,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: myText(
                        text: DateFormat('HH:mm').format(dateTime),
                        size: 11,
                        color: Colors.black38,
                      ),
                    )
                  ],
                ))));
  }

  Widget audioWidget(DateTime dateTime){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width/1.5,
        decoration: BoxDecoration(
         color:  widget.chatBoxColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                    } else {
                      await audioPlayer.play(UrlSource(widget.model.url));
                    }
                  },
                  icon: Icon( isPlaying? Icons.pause:Icons.play_arrow),
                ),
                Flexible(
                  child: Slider(
                    value: position.inSeconds.toDouble(),
                    onChanged: (double value) async{
                      final position=Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);
                      ///Optional : play audio if Was Paused
                      await audioPlayer.resume();
                      //_seekTo(value);
                    },
                    min: 0.0,
                    max: duration.inSeconds.toDouble(),
                  ),
                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0,bottom: 2.0),
              child: myText(text: DateFormat('HH:mm').format(dateTime),
                size: 11,
                color: Colors.black38,),
            )
          ],
        ),
      ),
    );
  }

  Widget videoWidget(DateTime dateTime) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          width: 340,
          decoration: BoxDecoration(
            color:  widget.chatBoxColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding:  const EdgeInsets.fromLTRB(5,5,5,5),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _controller.value.isInitialized?
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Chewie(
                  controller: _chewieController,
                ),
              )
                  :Center(
                  child: SizedBox(
                      height: 30.0,
                      width: 30.0,
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                          strokeWidth: 2.0))),
              Padding(
                padding: const EdgeInsets.only(right: 8.0,bottom: 2.0),
                child: myText(text: DateFormat('HH:mm').format(dateTime),
                  size: 11,
                  color: Colors.black38,),
              )
            ],
          )
      ),
    );
  }
}