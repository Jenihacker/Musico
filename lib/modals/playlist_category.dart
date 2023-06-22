import 'dart:convert';

List<PlaylistCategory> playlistCategoryFromJson(String str) => List<PlaylistCategory>.from(json.decode(str).map((x) => PlaylistCategory.fromJson(x)));

String playlistCategoryToJson(List<PlaylistCategory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlaylistCategory {
    String title;
    String playlistId;
    List<Thumbnail> thumbnails;
    Description description;

    PlaylistCategory({
        required this.title,
        required this.playlistId,
        required this.thumbnails,
        required this.description,
    });

    factory PlaylistCategory.fromJson(Map<String, dynamic> json) => PlaylistCategory(
        title: json["title"],
        playlistId: json["playlistId"],
        thumbnails: List<Thumbnail>.from(json["thumbnails"].map((x) => Thumbnail.fromJson(x))),
        description: descriptionValues.map[json["description"]]!,
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "playlistId": playlistId,
        "thumbnails": List<dynamic>.from(thumbnails.map((x) => x.toJson())),
        "description": descriptionValues.reverse[description],
    };
}

enum Description { PLAYLIST_YOU_TUBE_MUSIC }

final descriptionValues = EnumValues({
    "Playlist • YouTube Music": Description.PLAYLIST_YOU_TUBE_MUSIC
});

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

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
