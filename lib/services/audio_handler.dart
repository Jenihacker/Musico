import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mycompany.myapp.audio',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class AudioPlayerHandler extends BaseAudioHandler with QueueHandler {
  final _advancedPlayer = AudioPlayer();

  

  @override
  Future<void> play() async {
    _advancedPlayer.play();
  }

  @override
  Future<void> pause() async {
    _advancedPlayer.pause();
  }
}
