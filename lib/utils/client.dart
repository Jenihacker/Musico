import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;

  // final Map<String, String> _headers = {
  //   "Accept": "*/*",
  //   "Host": "www.youtube.com",
  //   "X-Goog-Api-Key": "AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8",
  //   "Content-Type": "application/json",
  //   "User-Agent":
  //       "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36 Edg/105.0.1343.42",
  //   "Origin": "https://www.youtube.com",
  //   "Referer": "https://www.youtube.com/",
  //   "Accept-Encoding": "gzip, deflate",
  //   "Accept-Language": "de,de-DE;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6"
  // };

  final Map<String, String> _headers = {
    'authority': 'music.youtube.com',
    'accept': '*/*',
    'accept-language': 'en-US,en;q=0.9',
    'authorization':
        'SAPISIDHASH 1730257046_9d1172b79c34527f9f710a2bc564924ad8a145d3_u',
    'content-type': 'application/json',
    'cookie':
        'YSC=uZDqDFf2C4w; VISITOR_INFO1_LIVE=174ncMuxp6g; VISITOR_PRIVACY_METADATA=CgJJThIEGgAgXw%3D%3D; _gcl_au=1.1.2117153004.1730256981; SID=g.a000pgjHuCwjjv-lI85HaoEbpLVvIuY3pH4LWmFALJyUuiO--nNlQm0xjI5XXFAAPXvcpaJz_AACgYKAfESARcSFQHGX2Mi1m4XIueM_02Y88mjuac-eBoVAUF8yKqK9yO4j_AtQW2bc-R_B3_10076; __Secure-1PSIDTS=sidts-CjIBQT4rXyOu8H4U1LmlcG8O89X4VbEe8mMzFQ42A3jM_LQ-_erHS5HK2iGQuT6-Z-t6ixAA; __Secure-3PSIDTS=sidts-CjIBQT4rXyOu8H4U1LmlcG8O89X4VbEe8mMzFQ42A3jM_LQ-_erHS5HK2iGQuT6-Z-t6ixAA; __Secure-1PSID=g.a000pgjHuCwjjv-lI85HaoEbpLVvIuY3pH4LWmFALJyUuiO--nNliHtSwbNK7kb7bTaQiqcuvgACgYKAbISARcSFQHGX2MiGV2VGHU6QOxMQyEnJ302fRoVAUF8yKo18uOIxgECtPjoZWtSlZeQ0076; __Secure-3PSID=g.a000pgjHuCwjjv-lI85HaoEbpLVvIuY3pH4LWmFALJyUuiO--nNllftwVzqXH-0wjEVOeHi7twACgYKATESARcSFQHGX2MiNoev2iik_Z0QFQu6IYUaEBoVAUF8yKoxWdwP6vUJqNzueisNMgUe0076; HSID=AtOPcloaChvIMknbI; SSID=A57w7TuTAuCehCKRb; APISID=4wEF47qsk652bGTI/AfhpQvuVrMWRi3PX6; SAPISID=SycFd7eXXF2zQiS_/A_swiY5vqTAAfgQNS; __Secure-1PAPISID=SycFd7eXXF2zQiS_/A_swiY5vqTAAfgQNS; __Secure-3PAPISID=SycFd7eXXF2zQiS_/A_swiY5vqTAAfgQNS; LOGIN_INFO=AFmmF2swRAIgeiA03FSraB5mWuvArEMUKXK-7fV5XXfBNoIsYa6GrmACIHWCLnLtJauSNiNUOajIkwizCX3pk5uvgO9E_OoNp5HG:QUQ3MjNmemVNZERxUkdIVGtmaEhrVUdPeklGV1VmWVFtcWcwa0luaW40amNYeTFoTmlMNEkyeGR0ZG1VT0FmTGpKRldPZ216UzhsVnE2MGpGWFQyaFBmeFNleGlBaVpwNFI5akJscFFjb1BJZWhDSVgwZ29PcVJHUEVtNkx1MGo0YlVvUlZkWXZTUVRURUlQMmJSM2tKdzNYVldGb19sMkZB; SIDCC=AKEyXzXNUb1dlok42-ieRf3_R1lPr4tlnPiUAxceJz3_U-PSXmeQ3Xqf8D-FYoYpHXCwCQ6j; __Secure-1PSIDCC=AKEyXzVxadoYSJXIcpFKgBQs6eaeMDhSc7Yfdn9dXaf3FrUho4R_0_nbPF-mDOBbJTOxQDhC; __Secure-3PSIDCC=AKEyXzV3TE6plvEf48z-2P5xUArNtEPY47cbKhCX4pY5Q-8ZJCPGabk0WA2H26FOwe0Lkz3z',
    'origin': 'https://music.youtube.com',
    'referer': 'https://music.youtube.com/',
    'sec-ch-ua':
        '"Not_A Brand";v="8", "Chromium";v="120", "Google Chrome";v="120"',
    'sec-ch-ua-arch': '"x86"',
    'sec-ch-ua-bitness': '"64"',
    'sec-ch-ua-full-version': '"120.0.6099.199"',
    'sec-ch-ua-full-version-list':
        '"Not_A Brand";v="8.0.0.0", "Chromium";v="120.0.6099.199", "Google Chrome";v="120.0.6099.199"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-model': '""',
    'sec-ch-ua-platform': '"Windows"',
    'sec-ch-ua-platform-version': '"10.0.0"',
    'sec-ch-ua-wow64': '?0',
    'sec-fetch-dest': 'empty',
    'sec-fetch-mode': 'cors',
    'sec-fetch-site': 'same-origin',
    'user-agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'x-goog-authuser': '0',
    'x-goog-visitor-id': 'CgsxNzRuY011eHA2ZyjvwIa5BjIKCgJJThIEGgAgXw%3D%3D',
    'x-origin': 'https://music.youtube.com',
    'x-youtube-bootstrap-logged-in': 'true',
    'x-youtube-client-name': '67',
    'x-youtube-client-version': '1.20241028.01.00',
    'Accept-Encoding': 'gzip',
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
