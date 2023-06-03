import 'dart:convert';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
        _playNextSong();
      }
    });
  }

  void _initializeSongDetails(Songs song) {
    title = song.title;
    author = song.author;
    thumbnail = song.thumbnail;
    streamlink = song.streamlinks[0].url;
    advancedPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    advancedPlayer.dispose();
    Navigator.pop(context);
  }

  Future<void> _playNextSong() async {
    final response = await http.get(Uri.parse(
        "https://ytmusic-tau.vercel.app/next/${widget.song.videoid}"));
    var data = jsonDecode(response.body.toString());
    setState(() {
      author = data[0]["author"];
      title = data[0]["title"];
      thumbnail = data[0]["thumbnail"];
      advancedPlayer.setUrl(data[0]["streamlinks"][0]["url"]);
    });
  }

  Future<void> playMusic() async {
    AudioSource audioSource = LockCachingAudioSource(Uri.parse(streamlink));
    await advancedPlayer.setAudioSource(audioSource);
    advancedPlayer.play();
  }

  Future<void> _togglePlayback() async {
    if (advancedPlayer.playing) {
      await advancedPlayer.pause();
    } else {
      await advancedPlayer.play();
    }
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
      barHeight: 7.0,
      thumbRadius: 10.0,
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
        child: Container(
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
              Icons.arrow_back_ios,
              size: 25,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              advancedPlayer.dispose();
            },
          ),
          centerTitle: true,
          title: Text(
            'Player',
            style: GoogleFonts.poppins(
                fontSize: 20.0, fontWeight: FontWeight.w500),
          ),
          actions: [
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
              onPressed: () {},
            ),
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
                          _playNextSong();
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
                    ])
              ]),
              Container(
                width: 500,
                height: 60,
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Colors.black45)]),
                child: const Icon(
                  Icons.playlist_add,
                  color: Colors.white,
                  size: 30.0,
                ),
              )
            ]),
      ),
    ));
  }
}
