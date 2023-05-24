import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioFile extends StatefulWidget {
  final AudioPlayer advancedPlayer;
  const AudioFile({super.key,required this.advancedPlayer});

  @override
  State<AudioFile> createState() => _AudioFileState();
}

class _AudioFileState extends State<AudioFile> {
  Duration _duration = new Duration();
  Duration _position = new Duration();
  bool isPlaying = false;
  bool isPaused = false;
  bool isLoop = false;

  @override
  void initState() {
    super.initState();
    this.widget.advancedPlayer.onDurationChanged.listen((d) {
      setState(() {
        _duration = d;
      });
    });
    this.widget.advancedPlayer.onPositionChanged.listen((d) {
      setState(() {
        _position = d;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
