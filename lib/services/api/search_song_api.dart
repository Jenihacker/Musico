import 'dart:convert';
import 'package:musico/constants/api_url.dart';
import 'package:musico/models/response/search_song.dart';
import 'package:musico/utils/client.dart';

class SearchSongs {
  ApiClient client = ApiClient();

  Future<List<SongInfo?>> getSongs(String query) async {
    try {
      final response = await client.post(searchUrl,
          queryParamMap: {
            "query": query,
            "key": "AIzaSyC9XL3ZjWddXya6X74dJoCTL-WEYFDNX30",
            "params": "EgWKAQIIAWoMEA4QChADEAQQCRAF",
            "fields":
                "contents.tabbedSearchResultsRenderer.tabs.tabRenderer.content.sectionListRenderer.contents.musicShelfRenderer(contents.musicTwoColumnItemRenderer(thumbnail.musicThumbnailRenderer.thumbnail,title,subtitle,navigationEndpoint.watchEndpoint.videoId),continuations.nextContinuationData.continuation)"
          },
          ytClientName: "ANDROID_MUSIC");

      List<SongInfo?> li = [];
      var data = jsonDecode(response.body.toString());

      List<dynamic> content = data["contents"]["tabbedSearchResultsRenderer"]
              ["tabs"][0]["tabRenderer"]["content"]["sectionListRenderer"]
          ["contents"];
      
      late dynamic contents;
      late String continuation;
      if (content[0].isNotEmpty) {
        contents = content[0]["musicShelfRenderer"]["contents"];
        continuation = data["contents"]["tabbedSearchResultsRenderer"]["tabs"]
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
      print(e);
      return <SongInfo>[];
    }
  }

  Future<List<SongInfo?>> getVideos(String query) async {
    final response = await client.post(searchUrl,
        queryParamMap: {
          "query": query,
          "key": "AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8",
          "params": "EgWKAQIQAWoMEA4QChADEAQQCRAF",
          "fields":
              "contents.tabbedSearchResultsRenderer.tabs.tabRenderer.content.sectionListRenderer.contents.musicShelfRenderer(contents.musicResponsiveListItemRenderer(thumbnail.musicThumbnailRenderer.thumbnail,flexColumns.musicResponsiveListItemFlexColumnRenderer.text.runs(text,navigationEndpoint.watchEndpoint.videoId)),continuations)"
        },
        ytClientName: "WEB_REMIX");

    // final response = await http.post(
    //     Uri.parse(
    //         'https://music.youtube.com/youtubei/v1/search?key=AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8 HTTP/2&query=$q&params=EgWKAQIQAWoMEA4QChADEAQQCRAF&fields=contents.tabbedSearchResultsRenderer.tabs.tabRenderer.content.sectionListRenderer.contents.musicShelfRenderer(contents.musicResponsiveListItemRenderer(thumbnail.musicThumbnailRenderer.thumbnail,flexColumns.musicResponsiveListItemFlexColumnRenderer.text.runs(text,navigationEndpoint.watchEndpoint.videoId)),continuations)'),
    //     body: _data1);
    List<SongInfo?> li = [];
    var data1 = jsonDecode(response.body.toString());
    List<dynamic> content = data1["contents"]["tabbedSearchResultsRenderer"]
            ["tabs"][0]["tabRenderer"]["content"]["sectionListRenderer"]
        ["contents"];
    late dynamic contents;
    late String continuation;
    if (content[0].isNotEmpty) {
      contents = content[0]["musicShelfRenderer"]["contents"];
      continuation =
          content[0]["musicShelfRenderer"].containsKey('continuations')
              ? content[0]["musicShelfRenderer"]["continuations"][0]
                  ["nextContinuationData"]["continuation"]
              : "";
    } else if (content.isNotEmpty) {
      contents = content[1]["musicShelfRenderer"]["contents"];
      continuation =
          content[1]["musicShelfRenderer"].containsKey('continuations')
              ? content[1]["musicShelfRenderer"]["continuations"][0]
                  ["nextContinuationData"]["continuation"]
              : "";
    } else {
      return li;
    }
    for (int i = 0; i < contents.length; i++) {
      if (contents[i]["musicResponsiveListItemRenderer"]["flexColumns"][0]
                  ["musicResponsiveListItemFlexColumnRenderer"]["text"]["runs"]
              [0]["navigationEndpoint"]
          .containsKey('watchEndpoint')) {
        SongInfo songinfo = SongInfo(
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
      }
    }
    return li;
  }
}
