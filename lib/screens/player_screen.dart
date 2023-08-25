import 'dart:convert';
import 'dart:ui'; //https://dribbble.com/shots/19179064-Music-App
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:musico/modals/lyrics.dart';
import 'package:shimmer/shimmer.dart';
import 'package:marquee/marquee.dart';

class PlayerScreen extends StatefulWidget {
  final String vd;
  const PlayerScreen({super.key, required this.vd});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  AudioPlayer advancedPlayer = AudioPlayer(
    handleInterruptions: true,
    androidApplyAudioAttributes: true,
  );
  Duration _currentslidervalue = Duration.zero;
  bool _isLoop = false;
  bool _isMute = false;
  List<String> title = [""];
  List<String> author = [""];
  List<String> thumbnail = [""];
  List<String> streamlink = [""];
  List<String> videoid = [""];
  late Lyrics lyrics;
  late ConcatenatingAudioSource audio;

  @override
  void initState() {
    super.initState();
    _initializeSongDetails(widget.vd);
    advancedPlayer.positionStream.listen((event) {
      setState(() {
        _currentslidervalue = event;
      });
    });
    advancedPlayer.setVolume(1.0);
    advancedPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _playNextSong(videoid[advancedPlayer.currentIndex ?? 0]);
      }
    });
  }

  void _initializeSongDetails(String song) async {
    final response = await http
        .get(Uri.parse("https://ytmusic-tau.vercel.app/songdetails/$song"));
    var data = jsonDecode(response.body.toString());
    title[0] = data[0]["title"];
    author[0] = data[0]["author"];
    thumbnail[0] = data[0]["thumbnail"];
    streamlink[0] = data[0]["streamlinks"][0]["url"];
    videoid[0] = data[0]["videoid"];
    playMusic();
    final response1 = await http
        .get(Uri.parse("https://ytmusic-tau.vercel.app/playerplaylist/$song"));
    var data1 = jsonDecode(response1.body.toString());
    data1.shuffle();
    for (int i = 0; i < data1.length; i++) {
      await _addNewSong(data1[i]);
    }
  }

  @override
  void dispose() {
    super.dispose();
    advancedPlayer.stop();
    advancedPlayer.dispose();
  }

  _keyboardKey(RawKeyEvent value) {
    if (value.isKeyPressed(LogicalKeyboardKey.space)) {
      _togglePlayback();
    } else if (value.isKeyPressed(LogicalKeyboardKey.keyM)) {
      _setMute();
    } else if (value.isKeyPressed(LogicalKeyboardKey.keyR)) {
      _setloop();
    } else if (value.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
      _playPrevSong();
    } else if (value.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
      _playNextSong(videoid[advancedPlayer.currentIndex ?? 0]);
    }
  }

  Future<void> _playPrevSong() async {
    if (advancedPlayer.hasPrevious) {
      //await advancedPlayer.pause();
      await advancedPlayer.seekToPrevious();
      //await advancedPlayer.play();
    } else {
      advancedPlayer.seek(Duration.zero);
    }
  }

  Future<void> _addNewSong(String vid) async {
    final response = await http
        .get(Uri.parse("https://ytmusic-tau.vercel.app/songdetails/$vid"));
    var data = jsonDecode(response.body.toString());
    author.add(data[0]["author"]);
    title.add(data[0]["title"]);
    thumbnail.add(data[0]["thumbnail"]);
    videoid.add(data[0]["videoid"]);
    AudioSource metadata = AudioSource.uri(
      Uri.parse(data[0]["streamlinks"][0]["url"]),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: '${audio.children.length + 1}',
        // Metadata to display in the notification:
        album: data[0]["author"],
        title: data[0]["title"],
        artUri: Uri.parse(data[0]["thumbnail"]),
      ),
    );
    try {
      await audio.add(metadata);
    } catch (e) {
      print(e);
    }
  }

  //play next song
  Future<void> _playNextSong(String vid) async {
    final response =
        await http.get(Uri.parse("https://ytmusic-tau.vercel.app/next/$vid"));
    var data = jsonDecode(response.body.toString());
    if (vid == data[0]["videoid"]) {
      _playNextSong(vid);
    }
    author.add(data[0]["author"]);
    title.add(data[0]["title"]);
    thumbnail.add(data[0]["thumbnail"]);
    setState(() {
      videoid.add(data[0]["videoid"]);
    });
    AudioSource metadata = AudioSource.uri(
      Uri.parse(data[0]["streamlinks"][0]["url"]),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: '${audio.children.length + 1}',
        // Metadata to display in the notification:
        album: data[0]["author"],
        title: data[0]["title"],
        artUri: Uri.parse(data[0]["thumbnail"]),
      ),
    );
    await audio.add(metadata);
    advancedPlayer.seekToNext();
    advancedPlayer.play();
  }

  //initial music playback
  Future<void> playMusic() async {
    AudioSource metadata = AudioSource.uri(
      Uri.parse(streamlink[0]),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: '${1}',
        // Metadata to display in the notification:
        album: author[0],
        title: title[0],
        artUri: Uri.parse(thumbnail[0]),
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

  void _dragdownpop() async {
    await advancedPlayer.dispose();
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  Widget slider() {
    return ProgressBar(
      progress: _currentslidervalue,
      buffered: advancedPlayer.bufferedPosition,
      total: advancedPlayer.duration ?? Duration.zero,
      progressBarColor: const Color(0XFFC4FC4C),
      baseBarColor: Colors.white.withOpacity(0.24),
      bufferedBarColor: Colors.white.withOpacity(0.3),
      thumbColor: Colors.white,
      thumbGlowColor: Colors.white24,
      barHeight: 5.5,
      thumbRadius: 7.5,
      timeLabelLocation: TimeLabelLocation.above,
      timeLabelPadding: 5.0,
      timeLabelTextStyle: GoogleFonts.poppins(
          fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
      onSeek: (duration) {
        advancedPlayer.seek(duration);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (value) {
        _keyboardKey(value);
      },
      child: SafeArea(
          child: Dismissible(
        key: Key("$advancedPlayer.currentIndex"),
        direction: DismissDirection.down,
        onDismissed: (direction) => _dragdownpop(),
        child: Scaffold(
          backgroundColor: const Color(0XFF121212),
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: CachedNetworkImageProvider(
                        thumbnail[advancedPlayer.currentIndex ?? 0]))
                // gradient: LinearGradient(
                //   begin: Alignment.bottomRight,
                //   end: Alignment.topLeft,
                //   colors: [
                //     // Color(0XFFc31432),
                //     // Color(0XFF240b36),
                //     Colors.black,
                //     Colors.black
                //   ],
                // ),
                ),
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 10.0, sigmaY: 10.0, tileMode: TileMode.clamp),
                child: Scaffold(
                  backgroundColor: Colors.black54,
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
                      style: GoogleFonts.poppins(fontSize: 20.0),
                    ),
                    actions: [
                      // IconButton(
                      //   onPressed: () {
                      //     advancedPlayer.dispose();
                      //     Navigator.pop(context);
                      //     Navigator.pop(context);
                      //   },
                      //   icon: const Icon(Icons.search),
                      // ),
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
                  body: SingleChildScrollView(
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.0375),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CachedNetworkImage(
                                key: UniqueKey(),
                                placeholder: (context, url) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.white70,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.387,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.387,
                                      decoration: const BoxDecoration(
                                          color: Colors.black38),
                                    ),
                                  );
                                },
                                imageUrl:
                                    thumbnail[advancedPlayer.currentIndex ?? 0]
                                            .contains('?sqp=')
                                        ? thumbnail[
                                                advancedPlayer.currentIndex ??
                                                    0]
                                            .split('?sqp=')[0]
                                        : thumbnail[
                                            advancedPlayer.currentIndex ?? 0],
                                width:
                                    MediaQuery.of(context).size.height * 0.387,
                                height:
                                    MediaQuery.of(context).size.height * 0.387,
                                fit: BoxFit.fill,
                                errorWidget: (context, url, error) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.white70,
                                    highlightColor: Colors.white,
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.387,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.387,
                                      decoration: const BoxDecoration(
                                          color: Colors.black38),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: Column(
                          children: [
                            SizedBox(
                                child: title[
                                            advancedPlayer.currentIndex ?? 0] !=
                                        ""
                                    ? title[advancedPlayer.currentIndex ?? 0]
                                                .length <=
                                            28
                                        ? Text(
                                            title[advancedPlayer.currentIndex ??
                                                0],
                                            style: GoogleFonts.poppins(
                                              fontSize: 25.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          )
                                        : SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            child: Marquee(
                                              accelerationCurve:
                                                  Curves.bounceIn,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w500),
                                              blankSpace: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              text: title[
                                                  advancedPlayer.currentIndex ??
                                                      0],
                                              scrollAxis: Axis.horizontal,
                                            ),
                                          )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 10.0),
                                        child: Shimmer.fromColors(
                                          baseColor: Colors.white24,
                                          highlightColor: Colors.white60,
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.024,
                                            width: 350.0,
                                            decoration: const BoxDecoration(
                                                color: Colors.black,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0))),
                                          ),
                                        ),
                                      )),
                            SizedBox(
                                child: author[
                                            advancedPlayer.currentIndex ?? 0] !=
                                        ""
                                    ? Text(
                                        author[
                                            advancedPlayer.currentIndex ?? 0],
                                        style: GoogleFonts.poppins(
                                          fontSize: 20.0,
                                          color: Colors.white60,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      )
                                    : Shimmer.fromColors(
                                        baseColor: Colors.white24,
                                        highlightColor: Colors.white60,
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.018,
                                          width: 350.0,
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                        ),
                                      )),
                          ],
                        ),
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 20.0),
                              child: slider(),
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Icon(
                                      _isMute
                                          ? Icons.volume_off
                                          : Icons.volume_up,
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
                                      _playPrevSong();
                                    },
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Icon(
                                      advancedPlayer.playing
                                          ? Icons.pause_circle_filled
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
                                      if (advancedPlayer.hasNext) {
                                        //await advancedPlayer.pause();
                                        await advancedPlayer.seekToNext();
                                        //await advancedPlayer.play();
                                      } else {
                                        _playNextSong(videoid[
                                            advancedPlayer.currentIndex ?? 0]);
                                      }
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15.0),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Color(0XFFC4FC4C),
                            //color: Color(0X5A240b36),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            boxShadow: [BoxShadow(color: Colors.black45)]),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, left: 15.0, right: 15.0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Text(
                                  'Lyrics',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.018,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.325,
                                child: SingleChildScrollView(
                                  child: FutureBuilder(
                                    future: getLyrics(videoid[
                                        advancedPlayer.currentIndex ?? 0]),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          lyrics.lyrics,
                                          style: GoogleFonts.poppins(
                                              fontSize: 21.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        );
                                      }
                                      try {
                                        return Text(
                                          lyrics.lyrics,
                                          style: GoogleFonts.poppins(
                                              fontSize: 21.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                        );
                                      } catch (e) {
                                        return const Text(
                                          'No Lyrics Found',
                                          style: TextStyle(color: Colors.black),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      )
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }

  Future<Lyrics> getLyrics(String vid) async {
    final response =
        await http.get(Uri.parse("https://ytmusic-tau.vercel.app/lyrics/$vid"));
    var data = jsonDecode(response.body.toString());
    lyrics = Lyrics.fromJson(data);
    if (response.statusCode == 200) {
      return lyrics;
    }
    return lyrics;
  }
}
