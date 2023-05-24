import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:music_player/screens/home_screen.dart';
import 'package:music_player/screens/search_results.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late dynamic message;

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
                      style: GoogleFonts.audiowide(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w500,
                      )),
                ),
                SizedBox(
                    child: TypeAheadField(
                  hideSuggestionsOnKeyboardHide: true,
                  textFieldConfiguration: TextFieldConfiguration(
                    cursorColor: Colors.white,
                    style: GoogleFonts.poppins(
                      fontSize: 20.0,
                    ),
                    onSubmitted: (value) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return SearchResultScreen(message: value);
                        },
                      ));
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0XFF302360),
                      hintText: 'Enter the song',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none),
                    ),
                    enableSuggestions: true,
                  ),
                  suggestionsCallback: (pattern) async {
                    return await getsuggestion(pattern);
                    //return ['Song not found'];
                  },
                  itemBuilder: (context, itemData) {
                    return ListTile(
                      leading:
                          const Icon(Icons.music_note, color: Colors.white),
                      title: Text(
                        itemData,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),
                      tileColor: const Color(0XFF302360),
                    );
                  },
                  getImmediateSuggestions: true,
                  onSuggestionSelected: (suggestion) {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return SearchResultScreen(message: suggestion);
                      },
                    ));
                  },
                  hideOnError: true,
                  hideOnEmpty: true,
                )),
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
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              label: 'search',
            ),
          ]),
    ));
  }

  Future<List<dynamic>> getsuggestion(String pattern) async {
    final response = await http.get(Uri.parse(
        'https://ytmusic-tau.vercel.app/search_suggestion/${pattern}'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return data['suggestions'];
    }
    return [];
  }
}
