import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musico/models/response/player_res.dart';
import 'package:musico/services/api/lyrics_api.dart';
import 'package:musico/services/api/player_api.dart';

class MusicPlayerProvider extends ChangeNotifier {
  AudioPlayer advancedPlayer = AudioPlayer(
    handleInterruptions: true,
    androidApplyAudioAttributes: true,
  );
  Duration currentslidervalue = Duration.zero;
  bool isLoop = false;
  bool isMute = false;
  bool isPlaying = false;
  int currentIndex = 0;
  List<String> title = [""];
  List<String> author = [""];
  List<String> thumbnail = [""];
  List<String> streamlink = [""];
  List<String> videoid = [""];
  String lyrics = "";
  ConcatenatingAudioSource? audio;

  void initializeSongDetails(String song) async {
    advancedPlayer.stop();
    audio = ConcatenatingAudioSource(children: []);
    if (audio != null) {
      await audio?.clear();
    }
    title = [""];
    author = [""];
    thumbnail = [""];
    streamlink = [""];
    videoid = [""];
    advancedPlayer.playingStream.listen((event) {
      isPlaying = event;
      notifyListeners();
    });
    advancedPlayer.automaticallyWaitsToMinimizeStalling;
    advancedPlayer.positionStream.listen((event) {
      currentslidervalue = event;
      notifyListeners();
    });
    advancedPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        playNextSong();
      }
      notifyListeners();
    });
    SongDetailsRes? songinfo = await Player().getSongDetails(song);
    title[0] = songinfo!.title;
    author[0] = songinfo.author;
    thumbnail[0] = songinfo.thumbnail;
    streamlink[0] = songinfo.streamlink;
    videoid[0] = songinfo.videoid;
    playMusic();
    final response1 = await http
        .get(Uri.parse("https://ytmusic-tau.vercel.app/playerplaylist/$song"));
    var data1 = jsonDecode(response1.body.toString());
    data1.shuffle();
    for (int i = 0; i < data1.length; i++) {
      await _addNewSong(data1[i]);
    }
    advancedPlayer.currentIndexStream.listen((event) {
      currentIndex = event ?? 0;
      getSongLyrics(videoid[currentIndex]);
      notifyListeners();
    });
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    advancedPlayer.stop();
    advancedPlayer.dispose();
  }

  keyboardKey(RawKeyEvent value) {
    if (value.isKeyPressed(LogicalKeyboardKey.space)) {
      togglePlayback();
    } else if (value.isKeyPressed(LogicalKeyboardKey.keyM)) {
      setMute();
    } else if (value.isKeyPressed(LogicalKeyboardKey.keyR)) {
      setloop();
    } else if (value.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
      playPrevSong();
    } else if (value.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
      playNextSong();
    }
    notifyListeners();
  }

  Future<void> playPrevSong() async {
    if (advancedPlayer.hasPrevious) {
      await advancedPlayer.seekToPrevious();
    } else {
      advancedPlayer.seek(Duration.zero);
    }
    notifyListeners();
  }

  Future<void> _addNewSong(String vid) async {
    SongDetailsRes? songinfo = await Player().getSongDetails(vid);
    author.add(songinfo!.author);
    title.add(songinfo.title);
    thumbnail.add(songinfo.thumbnail);
    videoid.add(songinfo.videoid);
    try {
      AudioSource metadata = AudioSource.uri(
        Uri.parse(songinfo.streamlink),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: '${audio!.children.length}',
          // Metadata to display in the notification:
          album: songinfo.author,
          artist: songinfo.author,
          title: songinfo.title,
          artUri: Uri.parse(songinfo.thumbnail),
        ),
      );
      await audio!.add(metadata);
    } catch (e, stacktrace) {
      print('$e $stacktrace');
    }
    notifyListeners();
  }

  //play next song
  Future<void> playNextSong() async {
    if (advancedPlayer.hasNext) {
      await advancedPlayer.pause();
      await advancedPlayer.seekToNext();
      await advancedPlayer.play();
    } else {
      final response = await http.get(Uri.parse(
          "https://ytmusic-tau.vercel.app/next/${videoid[currentIndex]}"));
      var data = jsonDecode(response.body.toString());
      if (videoid[currentIndex] == data[0]["videoid"]) {
        playNextSong();
      }
      author.add(data[0]["author"]);
      title.add(data[0]["title"]);
      thumbnail.add(data[0]["thumbnail"]);

      videoid.add(data[0]["videoid"]);

      AudioSource metadata = AudioSource.uri(
        Uri.parse(data[0]["streamlinks"][0]["url"]),
        tag: MediaItem(
          // Specify a unique ID for each media item:
          id: '${audio!.children.length}',
          // Metadata to display in the notification:
          album: data[0]["author"],
          artist: data[0]["author"],
          title: data[0]["title"],
          artUri: Uri.parse(data[0]["thumbnail"]),
        ),
      );
      await audio!.add(metadata);
      advancedPlayer.seekToNext();
      advancedPlayer.play();
    }
    notifyListeners();
  }

  //initial music playback
  Future<void> playMusic() async {
    AudioSource metadata = AudioSource.uri(
      Uri.parse(streamlink[0]),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: '${0}',
        // Metadata to display in the notification:
        album: author[0],
        artist: author[0],
        title: title[0],
        artUri: Uri.parse(thumbnail[0]),
      ),
    );
    audio = ConcatenatingAudioSource(children: []);
    await audio!.add(metadata);
    await advancedPlayer.setAudioSource(audio!);
    advancedPlayer.play();
    notifyListeners();
  }

  //play or pause music
  Future<void> togglePlayback() async {
    isPlaying ? await advancedPlayer.pause() : await advancedPlayer.play();
    notifyListeners();
  }

  Future<void> setloop() async {
    if (isLoop == false) {
      await advancedPlayer.setLoopMode(LoopMode.one);
      isLoop = true;
    } else {
      await advancedPlayer.setLoopMode(LoopMode.off);
      isLoop = false;
    }
    notifyListeners();
  }

  Future<void> setMute() async {
    if (isMute == false) {
      await advancedPlayer.setVolume(0.0);
      isMute = true;
    } else {
      await advancedPlayer.setVolume(1.0);
      isMute = false;
    }
    notifyListeners();
  }

  Future<String> getSongLyrics(String vid) async {
    lyrics = await Lyrics().getLyrics(vid);
    lyrics = lyrics;
    return lyrics;
  }
}
