import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musico/colors/color.dart';
import 'package:musico/models/playlist_songs.dart';
import 'package:http/http.dart' as http;
import 'package:musico/screens/player_screen.dart';
import 'package:musico/services/Providers/music_player_provider.dart';
import 'package:musico/shimmers/playlist_shimmer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PlaylistScreen extends StatefulWidget {
  String playlistId;
  PlaylistScreen({super.key, required this.playlistId});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late final PlaylistSongs playlist;
  Future? getPlaylistSongs;

  @override
  void initState() {
    super.initState();
    getPlaylistSongs = getPlaylist(widget.playlistId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: primaryThemeColor,
              elevation: 0,
              leading: Padding(
                padding: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                child: IconButton(
                    style: const ButtonStyle(
                        shape: MaterialStatePropertyAll(CircleBorder()),
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.black)),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: appBarLeadingColor,
                    )),
              ),
            ),
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Consumer<MusicPlayerProvider>(
                    builder: (_, musicPlayerProvider, child) {
                  return SingleChildScrollView(
                    child: FutureBuilder(
                        future: getPlaylistSongs,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    decoration: const BoxDecoration(
                                        color: primaryThemeColor,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(40.0),
                                            bottomRight:
                                                Radius.circular(40.0))),
                                    child: Column(children: [
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 25.0, bottom: 20.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image(
                                                width: 250,
                                                height: 250,
                                                image:
                                                    CachedNetworkImageProvider(
                                                        snapshot
                                                            .data!
                                                            .thumbnails[3]
                                                            .url)),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          snapshot.data!.title,
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          snapshot.data!.description,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ]),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.tracks.isEmpty
                                          ? 10
                                          : snapshot.data!.tracks.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.network(
                                              snapshot
                                                  .data!
                                                  .tracks[index]
                                                  .thumbnails[snapshot
                                                          .data!
                                                          .tracks[index]
                                                          .thumbnails
                                                          .length -
                                                      1]
                                                  .url
                                                  .split('?sqp=')[0],
                                              fit: BoxFit.cover,
                                              width: 80,
                                              height: 80,
                                            ),
                                          ),
                                          title: Text(
                                            snapshot.data!.tracks[index].title,
                                            style: GoogleFonts.poppins(
                                                fontSize: 15.0,
                                                color: listTitleTextColor,
                                                fontWeight: FontWeight.w500),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(
                                            snapshot.data!.tracks[index]
                                                .artists[0].name,
                                            style: GoogleFonts.poppins(
                                                fontSize: 12.0,
                                                color: listSubtitleTextColor),
                                          ),
                                          onTap: () {
                                            musicPlayerProvider
                                                .initializeSongDetails(snapshot
                                                    .data!
                                                    .tracks[index]
                                                    .videoId);
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    child: const PlayerScreen(),
                                                    type: PageTransitionType
                                                        .bottomToTop));
                                          },
                                        );
                                      }),
                                  const SizedBox(
                                    height: 85,
                                  )
                                ],
                              );
                            } else {
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text('No Network Connectivity'),
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            }
                          } else {
                            return const PlaylistShimmer();
                          }
                        }),
                  );
                }),
                Consumer<MusicPlayerProvider>(
                    builder: (_, musicPlayerProvider, child) {
                  return Positioned(
                      bottom: 5,
                      child: Visibility(
                        visible: musicPlayerProvider.audio == null ||
                                musicPlayerProvider.songs == []
                            ? false
                            : true,
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                              color: primaryThemeColor,
                              borderRadius: BorderRadius.circular(10.0)),
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: GestureDetector(
                            onVerticalDragEnd: (details) async {
                              await musicPlayerProvider.advancedPlayer.stop();
                              musicPlayerProvider.audio = null;
                              musicPlayerProvider.isNewSongSet = true;
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: ListTile(
                                title: Text(
                                  musicPlayerProvider.songs.isNotEmpty
                                      ? musicPlayerProvider
                                          .songs[
                                              musicPlayerProvider.currentIndex]
                                          .title
                                      : "",
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  musicPlayerProvider.songs.isNotEmpty
                                      ? musicPlayerProvider
                                          .songs[
                                              musicPlayerProvider.currentIndex]
                                          .author
                                      : "",
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Image(
                                    image: NetworkImage(
                                        musicPlayerProvider.songs.isNotEmpty
                                            ? musicPlayerProvider
                                                .songs[musicPlayerProvider
                                                    .currentIndex]
                                                .thumbnail
                                            : ""),
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      iconSize: 35,
                                      icon: musicPlayerProvider.isPlaying
                                          ? const Icon(
                                              Icons.pause,
                                              size: 35,
                                              color: Colors.black,
                                            )
                                          : const Icon(
                                              Icons.play_arrow,
                                              size: 35,
                                              color: Colors.black,
                                            ),
                                      onPressed: () {
                                        musicPlayerProvider.togglePlayback();
                                      },
                                    ),
                                    Visibility(
                                      visible: musicPlayerProvider
                                              .advancedPlayer.hasNext
                                          ? true
                                          : false,
                                      child: IconButton(
                                        iconSize: 35,
                                        icon: const Icon(
                                          Icons.skip_next,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          musicPlayerProvider.playNextSong();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: const PlayerScreen(),
                                      type: PageTransitionType.bottomToTop));
                            },
                          ),
                        ),
                      ));
                })
              ],
            )));
  }

  Future<PlaylistSongs> getPlaylist(String pid) async {
    final response = await http
        .get(Uri.parse("https://ytmusic-tau.vercel.app/playlist/song/$pid"));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return PlaylistSongs.fromJson(data);
    } else {
      return PlaylistSongs.fromJson(data);
    }
  }
}
