import 'dart:convert';

SearchSong searchSongFromJson(String str) =>
    SearchSong.fromJson(json.decode(str));

String searchSongToJson(SearchSong data) => json.encode(data.toJson());

class SearchSong {
  Contents contents;

  SearchSong({
    required this.contents,
  });

  factory SearchSong.fromJson(Map<String, dynamic> json) => SearchSong(
        contents: Contents.fromJson(json["contents"]),
      );

  Map<String, dynamic> toJson() => {
        "contents": contents.toJson(),
      };
}

class Contents {
  TabbedSearchResultsRenderer tabbedSearchResultsRenderer;

  Contents({
    required this.tabbedSearchResultsRenderer,
  });

  factory Contents.fromJson(Map<String, dynamic> json) => Contents(
        tabbedSearchResultsRenderer: TabbedSearchResultsRenderer.fromJson(
            json["tabbedSearchResultsRenderer"]),
      );

  Map<String, dynamic> toJson() => {
        "tabbedSearchResultsRenderer": tabbedSearchResultsRenderer.toJson(),
      };
}

class TabbedSearchResultsRenderer {
  List<Tab> tabs;

  TabbedSearchResultsRenderer({
    required this.tabs,
  });

  factory TabbedSearchResultsRenderer.fromJson(Map<String, dynamic> json) =>
      TabbedSearchResultsRenderer(
        tabs: List<Tab>.from(json["tabs"].map((x) => Tab.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "tabs": List<dynamic>.from(tabs.map((x) => x.toJson())),
      };
}

class Tab {
  TabRenderer tabRenderer;

  Tab({
    required this.tabRenderer,
  });

  factory Tab.fromJson(Map<String, dynamic> json) => Tab(
        tabRenderer: TabRenderer.fromJson(json["tabRenderer"]),
      );

  Map<String, dynamic> toJson() => {
        "tabRenderer": tabRenderer.toJson(),
      };
}

class TabRenderer {
  TabRendererContent content;

  TabRenderer({
    required this.content,
  });

  factory TabRenderer.fromJson(Map<String, dynamic> json) => TabRenderer(
        content: TabRendererContent.fromJson(json["content"]),
      );

  Map<String, dynamic> toJson() => {
        "content": content.toJson(),
      };
}

class TabRendererContent {
  SectionListRenderer sectionListRenderer;

  TabRendererContent({
    required this.sectionListRenderer,
  });

  factory TabRendererContent.fromJson(Map<String, dynamic> json) =>
      TabRendererContent(
        sectionListRenderer:
            SectionListRenderer.fromJson(json["sectionListRenderer"]),
      );

  Map<String, dynamic> toJson() => {
        "sectionListRenderer": sectionListRenderer.toJson(),
      };
}

class SectionListRenderer {
  List<SectionListRendererContent> contents;

  SectionListRenderer({
    required this.contents,
  });

  factory SectionListRenderer.fromJson(Map<String, dynamic> json) =>
      SectionListRenderer(
        contents: List<SectionListRendererContent>.from(json["contents"]
            .map((x) => SectionListRendererContent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
      };
}

class SectionListRendererContent {
  MusicShelfRenderer musicShelfRenderer;

  SectionListRendererContent({
    required this.musicShelfRenderer,
  });

  factory SectionListRendererContent.fromJson(Map<String, dynamic> json) =>
      SectionListRendererContent(
        musicShelfRenderer:
            MusicShelfRenderer.fromJson(json["musicShelfRenderer"]),
      );

  Map<String, dynamic> toJson() => {
        "musicShelfRenderer": musicShelfRenderer.toJson(),
      };
}

class MusicShelfRenderer {
  List<MusicShelfRendererContent> contents;
  List<Continuation> continuations;

  MusicShelfRenderer({
    required this.contents,
    required this.continuations,
  });

  factory MusicShelfRenderer.fromJson(Map<String, dynamic> json) =>
      MusicShelfRenderer(
        contents: List<MusicShelfRendererContent>.from(
            json["contents"].map((x) => MusicShelfRendererContent.fromJson(x))),
        continuations: List<Continuation>.from(
            json["continuations"].map((x) => Continuation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
        "continuations":
            List<dynamic>.from(continuations.map((x) => x.toJson())),
      };
}

class MusicShelfRendererContent {
  MusicTwoColumnItemRenderer musicTwoColumnItemRenderer;

  MusicShelfRendererContent({
    required this.musicTwoColumnItemRenderer,
  });

  factory MusicShelfRendererContent.fromJson(Map<String, dynamic> json) =>
      MusicShelfRendererContent(
        musicTwoColumnItemRenderer: MusicTwoColumnItemRenderer.fromJson(
            json["musicTwoColumnItemRenderer"]),
      );

  Map<String, dynamic> toJson() => {
        "musicTwoColumnItemRenderer": musicTwoColumnItemRenderer.toJson(),
      };
}

class MusicTwoColumnItemRenderer {
  MusicTwoColumnItemRendererThumbnail thumbnail;
  Title title;
  Title subtitle;
  NavigationEndpoint navigationEndpoint;

  MusicTwoColumnItemRenderer({
    required this.thumbnail,
    required this.title,
    required this.subtitle,
    required this.navigationEndpoint,
  });

  factory MusicTwoColumnItemRenderer.fromJson(Map<String, dynamic> json) =>
      MusicTwoColumnItemRenderer(
        thumbnail:
            MusicTwoColumnItemRendererThumbnail.fromJson(json["thumbnail"]),
        title: Title.fromJson(json["title"]),
        subtitle: Title.fromJson(json["subtitle"]),
        navigationEndpoint:
            NavigationEndpoint.fromJson(json["navigationEndpoint"]),
      );

  Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail.toJson(),
        "title": title.toJson(),
        "subtitle": subtitle.toJson(),
        "navigationEndpoint": navigationEndpoint.toJson(),
      };
}

class NavigationEndpoint {
  WatchEndpoint watchEndpoint;

  NavigationEndpoint({
    required this.watchEndpoint,
  });

  factory NavigationEndpoint.fromJson(Map<String, dynamic> json) =>
      NavigationEndpoint(
        watchEndpoint: WatchEndpoint.fromJson(json["watchEndpoint"]),
      );

  Map<String, dynamic> toJson() => {
        "watchEndpoint": watchEndpoint.toJson(),
      };
}

class WatchEndpoint {
  String videoId;

  WatchEndpoint({
    required this.videoId,
  });

  factory WatchEndpoint.fromJson(Map<String, dynamic> json) => WatchEndpoint(
        videoId: json["videoId"],
      );

  Map<String, dynamic> toJson() => {
        "videoId": videoId,
      };
}

class Title {
  List<Run> runs;

  Title({
    required this.runs,
  });

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        runs: List<Run>.from(json["runs"].map((x) => Run.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "runs": List<dynamic>.from(runs.map((x) => x.toJson())),
      };
}

class Run {
  String text;

  Run({
    required this.text,
  });

  factory Run.fromJson(Map<String, dynamic> json) => Run(
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
      };
}

class MusicTwoColumnItemRendererThumbnail {
  MusicThumbnailRenderer musicThumbnailRenderer;

  MusicTwoColumnItemRendererThumbnail({
    required this.musicThumbnailRenderer,
  });

  factory MusicTwoColumnItemRendererThumbnail.fromJson(
          Map<String, dynamic> json) =>
      MusicTwoColumnItemRendererThumbnail(
        musicThumbnailRenderer:
            MusicThumbnailRenderer.fromJson(json["musicThumbnailRenderer"]),
      );

  Map<String, dynamic> toJson() => {
        "musicThumbnailRenderer": musicThumbnailRenderer.toJson(),
      };
}

class MusicThumbnailRenderer {
  MusicThumbnailRendererThumbnail thumbnail;

  MusicThumbnailRenderer({
    required this.thumbnail,
  });

  factory MusicThumbnailRenderer.fromJson(Map<String, dynamic> json) =>
      MusicThumbnailRenderer(
        thumbnail: MusicThumbnailRendererThumbnail.fromJson(json["thumbnail"]),
      );

  Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail.toJson(),
      };
}

class MusicThumbnailRendererThumbnail {
  List<ThumbnailElement> thumbnails;

  MusicThumbnailRendererThumbnail({
    required this.thumbnails,
  });

  factory MusicThumbnailRendererThumbnail.fromJson(Map<String, dynamic> json) =>
      MusicThumbnailRendererThumbnail(
        thumbnails: List<ThumbnailElement>.from(
            json["thumbnails"].map((x) => ThumbnailElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "thumbnails": List<dynamic>.from(thumbnails.map((x) => x.toJson())),
      };
}

class ThumbnailElement {
  String url;
  int width;
  int height;

  ThumbnailElement({
    required this.url,
    required this.width,
    required this.height,
  });

  factory ThumbnailElement.fromJson(Map<String, dynamic> json) =>
      ThumbnailElement(
        url: json["url"],
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "width": width,
        "height": height,
      };
}

class Continuation {
  NextContinuationData nextContinuationData;

  Continuation({
    required this.nextContinuationData,
  });

  factory Continuation.fromJson(Map<String, dynamic> json) => Continuation(
        nextContinuationData:
            NextContinuationData.fromJson(json["nextContinuationData"]),
      );

  Map<String, dynamic> toJson() => {
        "nextContinuationData": nextContinuationData.toJson(),
      };
}

class NextContinuationData {
  String continuation;

  NextContinuationData({
    required this.continuation,
  });

  factory NextContinuationData.fromJson(Map<String, dynamic> json) =>
      NextContinuationData(
        continuation: json["continuation"],
      );

  Map<String, dynamic> toJson() => {
        "continuation": continuation,
      };
}
