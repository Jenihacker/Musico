import 'dart:convert';

SongDetailsReq songDetailsReqFromJson(String str) =>
    SongDetailsReq.fromJson(json.decode(str));

String songDetailsReqToJson(SongDetailsReq data) => json.encode(data.toJson());

class SongDetailsReq {
  StreamingData streamingData;
  VideoDetails videoDetails;

  SongDetailsReq({
    required this.streamingData,
    required this.videoDetails,
  });

  factory SongDetailsReq.fromJson(Map<String, dynamic> json) => SongDetailsReq(
        streamingData: StreamingData.fromJson(json["streamingData"]),
        videoDetails: VideoDetails.fromJson(json["videoDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "streamingData": streamingData.toJson(),
        "videoDetails": videoDetails.toJson(),
      };
}

class StreamingData {
  List<AdaptiveFormat> adaptiveFormats;

  StreamingData({
    required this.adaptiveFormats,
  });

  factory StreamingData.fromJson(Map<String, dynamic> json) => StreamingData(
        adaptiveFormats: List<AdaptiveFormat>.from(
            json["adaptiveFormats"].map((x) => AdaptiveFormat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "adaptiveFormats":
            List<dynamic>.from(adaptiveFormats.map((x) => x.toJson())),
      };
}

class AdaptiveFormat {
  int itag;
  String url;

  AdaptiveFormat({
    required this.itag,
    required this.url,
  });

  factory AdaptiveFormat.fromJson(Map<String, dynamic> json) => AdaptiveFormat(
        itag: json["itag"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "itag": itag,
        "url": url,
      };
}

class VideoDetails {
  String videoId;
  String title;
  VideoDetailsThumbnail thumbnail;
  String author;

  VideoDetails({
    required this.videoId,
    required this.title,
    required this.thumbnail,
    required this.author,
  });

  factory VideoDetails.fromJson(Map<String, dynamic> json) => VideoDetails(
        videoId: json["videoId"],
        title: json["title"],
        thumbnail: VideoDetailsThumbnail.fromJson(json["thumbnail"]),
        author: json["author"],
      );

  Map<String, dynamic> toJson() => {
        "videoId": videoId,
        "title": title,
        "thumbnail": thumbnail.toJson(),
        "author": author,
      };
}

class VideoDetailsThumbnail {
  List<ThumbnailElement> thumbnails;

  VideoDetailsThumbnail({
    required this.thumbnails,
  });

  factory VideoDetailsThumbnail.fromJson(Map<String, dynamic> json) =>
      VideoDetailsThumbnail(
        thumbnails: List<ThumbnailElement>.from(
            json["thumbnails"].map((x) => ThumbnailElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "thumbnails": List<dynamic>.from(thumbnails.map((x) => x.toJson())),
      };
}

class ThumbnailElement {
  String url;

  ThumbnailElement({
    required this.url,
  });

  factory ThumbnailElement.fromJson(Map<String, dynamic> json) =>
      ThumbnailElement(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}
