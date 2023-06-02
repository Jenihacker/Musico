import 'dart:convert';
import 'package:music_player/modals/search_output.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:music_player/screens/player_screen.dart';
import 'package:music_player/screens/search_screen.dart';
import 'package:shimmer/shimmer.dart';

class SearchResultScreen extends StatefulWidget {
  final dynamic message;
  const SearchResultScreen({super.key, required this.message});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  List<Songs> songs = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                'Songs',
                style: GoogleFonts.poppins(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0XFF1F1545),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            ));
          },
          backgroundColor: const Color.fromARGB(255, 55, 13, 140),
          child: const Icon(Icons.search),
        ),
        body: FutureBuilder(
          future: getData(widget.message),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                itemCount: 10, // Number of shimmer placeholders
                itemBuilder: (context, index) {
                  return const ListTileShimmer(); // Shimmer placeholder tile
                },
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        songs[index].thumbnail,
                        width: 100,
                        height: 100,
                      ),
                    ),
                    title: Text(
                      songs[index].title,
                      style: GoogleFonts.nunito(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      songs[index].author,
                      style: GoogleFonts.poppins(color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                    tileColor: const Color(0XFF1F1545),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return PlayerScreen(song: songs[index]);
                        },
                      ));
                    },
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  'No data available.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Songs>> getData(dynamic query) async {
    final response = await http
        .get(Uri.parse('https://ytmusic-tau.vercel.app/?search=$query'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map<String, dynamic> index in data) {
        songs.add(Songs.fromJson(index));
      }
      return songs;
    }
    return songs;
  }
}

class ListTileShimmer extends StatelessWidget {
  const ListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 98, 95, 100),
      highlightColor: const Color.fromARGB(255, 152, 81, 223),
      child: ListTile(
        leading: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey,
          ),
        ),
        title: Container(
          height: 14,
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
        ),
        subtitle: Container(
          height: 14,
          decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
        ),
      ),
    );
  }
}
