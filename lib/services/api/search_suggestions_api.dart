import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:musico/models/requests/search_suggestion.dart';

class SearchSuggestionApi {
  final Map<String, String> _header = {
    "Accept": "*/*",
    "Host": "www.youtube.com",
    "Content-Type": "application/json",
    "X-Goog-Api-Key": "AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8",
    "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36 Edg/105.0.1343.42",
    "Origin": "https://www.youtube.com",
    "Referer": "https://www.youtube.com/",
    "Accept-Encoding": "gzip, deflate",
    "Accept-Language": "de,de-DE;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6",
  };

  final String _data = jsonEncode({
    "context": {
      "client": {
        "hl": "en",
        "gl": "US",
        "clientName": "IOS_MUSIC",
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

  Future<List<String>?> getSuggestion(String q) async {
    final response = await http.post(
        Uri.parse(
            "https://music.youtube.com/youtubei/v1/music/get_search_suggestions?key=AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8&input=$q&fields=contents.searchSuggestionsSectionRenderer.contents(searchSuggestionRenderer.navigationEndpoint.searchEndpoint,musicTwoColumnItemRenderer(navigationEndpoint.watchEndpoint.videoId,subtitle,title,thumbnail.musicThumbnailRenderer.thumbnail))"),
        headers: _header,
        body: _data);
    try {
      SearchSuggestionReq suggestionlist =
          searchSuggestionReqFromJson(response.body.toString());
      List<String> suggestions = [];
      for (int i = 0;
          i <
              suggestionlist
                  .contents[0].searchSuggestionsSectionRenderer.contents.length;
          i++) {
        suggestions.add(suggestionlist
            .contents[0]
            .searchSuggestionsSectionRenderer
            .contents[i]
            .searchSuggestionRenderer!
            .navigationEndpoint
            .searchEndpoint
            .query);
      }
      return suggestions;
    } catch (e) {
      return null;
    }
  }
}
