import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
//import 'package:musico/services/remote_services.dart';

class MyAudioHandler extends BaseAudioHandler
    with
        QueueHandler, // mix in default queue callback implementations
        SeekHandler {

  String videoId;
  

  MyAudioHandler({required this.videoId}) {
    AudioPlayer _advancedPlayer = AudioPlayer();
    ConcatenatingAudioSource _audioSource =
        ConcatenatingAudioSource(children: []);
    getSongs();
  }

  
  

  getSongs () async{
    //songs = await RemoteServices().getSongDetails(videoId);
    
  }
   
  
  Future<void> pause() async {}
  Future<void> stop() async {}
  Future<void> seek(Duration position) async {}
  Future<void> skipToQueueItem(int i) async {}

}
