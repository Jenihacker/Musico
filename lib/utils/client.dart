import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;

  final Map<String, String> _headers = {
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

  final Map<String, dynamic> _data = {
    "context": {
      "client": {
        "hl": "en",
        "gl": "US",
        "clientName": "WEB_REMIX",
        "clientVersion": "1.20220918",
        "clientScreen": "WATCH",
        "androidSdkVersion": 31
      }
    },
  };

  Map<String, dynamic> ytClients = {
    "WEB_REMIX": {"clientName": "WEB_REMIX", "clientVersion": "1.20220918"},
    "ANDROID_MUSIC": {"clientName": "ANDROID_MUSIC", "clientVersion": "6.01"},
    "IOS_MUSIC": {"clientName": "IOS_MUSIC", "clientVersion": "6.01"},
    "ANDROID_VR": {"clientName": "ANDROID_VR", "clientVersion": "1.56.21"}
  };

  ApiClient() : _client = http.Client();

  Future<http.Response> get(String uri,
      [Map<String, String>? queryParamMap]) async {
    try {
      if (queryParamMap != null && queryParamMap.isNotEmpty) {
        uri += _getQueryParams(queryParamMap);
      }

      final response = await _client.get(Uri.parse(uri), headers: _headers);
      return jsonDecode(response.body.toString());
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<http.Response> post(String uri,
      {Map<String, String>? queryParamMap,
      Map<String, dynamic>? data,
      Map<String, String>? optHeaders,
      required String ytClientName}) async {
    try {
      if (queryParamMap != null && queryParamMap.isNotEmpty) {
        uri += _getQueryParams(queryParamMap);
      }

      if (ytClientName.isNotEmpty) {
        _data["context"]["client"]["clientName"] =
            ytClients[ytClientName]["clientName"];
        _data["context"]["client"]["clientVersion"] =
            ytClients[ytClientName]["clientVersion"];
      }

      final response = await _client.post(Uri.parse(uri),
          headers:
              optHeaders != null && optHeaders.isNotEmpty ? optHeaders : {},
          body: data != null && data.isNotEmpty
              ? jsonEncode(data)
              : jsonEncode(_data));

      return response;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  String _getQueryParams(Map<String, String> queryParamMap) {
    final queryString = Uri(queryParameters: queryParamMap).query;
    return queryString.isNotEmpty ? '?$queryString' : '';
  }

  void dispose() {
    _client.close();
  }
}
