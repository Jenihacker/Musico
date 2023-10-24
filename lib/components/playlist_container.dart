import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:musico/components/song_card.dart';
import 'package:musico/shimmers/playlistcat_shimmer.dart';
import 'package:musico/models/playlist_category.dart';

class PlaylistContainer extends StatefulWidget {
  final String title;
  const PlaylistContainer({super.key, required this.title});

  @override
  State<PlaylistContainer> createState() => _PlaylistContainerState();
}

class _PlaylistContainerState extends State<PlaylistContainer> {
  final List<PlaylistCategory> playlistcat = [];
  Future? getplist;

  @override
  void initState() {
    super.initState();
    getplist = getPlaylist(widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getplist,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return SizedBox(
              height: 210,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.touch,
                  },
                ),
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 15,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      snapshot.data!.isEmpty ? 10 : snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return SongCard(
                        playlistname: playlistcat[index].title,
                        playlistdesc: Description.PLAYLIST_YOU_TUBE_MUSIC,
                        thumbnail: playlistcat[index].thumbnails[1].url,
                        playlistid: playlistcat[index].playlistId);
                  },
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Text('No Network Connectivity');
          }
          return Container();
        } else {
          return SizedBox(
            height: 210,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(
                width: 15,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return const PlaylistCatShimmer();
              },
            ),
          );
        }
      },
    );
  }

  Future<List<PlaylistCategory>> getPlaylist(dynamic cat) async {
    final response = await http
        .get(Uri.parse("https://ytmusic-tau.vercel.app/playlist?cat=$cat"));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map<String, dynamic> item in data) {
        playlistcat.add(PlaylistCategory.fromJson(item));
      }
      //playlistcat.shuffle();
      return playlistcat;
    }
    return playlistcat;
  }
}
