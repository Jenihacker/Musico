import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:musico/colors/color.dart';
import 'package:musico/services/Providers/music_player_provider.dart';
import 'package:musico/services/api/search_song_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musico/screens/player_screen.dart';
import 'package:musico/widgets/floating_mediabar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:musico/shimmers/searchresult_shimmer.dart';
import 'package:provider/provider.dart';
import 'package:musico/models/response/search_song.dart';

class SearchResultScreen extends StatefulWidget {
  final dynamic message;

  const SearchResultScreen({super.key, required this.message});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  Future<List<SongInfo?>>? getSongs;
  Future<List<SongInfo?>>? getVideos;

  @override
  void initState() {
    super.initState();
    getSongs = SearchSongs().getSongs(widget.message);
    getVideos = SearchSongs().getVideos(widget.message);
  }

  Widget resultTiles(Future<List<SongInfo?>>? category) {
    return Consumer<MusicPlayerProvider>(
        builder: (_, musicPlayerProvider, child) {
      return FutureBuilder(
        future: category,
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
              padding: const EdgeInsets.only(bottom: 90.0),
              separatorBuilder: (context, index) {
                return const SizedBox(
                    width: 10); // Add a horizontal spacing between items
              },
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.only(top: 12.0, left: 10.0, right: 10.0),
                  decoration: BoxDecoration(
                      color: const Color(0XFF1e1c22),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: ListTile(
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.play_circle_sharp,
                          size: 27,
                          color: Colors.white,
                        ),
                        Text(
                          snapshot.data![index]?.duration ?? '0:00',
                          style: GoogleFonts.poppins(color: Colors.white70),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                    enabled: true,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(3.0),
                      child: Image.network(
                        snapshot.data![index]!.thumbnails.contains("=w120")
                            ? "${snapshot.data![index]!.thumbnails.split("=w120")[0]}=w240-h240-l90-rj"
                            : snapshot.data![index]!.thumbnails,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      snapshot.data![index]!.title,
                      style: GoogleFonts.nunito(
                        color: listTitleTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      snapshot.data![index]!.artists,
                      style: GoogleFonts.poppins(color: listSubtitleTextColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      musicPlayerProvider.initializeSongDetails(
                          snapshot.data![index]!.videoId);
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const PlayerScreen(),
                              type: PageTransitionType.bottomToTop,
                              duration: const Duration(milliseconds: 300)));
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
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<MusicPlayerProvider>(
          builder: (_, musicPlayerProvider, child) {
        return Container(
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
                      indicatorColor: primaryThemeColor,
                      labelColor: primaryThemeColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorSize: TabBarIndicatorSize.tab,
                      splashFactory: InkRipple.splashFactory,
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
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: appBarLeadingColor),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Text(
                              widget.message,
                              style: GoogleFonts.poppins(
                                fontSize: 25,
                                color: appBarTitleTextColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.black26,
                body: Stack(
                  children: [
                    TabBarView(
                      children: [
                        resultTiles(getSongs),
                        resultTiles(getVideos),
                      ],
                    ),
                    Consumer<MusicPlayerProvider>(
                        builder: (_, musicPlayerProvider, child) {
                      return const Positioned(
                          bottom: 15, child: FloatingMediaBar());
                    })
                  ],
                )),
          ),
        );
      }),
    );
  }
}
