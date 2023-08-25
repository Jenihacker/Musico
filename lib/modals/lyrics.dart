import 'dart:convert';

Lyrics lyricsFromJson(String str) => Lyrics.fromJson(json.decode(str));

String lyricsToJson(Lyrics data) => json.encode(data.toJson());

class Lyrics {
  String lyrics;
  String source;

  Lyrics({
    required this.lyrics,
    required this.source,
  });

  factory Lyrics.fromJson(Map<String, dynamic> json) => Lyrics(
        lyrics: json["lyrics"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "lyrics": lyrics,
        "source": source,
      };
}
