import 'package:audioplayers/audioplayers.dart';

class MyAudioPlayer{


  final AudioPlayer _audioPlayer=AudioPlayer();


  bool _isloaded=false,_isplaying=false;


/*  Future<void> loadFromAsset(String url,{bool loop=false}) async{
    // await _audioPlayer.setSource(UrlSource(url));
    print("audio asset url: $url");
    _isloaded=false;
    await _audioPlayer.setSource(AssetSource(url));
    await _audioPlayer.setReleaseMode(loop?ReleaseMode.loop:ReleaseMode.stop);
    _isloaded=true;
  }*/

  Future<void> loadFromAsset(String url,{bool loop=false, double rate=1.0,}) async{
    // await _audioPlayer.setSource(UrlSource(url));
    print("audio asset url: $url");
    _isloaded=false;
    await _audioPlayer.setSource(AssetSource(url.replaceAll("assets/", "")));
    await _audioPlayer.setReleaseMode(loop?ReleaseMode.loop:ReleaseMode.stop);
    _isloaded=true;
    print("audio loaded");
  }


  bool get isloaded => _isloaded;

  get isplaying => _isplaying;

  void play(){
    _isplaying=true;
    _audioPlayer.resume();
  }

  void pause(){
    _isplaying=false;
    _audioPlayer.pause();
  }

  void playPause(){
    if(!_isplaying) {
      play();
    }
    else{
      pause();
    }
  }

  void stop(){
    _isplaying=false;
    _audioPlayer.stop();
  }

  void dispose(){
    _audioPlayer.dispose();
    _isloaded=false;
  }

}