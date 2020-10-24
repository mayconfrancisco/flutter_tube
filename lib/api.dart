import 'dart:convert';

import 'package:flutter_tube/models/video_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tube/app_env.dart' as APP_ENV;

class Api {
  search(String search) async {
    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=${APP_ENV.API_KEY}&maxResults=10");

    decode(response);
  }

  List<VideoModel> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      List<VideoModel> videos = decoded['items']
          .map<VideoModel>(
              (jsonMapVideoItem) => VideoModel.fromJson(jsonMapVideoItem))
          .toList();
      return videos;
    }

    throw Exception('Failed to load videos');
  }
}
