import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/models/search_suggestion.dart';
import 'package:music_player/screens/home_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> suggest = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      backgroundColor: const Color(0XFF1F1545),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.0,
                  child: Text('Search',
                      style: GoogleFonts.poppins(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                SizedBox(
                  child: TextField(
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15.0),
                        filled: true,
                        fillColor: const Color(0XFF302360),
                        hintText: 'Enter the song',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        hintStyle: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 18.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none)),
                    enableSuggestions: true,
                  ),
                ),
                FutureBuilder(
                    future: getsuggestion(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: suggest.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                child: Text(suggest[index]),
                              );
                            });
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ])),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0XFF1F1545),
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          onTap: (value) {
            switch (value) {
              case 0:
                Get.to(() => const HomeScreen());
                break;
              case 1:
                Get.to(() => const SearchScreen());
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                label: 'home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                label: 'search'),
          ]),
    );
  }

  Future<List<String>> getsuggestion() async {
    final response = await http.get(
        Uri.parse('https://ytmusic-tau.vercel.app/search_suggestion/faded'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      suggest.addAll(data['suggestions']);
      print(suggest);
      return suggest;
    }
    return suggest;
  }
}
