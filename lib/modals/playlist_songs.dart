import 'dart:convert';

PlaylistSongs playlistSongsFromJson(String str) =>
    PlaylistSongs.fromJson(json.decode(str));

String playlistSongsToJson(PlaylistSongs data) => json.encode(data.toJson());

class PlaylistSongs {
  String id;
  String privacy;
  String title;
  List<Thumbnail> thumbnails;
  String description;
  Author author;
  String year;
  String duration;
  int trackCount;
  dynamic views;
  List<Track> tracks;
  int durationSeconds;

  PlaylistSongs({
    required this.id,
    required this.privacy,
    required this.title,
    required this.thumbnails,
    required this.description,
    required this.author,
    required this.year,
    required this.duration,
    required this.trackCount,
    this.views,
    required this.tracks,
    required this.durationSeconds,
  });

  factory PlaylistSongs.fromJson(Map<String, dynamic> json) => PlaylistSongs(
        id: json["id"],
        privacy: json["privacy"],
        title: json["title"],
        thumbnails: List<Thumbnail>.from(
            json["thumbnails"].map((x) => Thumbnail.fromJson(x))),
        description: json["description"],
        author: Author.fromJson(json["author"]),
        year: json["year"],
        duration: json["duration"],
        trackCount: json["trackCount"],
        views: json["views"],
        tracks: List<Track>.from(json["tracks"].map((x) => Track.fromJson(x))),
        durationSeconds: json["duration_seconds"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "privacy": privacy,
        "title": title,
        "thumbnails": List<dynamic>.from(thumbnails.map((x) => x.toJson())),
        "description": description,
        "author": author.toJson(),
        "year": year,
        "duration": duration,
        "trackCount": trackCount,
        "views": views,
        "tracks": List<dynamic>.from(tracks.map((x) => x.toJson())),
        "duration_seconds": durationSeconds,
      };
}

class Author {
  String name;
  String? id;

  Author({
    required this.name,
    this.id,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}

class Thumbnail {
  String url;
  int width;
  int height;

  Thumbnail({
    required this.url,
    required this.width,
    required this.height,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        url: json["url"],
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "width": width,
        "height": height,
      };
}

class Track {
  String videoId;
  String title;
  List<Author> artists;
  Author? album;
  LikeStatus likeStatus;
  List<Thumbnail> thumbnails;
  bool isAvailable;
  bool isExplicit;
  VideoType videoType;
  String duration;
  int durationSeconds;

  Track({
    required this.videoId,
    required this.title,
    required this.artists,
    this.album,
    required this.likeStatus,
    required this.thumbnails,
    required this.isAvailable,
    required this.isExplicit,
    required this.videoType,
    required this.duration,
    required this.durationSeconds,
  });

  factory Track.fromJson(Map<String, dynamic> json) => Track(
        videoId: json["videoId"],
        title: json["title"],
        artists:
            List<Author>.from(json["artists"].map((x) => Author.fromJson(x))),
        album: json["album"] == null ? null : Author.fromJson(json["album"]),
        likeStatus: likeStatusValues.map[json["likeStatus"]]!,
        thumbnails: List<Thumbnail>.from(
            json["thumbnails"].map((x) => Thumbnail.fromJson(x))),
        isAvailable: json["isAvailable"],
        isExplicit: json["isExplicit"],
        videoType: videoTypeValues.map[json["videoType"]]!,
        duration: json["duration"],
        durationSeconds: json["duration_seconds"],
      );

  Map<String, dynamic> toJson() => {
        "videoId": videoId,
        "title": title,
        "artists": List<dynamic>.from(artists.map((x) => x.toJson())),
        "album": album?.toJson(),
        "likeStatus": likeStatusValues.reverse[likeStatus],
        "thumbnails": List<dynamic>.from(thumbnails.map((x) => x.toJson())),
        "isAvailable": isAvailable,
        "isExplicit": isExplicit,
        "videoType": videoTypeValues.reverse[videoType],
        "duration": duration,
        "duration_seconds": durationSeconds,
      };
}

enum LikeStatus { INDIFFERENT }

final likeStatusValues = EnumValues({"INDIFFERENT": LikeStatus.INDIFFERENT});

enum VideoType {
  MUSIC_VIDEO_TYPE_OMV,
  MUSIC_VIDEO_TYPE_UGC,
  MUSIC_VIDEO_TYPE_ATV
}

final videoTypeValues = EnumValues({
  "MUSIC_VIDEO_TYPE_ATV": VideoType.MUSIC_VIDEO_TYPE_ATV,
  "MUSIC_VIDEO_TYPE_OMV": VideoType.MUSIC_VIDEO_TYPE_OMV,
  "MUSIC_VIDEO_TYPE_UGC": VideoType.MUSIC_VIDEO_TYPE_UGC
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
