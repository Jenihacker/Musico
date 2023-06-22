import 'dart:convert';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_player/modals/search_output.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;

class PlayerScreen extends StatefulWidget {
  final Songs song;
  const PlayerScreen({super.key, required this.song});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  AudioPlayer advancedPlayer = AudioPlayer();
  Duration _currentslidervalue = Duration.zero;
  bool _isLoop = false;
  bool _isMute = false;
  String title = "";
  String author = "";
  String thumbnail = "";
  String streamlink = "";
  String videoid = "";
  late ConcatenatingAudioSource audio;

  @override
  void initState() {
    super.initState();
    _initializeSongDetails(widget.song);
    playMusic();
    advancedPlayer.positionStream.listen((event) {
      setState(() {
        _currentslidervalue = event;
      });
    });
    advancedPlayer.setVolume(1.0);
    advancedPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _playNextSong(videoid);
      }
    });
  }

  void _initializeSongDetails(Songs song) {
    title = song.title;
    author = song.author;
    thumbnail = song.thumbnail;
    streamlink = song.streamlinks[0].url;
    videoid = song.videoid;
  }

  @override
  void dispose() {
    super.dispose();
    advancedPlayer.dispose();
  }

  //play next song
  Future<void> _playNextSong(String vid) async {
    final response =
        await http.get(Uri.parse("https://ytmusic-tau.vercel.app/next/$vid"));
    var data = jsonDecode(response.body.toString());
    if (vid == data[0]["videoid"]) {
      _playNextSong(vid);
    }
    setState(() {
      author = data[0]["author"];
      title = data[0]["title"];
      thumbnail = data[0]["thumbnail"];
      videoid = data[0]["videoid"];
    });
    AudioSource metadata = AudioSource.uri(
      Uri.parse(data[0]["streamlinks"][0]["url"]),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: '${advancedPlayer.currentIndex! + 1}',
        // Metadata to display in the notification:
        album: data[0]["author"],
        title: data[0]["title"],
        artUri: Uri.parse(data[0]["thumbnail"]),
      ),
    );
    audio.add(metadata);
    await advancedPlayer.seekToNext();
    advancedPlayer.play();
    //advancedPlayer.seekToNext();
  }

  //initial music playback
  Future<void> playMusic() async {
    AudioSource metadata = AudioSource.uri(
      Uri.parse(streamlink),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: '1',
        // Metadata to display in the notification:
        album: author,
        title: title,
        artUri: Uri.parse(thumbnail),
      ),
    );
    audio = ConcatenatingAudioSource(children: [metadata]);
    advancedPlayer.setAudioSource(audio);
    advancedPlayer.play();
  }

  //play or pause music
  Future<void> _togglePlayback() async {
    advancedPlayer.playing
        ? await advancedPlayer.pause()
        : await advancedPlayer.play();
  }

  Future<void> _setloop() async {
    if (_isLoop == false) {
      await advancedPlayer.setLoopMode(LoopMode.one);
      setState(() {
        _isLoop = true;
      });
    } else {
      await advancedPlayer.setLoopMode(LoopMode.off);
      setState(() {
        _isLoop = false;
      });
    }
  }

  Future<void> _setMute() async {
    if (_isMute == false) {
      await advancedPlayer.setVolume(0.0);
      setState(() {
        _isMute = true;
      });
    } else {
      await advancedPlayer.setVolume(1.0);
      setState(() {
        _isMute = false;
      });
    }
  }

  Widget slider() {
    return ProgressBar(
      progress: _currentslidervalue,
      buffered: advancedPlayer.bufferedPosition,
      total: advancedPlayer.duration ?? Duration.zero,
      progressBarColor: const Color.fromARGB(255, 255, 203, 220),
      baseBarColor: Colors.white.withOpacity(0.24),
      bufferedBarColor: Colors.white.withOpacity(0.3),
      thumbColor: Colors.white,
      thumbGlowColor: Colors.white24,
      barHeight: 6.0,
      thumbRadius: 8.0,
      timeLabelLocation: TimeLabelLocation.above,
      timeLabelPadding: 5.0,
      timeLabelTextStyle:
          GoogleFonts.poppins(fontSize: 16.0, fontWeight: FontWeight.bold),
      onSeek: (duration) {
        advancedPlayer.seek(duration);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color(0XFF242424),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade800.withOpacity(0.8),
              Colors.deepPurple.shade200.withOpacity(0.8),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 35,
              ),
              onPressed: () {
                advancedPlayer.dispose();
                Get.back();
              },
            ),
            centerTitle: true,
            title: Text(
              'Now Playing',
              style: GoogleFonts.poppins(
                  fontSize: 20.0, fontWeight: FontWeight.w400),
            ),
            actions: [
              PopupMenuButton(
                icon: const FaIcon(FontAwesomeIcons.ellipsisVertical,
                    color: Colors.white),
                color: const Color(0XFF242424),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: Text(
                      'sample 1',
                    ),
                  ),
                  const PopupMenuItem(
                      child: Text(
                    'sample 2',
                  )),
                  const PopupMenuItem(
                      child: Text(
                    'sample 3',
                  ))
                ],
              )
            ],
          ),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: Image.network(
                        thumbnail,
                        width: 320.0,
                        height: 300.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    children: [
                      SizedBox(
                        child: Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          author,
                          style: GoogleFonts.poppins(
                            fontSize: 20.0,
                            color: Colors.white60,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, bottom: 15.0),
                    child: slider(),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Icon(
                            _isMute ? Icons.volume_off : Icons.volume_up,
                            color: Colors.white,
                            size: 35.0,
                          ),
                          onTap: () {
                            _setMute();
                          },
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(20.0),
                          child: const Icon(
                            Icons.skip_previous_rounded,
                            color: Colors.white,
                            size: 50.0,
                          ),
                          onTap: () {
                            setState(() {
                              advancedPlayer.seek(Duration.zero);
                            });
                          },
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Icon(
                            advancedPlayer.playing
                                ? Icons.pause_circle
                                : Icons.play_circle,
                            color: Colors.white,
                            size: 80.0,
                          ),
                          onTap: () {
                            _togglePlayback();
                          },
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(20.0),
                          onTap: () async {
                            _playNextSong(videoid);
                          },
                          child: const Icon(
                            Icons.skip_next_rounded,
                            color: Colors.white,
                            size: 50.0,
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(20.0),
                          onTap: () {
                            _setloop();
                          },
                          child: Icon(
                            _isLoop ? Icons.repeat_one : Icons.repeat,
                            color: Colors.white,
                            size: 35.0,
                          ),
                        )
                      ]),
                ]),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.075,
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      boxShadow: [BoxShadow(color: Colors.black45)]),
                  child: IconButton(
                    icon: const Icon(Icons.playlist_play_outlined),
                    color: Colors.white,
                    iconSize: 30,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: const Color.fromARGB(255, 55, 13, 140),
                        builder: (context) {
                          return SizedBox(
                            height: 500,
                            child: ListTile(
                              leading: Image.network(thumbnail),
                              title: Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitle: Text(author),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ]),
        ),
      ),
    ));
  }
}
