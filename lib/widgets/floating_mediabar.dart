import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musico/colors/color.dart';
import 'package:musico/screens/player_screen.dart';
import 'package:musico/services/Providers/music_player_provider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class FloatingMediaBar extends StatefulWidget {
  const FloatingMediaBar({super.key});

  @override
  State<FloatingMediaBar> createState() => _FloatingMediaBarState();
}

class _FloatingMediaBarState extends State<FloatingMediaBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MusicPlayerProvider>(
      builder: (_, musicPlayerProvider, child) {
        return Visibility(
          visible: musicPlayerProvider.audio == null ||
                  musicPlayerProvider.songs == []
              ? false
              : true,
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
                color: primaryThemeColor,
                borderRadius: BorderRadius.circular(10.0)),
            width: MediaQuery.of(context).size.width * 0.95,
            child: GestureDetector(
              onVerticalDragEnd: (details) async {
                await musicPlayerProvider.advancedPlayer.stop();
                musicPlayerProvider.audio = null;
                musicPlayerProvider.isNewSongSet = true;
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: ListTile(
                  title: Text(
                    musicPlayerProvider.songs.isNotEmpty
                        ? musicPlayerProvider
                            .songs[musicPlayerProvider.currentIndex].title
                        : "",
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    musicPlayerProvider.songs.isNotEmpty
                        ? musicPlayerProvider
                            .songs[musicPlayerProvider.currentIndex].author
                        : "",
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image(
                      image: NetworkImage(musicPlayerProvider.songs.isNotEmpty
                          ? musicPlayerProvider
                              .songs[musicPlayerProvider.currentIndex].thumbnail
                          : ""),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        iconSize: 35,
                        icon: musicPlayerProvider.isPlaying
                            ? const Icon(
                                Icons.pause,
                                size: 35,
                                color: Colors.black,
                              )
                            : const Icon(
                                Icons.play_arrow,
                                size: 35,
                                color: Colors.black,
                              ),
                        onPressed: () {
                          musicPlayerProvider.togglePlayback();
                        },
                      ),
                      Visibility(
                        visible: musicPlayerProvider.advancedPlayer.hasNext
                            ? true
                            : false,
                        child: IconButton(
                          iconSize: 35,
                          icon: const Icon(
                            Icons.skip_next,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            musicPlayerProvider.playNextSong();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const PlayerScreen(),
                        type: PageTransitionType.bottomToTop));
              },
            ),
          ),
        );
      },
    );
  }
}
