import 'dart:convert';

SearchSuggestionReq searchSuggestionReqFromJson(String str) =>
    SearchSuggestionReq.fromJson(json.decode(str));

String searchSuggestionReqToJson(SearchSuggestionReq data) =>
    json.encode(data.toJson());

class SearchSuggestionReq {
  List<SearchSuggestionReqContent> contents;

  SearchSuggestionReq({
    required this.contents,
  });

  factory SearchSuggestionReq.fromJson(Map<String, dynamic> json) =>
      SearchSuggestionReq(
        contents: List<SearchSuggestionReqContent>.from(json["contents"]
            .map((x) => SearchSuggestionReqContent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
      };
}

class SearchSuggestionReqContent {
  SearchSuggestionsSectionRenderer searchSuggestionsSectionRenderer;

  SearchSuggestionReqContent({
    required this.searchSuggestionsSectionRenderer,
  });

  factory SearchSuggestionReqContent.fromJson(Map<String, dynamic> json) =>
      SearchSuggestionReqContent(
        searchSuggestionsSectionRenderer:
            SearchSuggestionsSectionRenderer.fromJson(
                json["searchSuggestionsSectionRenderer"]),
      );

  Map<String, dynamic> toJson() => {
        "searchSuggestionsSectionRenderer":
            searchSuggestionsSectionRenderer.toJson(),
      };
}

class SearchSuggestionsSectionRenderer {
  List<SearchSuggestionsSectionRendererContent> contents;

  SearchSuggestionsSectionRenderer({
    required this.contents,
  });

  factory SearchSuggestionsSectionRenderer.fromJson(
          Map<String, dynamic> json) =>
      SearchSuggestionsSectionRenderer(
        contents: List<SearchSuggestionsSectionRendererContent>.from(
            json["contents"].map(
                (x) => SearchSuggestionsSectionRendererContent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
      };
}

class SearchSuggestionsSectionRendererContent {
  SearchSuggestionRenderer? searchSuggestionRenderer;

  SearchSuggestionsSectionRendererContent({
    this.searchSuggestionRenderer,
  });

  factory SearchSuggestionsSectionRendererContent.fromJson(
          Map<String, dynamic> json) =>
      SearchSuggestionsSectionRendererContent(
        searchSuggestionRenderer: json["searchSuggestionRenderer"] == null
            ? null
            : SearchSuggestionRenderer.fromJson(
                json["searchSuggestionRenderer"]),
      );

  Map<String, dynamic> toJson() => {
        "searchSuggestionRenderer": searchSuggestionRenderer?.toJson(),
      };
}

class SearchSuggestionRenderer {
  NavigationEndpoint navigationEndpoint;

  SearchSuggestionRenderer({
    required this.navigationEndpoint,
  });

  factory SearchSuggestionRenderer.fromJson(Map<String, dynamic> json) =>
      SearchSuggestionRenderer(
        navigationEndpoint:
            NavigationEndpoint.fromJson(json["navigationEndpoint"]),
      );

  Map<String, dynamic> toJson() => {
        "navigationEndpoint": navigationEndpoint.toJson(),
      };
}

class NavigationEndpoint {
  SearchEndpoint searchEndpoint;

  NavigationEndpoint({
    required this.searchEndpoint,
  });

  factory NavigationEndpoint.fromJson(Map<String, dynamic> json) =>
      NavigationEndpoint(
        searchEndpoint: SearchEndpoint.fromJson(json["searchEndpoint"]),
      );

  Map<String, dynamic> toJson() => {
        "searchEndpoint": searchEndpoint.toJson(),
      };
}

class SearchEndpoint {
  String query;

  SearchEndpoint({
    required this.query,
  });

  factory SearchEndpoint.fromJson(Map<String, dynamic> json) => SearchEndpoint(
        query: json["query"],
      );

  Map<String, dynamic> toJson() => {
        "query": query,
      };
}
