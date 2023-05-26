import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/modals/search_output.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayerScreen extends StatefulWidget {
  final Songs song;
  const PlayerScreen({super.key, required this.song});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  AudioPlayer advancedPlayer = AudioPlayer();
  double _currentslidervalue = 10.0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    playMusic();
    advancedPlayer.setPlayerMode(PlayerMode.mediaPlayer);
  }

  @override
  void dispose() {
    super.dispose();
    advancedPlayer.release();
    advancedPlayer.dispose();
  }

  playMusic() async {
    await advancedPlayer.play(UrlSource(widget.song.streamlinks[0].url));
    setState(() {
      _isPlaying = true;
    });
  }

  pauseMusic() async {
    await advancedPlayer.pause();
  }

  resumeMusic() async {
    await advancedPlayer.resume();
  }

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
    return SafeArea(
        child: Container(
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
            onPressed: () => {Navigator.of(context).pop()},
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
              onPressed: () => {Navigator.of(context).pop()},
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
                    borderRadius: BorderRadius.circular(25.0),
                    child: Image.network(
                      widget.song.thumbnail,
                      width: 320.0,
                      height: 300.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    child: Text(
                      widget.song.title,
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
                      widget.song.author,
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
                          if (_isPlaying) {
                            setState(() {
                              pauseMusic();
                              _isPlaying = false;
                            });
                          } else {
                            setState(() {
                              playMusic();
                              _isPlaying = true;
                            });
                          }
                        },
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(20.0),
                        onTap: () async {
                          advancedPlayer.onPositionChanged.listen((event) {
                            print(event);
                          });
                        },
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
    ));
  }
}
