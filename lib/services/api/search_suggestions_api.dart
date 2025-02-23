import 'package:musico/constants/api_url.dart';
import 'package:musico/models/requests/search_suggestion.dart';
import 'package:musico/utils/client.dart';

class SearchSuggestionApi {
  ApiClient client = ApiClient();

  Future<List<String>?> getSuggestion(String q) async {
    final response = await client.post(searchSuggestionUrl,
        queryParamMap: {
          "key": "AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8",
          "input": q,
          "fields":
              "contents.searchSuggestionsSectionRenderer.contents(searchSuggestionRenderer.navigationEndpoint.searchEndpoint,musicTwoColumnItemRenderer(navigationEndpoint.watchEndpoint.videoId,subtitle,title,thumbnail.musicThumbnailRenderer.thumbnail))"
        },
        ytClientName: "IOS_MUSIC");

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
