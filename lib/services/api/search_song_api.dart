import 'dart:convert';
import 'package:musico/models/response/search_song.dart';
import 'package:http/http.dart' as http;

Map<String, String> _header = {
  "Accept": "*/*",
  "Host": "www.youtube.com",
  "X-Goog-Api-Key": "AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8",
  "Content-Type": "application/json",
  "User-Agent":
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36 Edg/105.0.1343.42",
  "Origin": "https://www.youtube.com",
  "Referer": "https://www.youtube.com/",
  "Accept-Encoding": "gzip, deflate",
  "Accept-Language": "de,de-DE;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6"
};

String _data = jsonEncode({
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

String _data1 = jsonEncode({
  "context": {
    "client": {
      "hl": "en",
      "gl": "US",
      "clientName": "WEB_REMIX",
      "clientVersion": "1.20220918",
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

class SearchSongs {
  Future<List<SongInfo?>> getSongs(String query) async {
    try {
      final response = await http.post(
          Uri.parse(
              "https://music.youtube.com/youtubei/v1/search?key=AIzaSyC9XL3ZjWddXya6X74dJoCTL-WEYFDNX30&query=$query&params=EgWKAQIIAWoMEA4QChADEAQQCRAF&fields=contents.tabbedSearchResultsRenderer.tabs.tabRenderer.content.sectionListRenderer.contents.musicShelfRenderer(contents.musicTwoColumnItemRenderer(thumbnail.musicThumbnailRenderer.thumbnail,title,subtitle,navigationEndpoint.watchEndpoint.videoId),continuations.nextContinuationData.continuation)"),
          headers: _header,
          body: _data);
      List<SongInfo?> li = [];
      var data1 = jsonDecode(response.body.toString());
      List<dynamic> content = data1["contents"]["tabbedSearchResultsRenderer"]
              ["tabs"][0]["tabRenderer"]["content"]["sectionListRenderer"]
          ["contents"];
      late dynamic contents;
      late String continuation;
      if (content[0].isNotEmpty) {
        contents = content[0]["musicShelfRenderer"]["contents"];
        continuation = data1["contents"]["tabbedSearchResultsRenderer"]["tabs"]
                    [0]["tabRenderer"]["content"]["sectionListRenderer"]
                ["contents"][0]["musicShelfRenderer"]["continuations"][0]
            ["nextContinuationData"]["continuation"];
      } else {
        contents = content[1]["musicShelfRenderer"]["contents"];
        continuation = "";
      }
      for (int i = 0; i < contents.length; i++) {
        SongInfo songinfo = SongInfo(
            title: contents[i]["musicTwoColumnItemRenderer"]["title"]["runs"][0]
                ["text"],
            videoId: contents[i]["musicTwoColumnItemRenderer"]
                ["navigationEndpoint"]["watchEndpoint"]["videoId"],
            duration: contents[i]["musicTwoColumnItemRenderer"]["subtitle"]
                ["runs"][2]["text"],
            artists: contents[i]["musicTwoColumnItemRenderer"]["subtitle"]
                ["runs"][0]["text"],
            thumbnails: contents[i]["musicTwoColumnItemRenderer"]["thumbnail"]
                        ["musicThumbnailRenderer"]["thumbnail"]["thumbnails"]
                    [contents[i]["musicTwoColumnItemRenderer"]["thumbnail"]["musicThumbnailRenderer"]["thumbnail"]["thumbnails"].length - 1]
                ["url"],
            continuations: continuation);
        li.add(songinfo);
      }
      return li;
    } catch (e) {
      return <SongInfo>[];
    }
  }

  Future<List<SongInfo?>> getVideos(String q) async {
    final response = await http.post(
        Uri.parse(
            'https://music.youtube.com/youtubei/v1/search?key=AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8 HTTP/2&query=$q&params=EgWKAQIQAWoMEA4QChADEAQQCRAF&fields=contents.tabbedSearchResultsRenderer.tabs.tabRenderer.content.sectionListRenderer.contents.musicShelfRenderer(contents.musicResponsiveListItemRenderer(thumbnail.musicThumbnailRenderer.thumbnail,flexColumns.musicResponsiveListItemFlexColumnRenderer.text.runs(text,navigationEndpoint.watchEndpoint.videoId)),continuations)'),
        body: _data1);
    List<SongInfo?> li = [];
    var data1 = jsonDecode(response.body.toString());
    List<dynamic> content = data1["contents"]["tabbedSearchResultsRenderer"]
            ["tabs"][0]["tabRenderer"]["content"]["sectionListRenderer"]
        ["contents"];
    late dynamic contents;
    late String continuation;
    if (content[0].isNotEmpty) {
      contents = content[0]["musicShelfRenderer"]["contents"];
      continuation = content[0]["musicShelfRenderer"]["continuations"][0]
          ["nextContinuationData"]["continuation"];
    } else if (content.isNotEmpty) {
      contents = content[1]["musicShelfRenderer"]["contents"];
      continuation = content[1]["musicShelfRenderer"].containsKey('continuations') ? content[1]["musicShelfRenderer"]["continuations"][0]["nextContinuationData"]["continuation"] : ""; 
    } else {
      return li;
    }
    for (int i = 0; i < contents.length; i++) {
      if(contents[i]["musicResponsiveListItemRenderer"]["flexColumns"][0]["musicResponsiveListItemFlexColumnRenderer"]["text"]
            ["runs"][0]["navigationEndpoint"].containsKey('watchEndpoint')){SongInfo songinfo = SongInfo(
          title: contents[i]["musicResponsiveListItemRenderer"]["flexColumns"][0]["musicResponsiveListItemFlexColumnRenderer"]
              ["text"]["runs"][0]["text"],
          videoId: contents[i]["musicResponsiveListItemRenderer"]["flexColumns"][0]["musicResponsiveListItemFlexColumnRenderer"]["text"]
              ["runs"][0]["navigationEndpoint"]["watchEndpoint"]["videoId"],
          duration: contents[i]["musicResponsiveListItemRenderer"]["flexColumns"][1]["musicResponsiveListItemFlexColumnRenderer"]["text"]["runs"].length - 1 > 0
              ? contents[i]["musicResponsiveListItemRenderer"]["flexColumns"][1]
                      ["musicResponsiveListItemFlexColumnRenderer"]["text"]["runs"]
                  [contents[i]["musicResponsiveListItemRenderer"]["flexColumns"][1]["musicResponsiveListItemFlexColumnRenderer"]["text"]["runs"].length - 1]["text"]
              : '0:00',
          artists: contents[i]["musicResponsiveListItemRenderer"]["flexColumns"][1]["musicResponsiveListItemFlexColumnRenderer"]["text"]["runs"][0]["text"],
          thumbnails: contents[i]["musicResponsiveListItemRenderer"]["thumbnail"]["musicThumbnailRenderer"]["thumbnail"]["thumbnails"][0]["url"],
          continuations: continuation);
      li.add(songinfo);
}    }
    return li;
  }
}
