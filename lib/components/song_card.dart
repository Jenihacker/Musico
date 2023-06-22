import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/screens/playlist_screen.dart';
import 'package:page_transition/page_transition.dart';

// ignore: must_be_immutable
class SongCard extends StatefulWidget {
  String playlistname;
  String thumbnail;
  String playlistid;

  SongCard(
      {super.key,
      required this.playlistname,
      required this.thumbnail,
      required this.playlistid});

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          child: InkWell(
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                    widget.thumbnail,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      duration: const Duration(milliseconds: 400),
                      child: PlaylistScreen(playlistId: widget.playlistid),
                      type: PageTransitionType.rightToLeftWithFade));
            },
          ),
        ),
        SizedBox(
          width: 150,
          child: Text(
            widget.playlistname,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunitoSans(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );

    /*
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      child: SizedBox(
        height: 150,
        width: 150,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    widget.thumbnail,
                  ),
                ),
              ),
            ),
            // Black overlay
            Opacity(
              opacity:
                  0.5, // Adjust the opacity value to control the darkness of the shade
              child: Container(
                color: Colors.black,
              ),
            ),
            // Content
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  widget.playlistname,
                  style: GoogleFonts.nunitoSans(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );*/
  }
}
