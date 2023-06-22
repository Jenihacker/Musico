import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:music_player/components/song_card.dart';
import 'package:music_player/shimmers/playlistcat_shimmer.dart';
import '../modals/playlist_category.dart';

class PlaylistContainer extends StatefulWidget {
  final String title;
  const PlaylistContainer({super.key, required this.title});

  @override
  State<PlaylistContainer> createState() => _PlaylistContainerState();
}

class _PlaylistContainerState extends State<PlaylistContainer> {
  List<PlaylistCategory> playlistcat = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPlaylist(widget.title),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return SizedBox(
              height: 200,
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  width: 15,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.isEmpty ? 10 : snapshot.data!.length,
                itemBuilder: (context, index) {
                  return SongCard(
                      playlistname: snapshot.data![index].title,
                      thumbnail: snapshot.data![index].thumbnails[1].url,
                      playlistid: snapshot.data![index].playlistId);
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              decoration: const BoxDecoration(color: Colors.amber),
              child: const Text('No Network Connectivity'),
            );
          }
          return Container();
        } else {
          return SizedBox(
            height: 200,
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
    List<PlaylistCategory> playlistcat = [];
    if (response.statusCode == 200) {
      for (Map<String, dynamic> item in data) {
        playlistcat.add(PlaylistCategory.fromJson(item));
      }
      return playlistcat;
    }
    return playlistcat;
  }
}
