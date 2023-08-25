import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musico/modals/playlist_category.dart';
import 'package:musico/screens/playlist_screen.dart';
import 'package:page_transition/page_transition.dart';

// ignore: must_be_immutable
class SongCard extends StatefulWidget {
  String playlistname;
  String thumbnail;
  String playlistid;
  Description playlistdesc;

  SongCard(
      {super.key,
      required this.playlistname,
      required this.playlistdesc,
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
    return Container(
      decoration: BoxDecoration(
          color: const Color(0XFF1e1c22),
          borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            child: InkWell(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(widget.thumbnail),
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
          const Spacer(),
          SizedBox(
            width: 160,
            child: Text(
              widget.playlistname,
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunitoSans(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: 160,
            child: Text(
              "Playlist • YouTube Music",
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunitoSans(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ),
          const Spacer()
        ],
      ),
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
