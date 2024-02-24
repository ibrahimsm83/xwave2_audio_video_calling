//
//
// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
//
// class AudioPlayerScreen extends StatefulWidget {
//   final String audioPath;
//   const AudioPlayerScreen({Key? key,required this.audioPath}) : super(key: key);
//
//   @override
//   State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
// }
//
// class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
//   final _player=AudioPlayer();
//
//   @override
//   void initState() {
//     print(widget.audioPath);
//    _setupAudioPlayer();
//     super.initState();
//   }
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           Text("Audio Player"),
//         _progressBarWidget(),
//         _playbackControlButton(),
//       ],),
//     );
//   }
//
//
// Widget _progressBarWidget(){
//     return StreamBuilder(stream: _player.positionStream, builder: (context,snapshot){
//       return ProgressBar(
//           progress: snapshot.data??Duration.zero,
//           buffered: _player.bufferedPosition,
//           total: _player.duration??Duration.zero,
//
//       );
//     });
// }
//   Widget _playbackControlButton() {
//     return StreamBuilder<PlayerState>(
//         stream: _player.playerStateStream,
//         builder: (context, snapshot) {
//           final processingState = snapshot.data?.processingState;
//           final playing=snapshot.data?.playing;
//           if(processingState==ProcessingState.loading|| processingState==ProcessingState.buffering){
//             return Container(
//               margin: EdgeInsets.all(8.0),
//               width: 64,
//               height: 64,
//               child: CircularProgressIndicator(),
//             );
//           }else if(playing !=null){
//             return IconButton(onPressed: _player.play,
//                 iconSize: 64,
//                 icon: Icon(Icons.play_arrow));
//           }else if(processingState != ProcessingState.completed){
//             return IconButton(onPressed: _player.pause,
//                 iconSize: 64,
//                 icon: Icon(Icons.pause));
//           }else{
//             //Replay
//             return IconButton(onPressed: ()=>_player.seek(Duration.zero),
//                 iconSize: 64,
//                 icon: Icon(Icons.replay));
//           }
//
//         });
//   }
//
//   Future<void> _setupAudioPlayer() async{
//     _player.playbackEventStream.listen((event) { },
//         onError: (Object e,StackTrace stacktrace){
//           print("A stream error occurred $e");
//         });
//     try{
//       print("--------------333------1------");
//       // Source source = DeviceFileSource(_current!.path!);
//           await _player.setFilePath(widget.audioPath);
//           print("--------------333------------");
//           await _player.play();
//
//       //await _player.setAudioSource(widget.audioPath);
//     }catch(e){
//       print("Error Loading audio Source $e");
//     }
//   }
//
// }
//
//
