import 'dart:convert';

import 'package:flutter_tube/models/video_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tube/app_env.dart' as APP_ENV;

class Api {
  String _search;
  String _nextToken;

  Future<List<VideoModel>> search(String search) async {
    _search = search;

    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=${APP_ENV.API_KEY}&maxResults=10");

    return decode(response);
  }

  Future<List<VideoModel>> nextPage() async {
    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=${APP_ENV.API_KEY}&maxResults=10&pageToken=$_nextToken");

    return decode(response);
  }

  List<VideoModel> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      _nextToken = decoded['nextPageToken'];

      List<VideoModel> videos = decoded['items']
          .map<VideoModel>(
              (jsonMapVideoItem) => VideoModel.fromJson(jsonMapVideoItem))
          .toList();
      return videos;
    }

    throw Exception('Failed to load videos');
  }
}
