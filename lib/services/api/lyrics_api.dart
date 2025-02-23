import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:musico/constants/api_url.dart';
import 'package:musico/utils/client.dart';

final dio = Dio();

class Lyrics {
  ApiClient client = ApiClient();

  Future<String> getLyrics(String vid) async {
    // var response = await dio.post(
    //     'https://music.youtube.com/youtubei/v1/next?key=AIzaSyC9XL3ZjWddXya6X74dJoCTL-WEYFDNX30&videoId=$vid&fields=contents.singleColumnMusicWatchNextResultsRenderer.tabbedRenderer.watchNextTabbedResultsRenderer.tabs.tabRenderer(endpoint.browseEndpoint.browseId,title)',
    //     data: _data);

    var response = await client.post(nextUrl,
        queryParamMap: {
          "key": "AIzaSyC9XL3ZjWddXya6X74dJoCTL-WEYFDNX30",
          "videoId": vid,
          "fields":
              "contents.singleColumnMusicWatchNextResultsRenderer.tabbedRenderer.watchNextTabbedResultsRenderer.tabs.tabRenderer(endpoint.browseEndpoint.browseId,title)"
        },
        ytClientName: "ANDROID_MUSIC");

    var data = jsonDecode(response.body.toString());

    data = data["contents"]["singleColumnMusicWatchNextResultsRenderer"]
            ["tabbedRenderer"]["watchNextTabbedResultsRenderer"]["tabs"][1]
        ["tabRenderer"]["endpoint"]["browseEndpoint"]["browseId"];

    response = await client.post(browseUrl,
        queryParamMap: {
          "key": "AIzaSyC9XL3ZjWddXya6X74dJoCTL-WEYFDNX30",
          "browseId": data,
          "fields": "contents"
        },
        ytClientName: "ANDROID_MUSIC");
    data = jsonDecode(response.body.toString());
    try {
      String lyrics = data["contents"].isNotEmpty
          ? data["contents"]["sectionListRenderer"]["contents"][0]
                  ["musicDescriptionShelfRenderer"]["description"]["runs"][0]
              ["text"]
          : "Lyrics not available";
      return lyrics;
    } catch (e) {
      return "No Lyrics Available";
    }
  }
}
