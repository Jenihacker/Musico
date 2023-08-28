import 'dart:convert';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:musico/models/search_output.dart';
import 'package:musico/screens/player_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:musico/shimmers/searchresult_shimmer.dart';

class SearchResultScreen extends StatefulWidget {
  final dynamic message;
  const SearchResultScreen({super.key, required this.message});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late Songs songs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.topLeft,
                colors: [
              // Color(0XFF780206),
              // Color(0XFF061161),
              Colors.black,
              Colors.black
            ])),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black26,
                elevation: 0,
                bottom: const TabBar(
                    indicatorColor: Color(0XFFC4FC4C),
                    labelColor: Color(0XFFC4FC4C),
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                          icon: Icon(
                        BootstrapIcons.music_note,
                      )),
                      Tab(
                        child: Icon(
                          Icons.movie,
                        ),
                      )
                    ]),
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Text(
                      "Songs",
                      style: GoogleFonts.poppins(
                        fontSize: 35,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.black26,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                backgroundColor: const Color(0XFFC4FC4C),
                child: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
              body: TabBarView(
                children: [
                  FutureBuilder(
                    future: getData(widget.message, "songs"),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          itemCount: 15, // Number of shimmer placeholders
                          itemBuilder: (context, index) {
                            return const SearchResultShimmer(); // Shimmer placeholder tile
                          },
                        );
                      } else if (snapshot.hasData) {
                        return ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                                width:
                                    10); // Add a horizontal spacing between items
                          },
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(
                                  top: 12.0, left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  color: const Color(0XFF1e1c22),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: ListTile(
                                trailing: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.play_circle_sharp,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      snapshot.data![index]["duration"] ??
                                          '0:00',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white70),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                                enabled: true,
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Image.network(
                                    snapshot.data![index]["thumbnails"]
                                            .contains("=w120")
                                        ? snapshot.data![index]["thumbnails"]
                                                .split("=w120")[0] +
                                            "=w240-h240-l90-rj"
                                        : snapshot.data![index]["thumbnails"],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  snapshot.data![index]["title"],
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  snapshot.data![index]["artists"],
                                  style: GoogleFonts.poppins(
                                      color: Colors.white70),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: PlayerScreen(
                                              vd: snapshot.data![index]
                                                  ["videoId"]),
                                          type: PageTransitionType.bottomToTop,
                                          duration: const Duration(
                                              milliseconds: 300)));
                                },
                              ),
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
                  FutureBuilder(
                    future: getData(widget.message, "videos"),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ListView.builder(
                          itemCount: 15, // Number of shimmer placeholders
                          itemBuilder: (context, index) {
                            return const SearchResultShimmer(); // Shimmer placeholder tile
                          },
                        );
                      } else if (snapshot.hasData) {
                        return ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                                width:
                                    10); // Add a horizontal spacing between items
                          },
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(
                                  top: 12.0, left: 10.0, right: 10.0),
                              decoration: BoxDecoration(
                                  color: const Color(0XFF1e1c22),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: ListTile(
                                trailing: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.play_circle_sharp,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      snapshot.data![index]["duration"] ??
                                          '0:00',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white70),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                                splashColor: Colors.white38,
                                style: ListTileStyle.list,
                                enabled: true,
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Image.network(
                                    snapshot.data![index]["thumbnails"]
                                            .contains("?sqp=")
                                        ? snapshot.data![index]["thumbnails"]
                                            .split("?sqp=")[0]
                                        : snapshot.data![index]["thumbnails"],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  snapshot.data![index]["title"],
                                  style: GoogleFonts.nunito(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  snapshot.data![index]["artists"],
                                  style: GoogleFonts.poppins(
                                      color: Colors.white70),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          child: PlayerScreen(
                                              vd: snapshot.data![index]
                                                  ["videoId"]),
                                          type: PageTransitionType.bottomToTop,
                                          duration: const Duration(
                                              milliseconds: 300)));
                                },
                              ),
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
                  )
                ],
              )),
        ),
      ),
    );
  }

  Future<List<dynamic>> getData(dynamic query, String type) async {
    final response = await http
        .get(Uri.parse('https://ytmusic-tau.vercel.app/?search=$query'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return data[type];
    }
    return data[type];
  }
}
