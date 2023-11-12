import 'dart:ui'; //https://dribbble.com/shots/19179064-Music-App
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musico/services/Providers/music_player_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:marquee/marquee.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  Widget slider() {
    return Consumer<MusicPlayerProvider>(
        builder: (context, musicPlayerProvider, child) {
      return ProgressBar(
        progress: musicPlayerProvider.currentslidervalue,
        buffered: musicPlayerProvider.advancedPlayer.bufferedPosition,
        total: musicPlayerProvider.advancedPlayer.duration ?? Duration.zero,
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
          musicPlayerProvider.advancedPlayer.seek(duration);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Consumer<MusicPlayerProvider>(
        builder: (_, musicPlayerProvider, child) {
      return RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (value) {
          musicPlayerProvider.keyboardKey(value);
        },
        child: SafeArea(
            child: Scaffold(
          backgroundColor: const Color(0XFF121212),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: CachedNetworkImageProvider(
                  musicPlayerProvider.songs.isNotEmpty
                      ? musicPlayerProvider
                          .songs[musicPlayerProvider.currentIndex].thumbnail
                      : "https://www.seekpng.com/png/full/4-40317_music-note-icon-iconbros-music-note-icon-transparent.png",
                ),
              ),
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
                blendMode: BlendMode.src,
                filter: ImageFilter.blur(
                  sigmaX: 20.0,
                  sigmaY: 20.0,
                ),
                child: Scaffold(
                  backgroundColor: Colors.black38,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 35,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    centerTitle: true,
                    title: Text(
                      'Now Playing',
                      style: GoogleFonts.poppins(fontSize: 20.0),
                    ),
                    actions: [
                      PopupMenuButton(
                        icon: const FaIcon(FontAwesomeIcons.ellipsisVertical,
                            color: Colors.white),
                        color: const Color(0XFF242424),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              onTap: () {
                                Share.share(
                                    'https://music.youtube.com/watch?v=${musicPlayerProvider.songs[musicPlayerProvider.currentIndex].videoid}',
                                    subject: 'Checkout this song');
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.share),
                                  Spacer(),
                                  Text('Share')
                                ],
                              )),
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
                                imageUrl: musicPlayerProvider.songs.isNotEmpty
                                    ? musicPlayerProvider
                                            .songs[musicPlayerProvider
                                                .currentIndex]
                                            .thumbnail
                                            .contains('?sqp=')
                                        ? musicPlayerProvider
                                            .songs[musicPlayerProvider
                                                .currentIndex]
                                            .thumbnail
                                            .split('?sqp=')[0]
                                        : musicPlayerProvider
                                            .songs[musicPlayerProvider
                                                .currentIndex]
                                            .thumbnail
                                    : "",
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
                                child: musicPlayerProvider.songs.isEmpty
                                    ? Padding(
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
                                      )
                                    : musicPlayerProvider
                                                .songs[musicPlayerProvider
                                                    .currentIndex]
                                                .title !=
                                            ""
                                        ? musicPlayerProvider
                                                    .songs[musicPlayerProvider
                                                        .currentIndex]
                                                    .title
                                                    .length <=
                                                28
                                            ? Text(
                                                musicPlayerProvider
                                                    .songs[musicPlayerProvider
                                                        .currentIndex]
                                                    .title,
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
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  blankSpace:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                  text: musicPlayerProvider
                                                      .songs[musicPlayerProvider
                                                          .currentIndex]
                                                      .title,
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
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8.0))),
                                              ),
                                            ),
                                          )),
                            SizedBox(
                                child: musicPlayerProvider.songs.isEmpty
                                    ? Shimmer.fromColors(
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
                                      )
                                    : musicPlayerProvider
                                                .songs[musicPlayerProvider
                                                    .currentIndex]
                                                .author !=
                                            ""
                                        ? Text(
                                            musicPlayerProvider
                                                .songs[musicPlayerProvider
                                                    .currentIndex]
                                                .author,
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
                                                      BorderRadius.circular(
                                                          8.0)),
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
                                      musicPlayerProvider.isMute
                                          ? Icons.volume_off
                                          : Icons.volume_up,
                                      color: Colors.white,
                                      size: 35.0,
                                    ),
                                    onTap: () {
                                      musicPlayerProvider.setMute();
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
                                      musicPlayerProvider.playPrevSong();
                                    },
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Icon(
                                      musicPlayerProvider.isPlaying
                                          ? Icons.pause_circle_filled
                                          : Icons.play_circle,
                                      color: Colors.white,
                                      size: 80.0,
                                    ),
                                    onTap: () {
                                      musicPlayerProvider.togglePlayback();
                                    },
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(20.0),
                                    onTap: () async {
                                      musicPlayerProvider.playNextSong();
                                      // if (advancedPlayer.hasNext) {
                                      //   await advancedPlayer.pause();
                                      //   await advancedPlayer.seekToNext();
                                      //   await advancedPlayer.play();
                                      // } else {
                                      //   _playNextSong(videoid[currentIndex]);
                                      // }
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
                                      musicPlayerProvider.setloop();
                                    },
                                    child: Icon(
                                      musicPlayerProvider.isLoop
                                          ? Icons.repeat_one
                                          : Icons.repeat,
                                      color: Colors.white,
                                      size: 35.0,
                                    ),
                                  )
                                ]),
                          ]),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15.0),
                        width: double.infinity,
                        height: 330, //MediaQuery.of(context).size.height * 0.4,
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
                                height: 265,
                                child: SingleChildScrollView(
                                  child: Text(
                                    musicPlayerProvider.lyrics,
                                    style: GoogleFonts.poppins(
                                        fontSize: 21.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
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
        )),
      );
    });
  }
}
