import 'dart:convert';
import 'package:dio/dio.dart';

final dio = Dio();

class Lyrics {
  final String _data = jsonEncode({
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

  Future<String> getLyrics(String vid) async {
    var response = await dio.post(
        'https://music.youtube.com/youtubei/v1/next?key=AIzaSyC9XL3ZjWddXya6X74dJoCTL-WEYFDNX30&videoId=$vid&fields=contents.singleColumnMusicWatchNextResultsRenderer.tabbedRenderer.watchNextTabbedResultsRenderer.tabs.tabRenderer(endpoint.browseEndpoint.browseId,title)',
        data: _data);
    var data1 = jsonDecode(response.toString());
    data1 = data1["contents"]["singleColumnMusicWatchNextResultsRenderer"]
            ["tabbedRenderer"]["watchNextTabbedResultsRenderer"]["tabs"][1]
        ["tabRenderer"]["endpoint"]["browseEndpoint"]["browseId"];
    response = await dio.post(
        'https://music.youtube.com/youtubei/v1/browse?key=AIzaSyC9XL3ZjWddXya6X74dJoCTL-WEYFDNX30&browseId=$data1&fields=contents',
        data: _data);
    data1 = jsonDecode(response.toString());
    try {
      String lyrics = data1["contents"].isNotEmpty
          ? data1["contents"]["sectionListRenderer"]["contents"][0]
                  ["musicDescriptionShelfRenderer"]["description"]["runs"][0]
              ["text"]
          : "Lyrics not available";
      return lyrics;
    } catch (e) {
      return "No Lyrics Available";
    }
  }
}
