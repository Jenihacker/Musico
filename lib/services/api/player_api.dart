import 'dart:convert';

import 'package:musico/models/requests/player_req.dart';
import 'package:musico/models/response/player_res.dart';
import 'package:http/http.dart' as http;

Map<String, String> header = {
  "Accept": "*/*",
  "Host": "www.youtube.com",
  "X-Goog-Api-Key": "AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8",
  "Content-Type": "application/json",
  "User-Agent":
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36 Edg/105.0.1343.42",
  "Origin": "https://www.youtube.com",
  "Referer": "https://www.youtube.com/",
  "Accept-Encoding": "gzip, deflate",
  "Accept-Language": "de,de-DE;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6",
  "Access-Control-Allow-Origin" : "*"
};

String data = jsonEncode({
  "context": {
    "client": {
      "hl": "en",
      "gl": "US",
      "clientName": "ANDROID_MUSIC",
      "clientVersion": "5.26.1",
      "clientScreen": "WATCH",
      "androidSdkVersion": 31
    },
    "thirdParty": {"embedUrl": "https://www.youtube.com/"}
  },
  "playbackContext": {
    "contentPlaybackContext": {"signatureTimestamp": 19250}
  },
  "racyCheckOk": true,
  "contentCheckOk": true
});

class Player {
  Future<SongDetailsRes?> getSongDetails(String vid) async {
    final response = await http.post(
        Uri.parse(
            'https://music.youtube.com/youtubei/v1/player?key=AIzaSyC9XL3ZjWddXya6X74dJoCTL-WEYFDNX30&videoId=$vid&fields=(streamingData.adaptiveFormats(itag,url),videoDetails(author,thumbnail,title,videoId))'),
        headers: header,
        body: data);
    try {
      SongDetailsReq songinfo =
          songDetailsReqFromJson(response.body.toString());
      late String streamlink;
      for (int i = 0; i < songinfo.streamingData.adaptiveFormats.length; i++) {
        if (songinfo.streamingData.adaptiveFormats[i].itag == 251 ||
            songinfo.streamingData.adaptiveFormats[i].itag == 140) {
          streamlink = songinfo.streamingData.adaptiveFormats[i].url;
        }
      }
      return SongDetailsRes(
          title: songinfo.videoDetails.title,
          author: songinfo.videoDetails.author,
          thumbnail: songinfo
              .videoDetails
              .thumbnail
              .thumbnails[songinfo.videoDetails.thumbnail.thumbnails.length - 1]
              .url,
          streamlink: streamlink,
          videoid: songinfo.videoDetails.videoId);
    } catch (e) {
      return null;
    }
  }
}