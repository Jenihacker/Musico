import 'dart:convert';
import 'package:get/get.dart';
import 'package:music_player/modals/search_output.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:music_player/screens/player_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:music_player/shimmers/searchresult_shimmer.dart';

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
              Get.back();
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
            Get.back();
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
                  return const SearchResultShimmer(); // Shimmer placeholder tile
                },
              );
            } else if (snapshot.hasData) {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(
                      width: 10); // Add a horizontal spacing between items
                },
                itemCount: snapshot.data!.length,
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
                    tileColor: Colors.black38,
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: PlayerScreen(song: songs[index]),
                              type: PageTransitionType.bottomToTop,
                              duration: const Duration(milliseconds: 300)));
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
