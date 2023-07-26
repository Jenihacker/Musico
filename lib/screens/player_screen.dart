import 'dart:convert';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:musico/screens/search_screen.dart';
import 'package:page_transition/page_transition.dart';
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
  String videoid = "";
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
        _playNextSong(videoid);
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
    videoid = data[0]["videoid"];
    playMusic();
  }

  @override
  void dispose() {
    super.dispose();
    advancedPlayer.stop();
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
    author.add(data[0]["author"]);
    title.add(data[0]["title"]);
    thumbnail.add(data[0]["thumbnail"]);
    setState(() {
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
    await audio.add(metadata);
    advancedPlayer.seekToNext();
    advancedPlayer.play();
    //advancedPlayer.seekToNext();
  }

  //initial music playback
  Future<void> playMusic() async {
    AudioSource metadata = AudioSource.uri(
      Uri.parse(streamlink[0]),
      tag: MediaItem(
        // Specify a unique ID for each media item:
        id: '1',
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
      progressBarColor: Colors.deepOrange,
      baseBarColor: Colors.white.withOpacity(0.24),
      bufferedBarColor: Colors.white.withOpacity(0.3),
      thumbColor: Colors.white,
      thumbGlowColor: Colors.white24,
      barHeight: 6.0,
      thumbRadius: 8.0,
      timeLabelLocation: TimeLabelLocation.above,
      timeLabelPadding: 5.0,
      timeLabelTextStyle: GoogleFonts.poppins(
          fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
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
    return SafeArea(
        child: Dismissible(
      key: Key("$advancedPlayer.currentIndex"),
      direction: DismissDirection.down,
      onDismissed: (direction) => _dragdownpop(),
      child: Scaffold(
        backgroundColor: const Color(0XFF242424),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Color(0XFFDE2342),
                Color(0XFF2E49D0),
              ],
            ),
          ),
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
                style: GoogleFonts.poppins(
                    fontSize: 20.0, fontWeight: FontWeight.w400),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    advancedPlayer.dispose();
                    Navigator.push(
                        context,
                        PageTransition(
                            child: const SearchScreen(),
                            type: PageTransitionType.rightToLeft));
                  },
                  icon: const Icon(Icons.search),
                ),
                /*
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
                */
              ],
            ),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.0375),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: CachedNetworkImage(
                          placeholder: (context, url) {
                            return Shimmer.fromColors(
                              baseColor: Colors.white70,
                              highlightColor: Colors.white,
                              child: Container(
                                height: 320.0,
                                width: 320.0,
                                decoration:
                                    const BoxDecoration(color: Colors.black38),
                              ),
                            );
                          },
                          imageUrl: thumbnail[advancedPlayer.currentIndex ?? 0]
                                  .contains('?sqp=')
                              ? thumbnail[advancedPlayer.currentIndex ?? 0]
                                  .split('?sqp=')[0]
                              : thumbnail[advancedPlayer.currentIndex ?? 0],
                          width: MediaQuery.of(context).size.height * 0.387,
                          height: MediaQuery.of(context).size.height * 0.387,
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) {
                            return Shimmer.fromColors(
                              baseColor: Colors.white70,
                              highlightColor: Colors.white,
                              child: Container(
                                height: 320.0,
                                width: 320.0,
                                decoration:
                                    const BoxDecoration(color: Colors.black38),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      children: [
                        SizedBox(
                            child: title[advancedPlayer.currentIndex ?? 0] != ""
                                ? title[advancedPlayer.currentIndex ?? 0]
                                            .length <=
                                        26
                                    ? Text(
                                        title[advancedPlayer.currentIndex ?? 0],
                                        style: GoogleFonts.poppins(
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      )
                                    : SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: Marquee(
                                          accelerationCurve: Curves.bounceIn,
                                          style: GoogleFonts.poppins(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w700),
                                          blankSpace: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          text: title[
                                              advancedPlayer.currentIndex ?? 0],
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
                                        height:
                                            MediaQuery.of(context).size.height *
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
                            child: author[advancedPlayer.currentIndex ?? 0] !=
                                    ""
                                ? Text(
                                    author[advancedPlayer.currentIndex ?? 0],
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
                                      height:
                                          MediaQuery.of(context).size.height *
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
                            onTap: () async {
                              if (advancedPlayer.hasPrevious) {
                                //await advancedPlayer.pause();
                                await advancedPlayer.seekToPrevious();
                                //await advancedPlayer.play();
                              } else {
                                advancedPlayer.seek(Duration.zero);
                              }
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
                              if (advancedPlayer.hasNext) {
                                //await advancedPlayer.pause();
                                await advancedPlayer.seekToNext();
                                //await advancedPlayer.play();
                              } else {
                                _playNextSong(videoid);
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
                          backgroundColor: Colors.black26,
                          builder: (context) {
                            return Container(
                              decoration:
                                  const BoxDecoration(color: Colors.black45),
                              height: 500,
                              child: ListTile(
                                leading: Image.network(thumbnail[
                                    advancedPlayer.currentIndex ?? 0]),
                                title: Text(
                                  title[advancedPlayer.currentIndex ?? 0],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                subtitle: Text(
                                    author[advancedPlayer.currentIndex ?? 0]),
                                //tileColor: Colors.white30,
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
      ),
    ));
  }
}
