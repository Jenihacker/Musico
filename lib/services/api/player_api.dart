import 'package:musico/constants/api_url.dart';
import 'package:musico/models/requests/player_req.dart';
import 'package:musico/models/response/player_res.dart';
import 'package:musico/utils/client.dart';

Map<String, String> header = {
  'X-Youtube-Client-Name': 'ANDROID_VR',
  'X-Youtube-Client-Version': '1.56.21',
  'X-Goog-Visitor-Id': 'Cgs3UGxBSGJSQjVUayim8ca9BjIKCgJJThIEGgAgJw%3D%3D',
  'Origin': 'https://www.youtube.com',
  'Sec-Fetch-Mode': 'navigate',
  'Content-Type': 'application/json',
  'PREF': 'hl=en'
};

Map<String, dynamic> data = {
  "context": {
    "client": {
      "clientName": "ANDROID_VR",
      "clientVersion": "1.56.21",
      "deviceModel": "Quest 3",
      "osVersion": "12",
      "osName": "Android",
      "androidSdkVersion": 32,
      "hl": "en",
      "timeZone": "UTC",
      "utcOffsetMinutes": 0
    }
  },
  "playbackContext": {
    "contentPlaybackContext": {
      "html5Preference": "HTML5_PREF_WANTS",
      "signatureTimestamp": 20131
    }
  }
};

class Player {
  ApiClient client = ApiClient();

  Future<SongDetailsRes?> getSongDetails(String vid) async {
    final response = await client.post(playerUrl,
        queryParamMap: {
          "key": "AIzaSyC9XL3ZjWddXya6X74dJoCTL - WEYFDNX30",
          "videoId": vid,
          "fields":
              "(streamingData.adaptiveFormats(itag,url),videoDetails(author,thumbnail,title,videoId))"
        },
        optHeaders: header,
        data: data,
        ytClientName: 'ANDROID_VR');

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
