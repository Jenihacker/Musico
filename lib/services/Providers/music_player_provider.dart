import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musico/models/response/player_res.dart';
import 'package:musico/models/song_info.dart';
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
  bool isNewSongSet = false;
  List<SongInfo> songs = [];
  String lyrics = "";
  ConcatenatingAudioSource? audio;

  void initializeSongDetails(String song) async {
    isNewSongSet = true;
    currentIndex = 0;
    await advancedPlayer.stop();
    audio = ConcatenatingAudioSource(children: []);
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
    songs.insert(
        0,
        SongInfo(
            title: songinfo!.title,
            author: songinfo.author,
            thumbnail: songinfo.thumbnail,
            streamlink: songinfo.streamlink,
            videoid: songinfo.videoid));
    await playMusic();
    final response1 = await http
        .get(Uri.parse("https://ytmusic-tau.vercel.app/playerplaylist/$song"));
    var data1 = jsonDecode(response1.body.toString());
    data1.shuffle();
    isNewSongSet = false;
    for (int i = 0; i < data1.length; i++) {
      if (!isNewSongSet) {
        await _addNewSong(data1[i], i + 1);
      } else {
        break;
      }
    }
    advancedPlayer.currentIndexStream.listen((event) {
      currentIndex = event ?? 0;
      getSongLyrics(songs[currentIndex].videoid);
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

  Future<void> _addNewSong(String vid, int index) async {
    SongDetailsRes? songinfo = await Player().getSongDetails(vid);
    try {
      if (!isNewSongSet) {
        await audio!.insert(
            index,
            AudioSource.uri(
              Uri.parse(songinfo!.streamlink),
              tag: MediaItem(
                // Specify a uniq ue ID for each media item:
                id: '${audio!.children.length}',
                // Metadata to display in the notification:
                album: songinfo.author,
                artist: songinfo.author,
                title: songinfo.title,
                artUri: Uri.parse(songinfo.thumbnail),
              ),
            ));
        songs.insert(
            index,
            SongInfo(
                title: songinfo.title,
                author: songinfo.author,
                thumbnail: songinfo.thumbnail,
                streamlink: songinfo.streamlink,
                videoid: songinfo.videoid));
      }
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
      notifyListeners();
    } else {
      final response = await http.get(Uri.parse(
          "https://ytmusic-tau.vercel.app/next/${songs[currentIndex].videoid}"));
      var data = jsonDecode(response.body.toString());
      if (songs[currentIndex].videoid == data[0]["videoid"]) {
        playNextSong();
      }
      songs.add(SongInfo(
          title: data[0]["title"],
          author: data[0]["author"],
          thumbnail: data[0]["thumbnail"],
          streamlink: data[0]["streamlinks"][0]["url"],
          videoid: data[0]["videoid"]));

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
      Uri.parse(songs[0].streamlink),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: '${0}',
        // Metadata to display in the notification:
        album: songs[0].author,
        artist: songs[0].author,
        title: songs[0].title,
        artUri: Uri.parse(songs[0].thumbnail),
      ),
    );
    await audio!.insert(0, metadata);
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
