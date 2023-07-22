import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/modals/playlist_songs.dart';
import 'package:http/http.dart' as http;
import 'package:music_player/screens/player_screen.dart';
import 'package:music_player/shimmers/playlist_shimmer.dart';
import 'package:page_transition/page_transition.dart';

// ignore: must_be_immutable
class PlaylistScreen extends StatefulWidget {
  String playlistId;
  PlaylistScreen({super.key, required this.playlistId});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late PlaylistSongs playlist;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.topLeft,
              colors: [
            Color(0XFF780206),
            Color(0XFF061161),
          ])),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios)),
          ),
          backgroundColor: Colors.black38,
          body: FutureBuilder(
              future: getPlaylist(widget.playlistId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 20.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image(
                                  width: 250,
                                  height: 250,
                                  image: CachedNetworkImageProvider(
                                      snapshot.data!.thumbnails[3].url)),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            snapshot.data!.title,
                            style: GoogleFonts.poppins(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Center(
                            child: Text(
                              snapshot.data!.description,
                              style: GoogleFonts.poppins(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!.tracks.isEmpty
                                  ? 10
                                  : snapshot.data!.tracks.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
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
                                    style: GoogleFonts.poppins(fontSize: 15.0),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    snapshot
                                        .data!.tracks[index].artists[0].name,
                                    style: GoogleFonts.poppins(fontSize: 12.0),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: PlayerScreen(
                                                vd: snapshot.data!.tracks[index]
                                                    .videoId),
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
              })),
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
