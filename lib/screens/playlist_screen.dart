import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        child: Container(
      color: Colors.black,
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0XFFC4FC4C),
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 5.0),
                  child: ElevatedButton(
                      style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(CircleBorder()),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.black)),
                      onPressed: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios)),
                ),
              ),
              backgroundColor: Colors.black38,
              body: Consumer<MusicPlayerProvider>(
                builder: (_,musicPlayerProvider,child) {
                  return FutureBuilder(
                      future: getPlaylistSongs,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  decoration: const BoxDecoration(
                                      color: Color(0XFFC4FC4C),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(40.0),
                                          bottomRight: Radius.circular(40.0))),
                                  child: Column(children: [
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 25.0, bottom: 20.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child: Image(
                                              width: 250,
                                              height: 250,
                                              image: CachedNetworkImageProvider(
                                                  snapshot
                                                      .data!.thumbnails[3].url)),
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
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.39,
                                  child: ListView.builder(
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
                                                fontWeight: FontWeight.w500),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Text(
                                            snapshot.data!.tracks[index].artists[0]
                                                .name,
                                            style:
                                                GoogleFonts.poppins(fontSize: 12.0),
                                          ),
                                          onTap: () {
                                            musicPlayerProvider.initializeSongDetails(snapshot.data!
                                                            .tracks[index].videoId);
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    child:const PlayerScreen(),
                                                    type: PageTransitionType
                                                        .bottomToTop));
                                          },
                                        );
                                      }),
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
                      });
                }
              )),
        ),
      ),
    ));
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
