import 'dart:convert';

List<Songs> songsFromJson(String str) => List<Songs>.from(json.decode(str).map((x) => Songs.fromJson(x)));

String songsToJson(List<Songs> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Songs {
    String author;
    int id;
    List<Streamlink> streamlinks;
    String thumbnail;
    String title;
    String viewcount;

    Songs({
        required this.author,
        required this.id,
        required this.streamlinks,
        required this.thumbnail,
        required this.title,
        required this.viewcount,
    });

    factory Songs.fromJson(Map<String, dynamic> json) => Songs(
        author: json["author"],
        id: json["id"],
        streamlinks: List<Streamlink>.from(json["streamlinks"].map((x) => Streamlink.fromJson(x))),
        thumbnail: json["thumbnail"],
        title: json["title"],
        viewcount: json["viewcount"],
    );

    Map<String, dynamic> toJson() => {
        "author": author,
        "id": id,
        "streamlinks": List<dynamic>.from(streamlinks.map((x) => x.toJson())),
        "thumbnail": thumbnail,
        "title": title,
        "viewcount": viewcount,
    };
}

class Streamlink {
    MimeType mimeType;
    String url;

    Streamlink({
        required this.mimeType,
        required this.url,
    });

    factory Streamlink.fromJson(Map<String, dynamic> json) => Streamlink(
        mimeType: mimeTypeValues.map[json["mimeType"]]!,
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "mimeType": mimeTypeValues.reverse[mimeType],
        "url": url,
    };
}

enum MimeType { AUDIO_MP4 }

final mimeTypeValues = EnumValues({
    "audio/mp4": MimeType.AUDIO_MP4
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
