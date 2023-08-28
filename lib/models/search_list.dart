import 'dart:convert';

List<SearchList> searchListFromJson(String str) => List<SearchList>.from(json.decode(str).map((x) => SearchList.fromJson(x)));

String searchListToJson(List<SearchList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchList {
    String title;
    String videoId;
    String duration;
    String artists;
    String thumbnails;

    SearchList({
        required this.title,
        required this.videoId,
        required this.duration,
        required this.artists,
        required this.thumbnails,
    });

    factory SearchList.fromJson(Map<String, dynamic> json) => SearchList(
        title: json["title"],
        videoId: json["videoId"],
        duration: json["duration"],
        artists: json["artists"],
        thumbnails: json["thumbnails"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "videoId": videoId,
        "duration": duration,
        "artists": artists,
        "thumbnails": thumbnails,
    };
}