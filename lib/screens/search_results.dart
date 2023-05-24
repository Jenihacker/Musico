import 'dart:convert';
import 'package:music_player/modals/search_output.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:music_player/screens/player_screen.dart';

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
                          fontSize: 35, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ))
              ],
            ),
            backgroundColor: const Color(0XFF1F1545),
            body: FutureBuilder(
              future: getData(widget.message),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    if (snapshot.hasData) {
                      return ListTile(
                        leading: Image.network(
                          songs[index].thumbnail,
                          width: 100,
                          height: 100,
                        ),
                        title: Text(
                          songs[index].title,
                          style: GoogleFonts.nunito(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          songs[index].author,
                          style: GoogleFonts.poppins(color: Colors.white70),
                        ),
                        tileColor: const Color(0XFF1F1545),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return PlayerScreen(song: songs[index]);
                            },
                          ));
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              },
            )));
  }

  Future<List<Songs>> getData(dynamic query) async {
    final response = await http
        .get(Uri.parse('https://ytmusic-tau.vercel.app/?search=${query}'));
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
