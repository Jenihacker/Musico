class SongInfo {
  String title;
  String videoId;
  String duration;
  String artists;
  String thumbnails;
  String continuations;

  SongInfo(
      {required this.title,
      required this.videoId,
      required this.duration,
      required this.artists,
      required this.thumbnails,
      required this.continuations});

  factory SongInfo.fromJson(Map<String, dynamic> json) => SongInfo(
      title: json["title"],
      videoId: json["videoId"],
      duration: json["duration"],
      artists: json["artists"],
      thumbnails: json["thumbnails"],
      continuations: json["continuations"]);
}
