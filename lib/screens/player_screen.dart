import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
//import 'package:http/http.dart' as http;
import 'package:music_player/screens/home_screen.dart';
import 'dart:convert';
import 'package:music_player/screens/search_screen.dart';

late String stringResponse;
late String author;

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

void parseResponse(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  // Iterate over the parsed response
  List<Song> songs = parsed.map<Song>((json) => Song.fromJson(json)).toList();

  // Now you can use the 'songs' list as needed
  // For example, you can access individual song properties like:
  print(songs[0].author);
  print(songs[0].title);
  author = songs[0].author;
  // ...
}

class Song {
  final String author;
  final int id;
  final List<StreamLink> streamLinks;
  final String thumbnail;
  final String title;
  final String viewcount;

  Song({
    required this.author,
    required this.id,
    required this.streamLinks,
    required this.thumbnail,
    required this.title,
    required this.viewcount,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      author: json['author'],
      id: json['id'],
      streamLinks: List<StreamLink>.from(
          json['streamlinks'].map((x) => StreamLink.fromJson(x))),
      thumbnail: json['thumbnail'],
      title: json['title'],
      viewcount: json['viewcount'],
    );
  }
}

class StreamLink {
  final String mimeType;
  final String url;

  StreamLink({
    required this.mimeType,
    required this.url,
  });

  factory StreamLink.fromJson(Map<String, dynamic> json) {
    return StreamLink(
      mimeType: json['mimeType'],
      url: json['url'],
    );
  }
}

class _PlayerScreenState extends State<PlayerScreen> {
  // Future apicall() async {
  // http.Response response;
  // response = await http
  //     .get(Uri.parse('https://ytmusic-tau.vercel.app?search=faded'));
  // setState(() {
  //   stringResponse = response.body;
  //   parseResponse(stringResponse);
  //final parsed = json.decode(stringResponse).cast<Map<String, dynamic>>();
  // });
//  }

//  }
  double _currentslidervalue = 50.0;
  bool _isPlaying = false;

  Widget slider() {
    return Slider(
      thumbColor: Colors.white,
      activeColor: Colors.white,
      inactiveColor: const Color.fromARGB(201, 148, 148, 148),
      min: 0.0,
      max: 100.0,
      value: _currentslidervalue,
      onChanged: (double value) {
        setState(() {
          _currentslidervalue = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.shade800.withOpacity(0.8),
            Colors.deepPurple.shade200.withOpacity(0.8),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 25,
            ),
            onPressed: () => {Get.to(() => const HomeScreen())},
          ),
          centerTitle: true,
          title: Text(
            'Player',
            style: GoogleFonts.poppins(
                fontSize: 20.0, fontWeight: FontWeight.w500),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
                size: 25,
              ),
              onPressed: () => {Get.to(() => const SearchScreen())},
            ),
          ],
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                  child: ClipRRect(
                    //height: 300,
                    //borderRadius: BorderRadius.circular(300.0),
                    child: Lottie.network(
                      'https://assets1.lottiefiles.com/private_files/lf30_xnjjfyjt.json',
                      //'https://assets1.lottiefiles.com/private_files/lf30_qqbtrtae.json',
                      //'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
                      width: 300.0,
                      height: 300.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    child: Text(
                      'Track Title',
                      style: GoogleFonts.poppins(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      'Track author',
                      style: GoogleFonts.poppins(
                        fontSize: 20.0,
                        color: Colors.white60,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('0:00',
                              style: GoogleFonts.poppins(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                          Text('1:00',
                              style: GoogleFonts.poppins(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                        ])),
                slider(),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20.0),
                        child: const Icon(
                          Icons.skip_previous_rounded,
                          color: Colors.white,
                          size: 50.0,
                        ),
                        onTap: () {},
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Icon(
                          _isPlaying ? Icons.pause_circle : Icons.play_circle,
                          color: Colors.white,
                          size: 80.0,
                        ),
                        onTap: () {
                          setState(() {
                            _isPlaying = !_isPlaying;
                          });
                        },
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(20.0),
                        onTap: () {},
                        child: const Icon(
                          Icons.skip_next_rounded,
                          color: Colors.white,
                          size: 50.0,
                        ),
                      ),
                    ])
              ]),
              Container(
                width: 500,
                height: 60,
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Colors.black45)]),
                child: const Icon(
                  Icons.playlist_add,
                  color: Colors.white,
                  size: 30.0,
                ),
              )
            ]),
      ),
    );
  }
}
