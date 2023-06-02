import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio_cache/just_audio_cache.dart';
import 'package:music_player/modals/search_output.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/screens/search_screen.dart';
import 'package:http/http.dart' as http;

class PlayerScreen extends StatefulWidget {
  final Songs song;
  const PlayerScreen({super.key, required this.song});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  double _maxSliderValue = 0.0;
  AudioPlayer advancedPlayer = AudioPlayer();
  double _currentslidervalue = 0.0;
  bool _isLoop = false;
  bool _isMute = false;
  dynamic duration = 0.0;
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
        _currentslidervalue = event.inMilliseconds.toDouble();
      });
    });
    advancedPlayer.durationStream.listen((event) {
      _maxSliderValue = event?.inMilliseconds.toDouble() ?? 100.0;
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
    advancedPlayer.dispose();
    advancedPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    advancedPlayer.dispose();
  }

  Future<void> _playNextSong() async {
    advancedPlayer.clearCache();
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
    duration = await advancedPlayer.setUrl(streamlink);
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

  String _formatDuration(Duration duration) {
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget slider() {
    return Slider.adaptive(
      thumbColor: Colors.white,
      activeColor: Colors.white,
      autofocus: false,
      inactiveColor: const Color.fromARGB(201, 148, 148, 148),
      min: 0.0,
      max: advancedPlayer.duration?.inMilliseconds.toDouble() ?? 100.0,
      value: _currentslidervalue.clamp(0, _maxSliderValue),
      onChanged: (double value) {
        setState(() {
          advancedPlayer.seek(Duration(milliseconds: value.toInt()));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Duration totalDuration = advancedPlayer.duration ?? Duration.zero;
    Duration currentPosition =
        Duration(milliseconds: _currentslidervalue.toInt());

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
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return const SearchScreen();
                  },
                ));
              },
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
              Column(
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
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(currentPosition),
                              style: GoogleFonts.poppins(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                          Text(_formatDuration(totalDuration),
                              style: GoogleFonts.poppins(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                        ])),
                slider(),
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
