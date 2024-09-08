import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler, QueueHandler {
  final _player = AudioPlayer();
  final _songQueue = ConcatenatingAudioSource(children: []);

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();
  
  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);
  
  @override
  Future<void> skipToQueueItem(int index) => _player.seek(Duration.zero, index: index);

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {

  }
}