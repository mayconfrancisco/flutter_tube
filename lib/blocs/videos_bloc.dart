import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_tube/api.dart';
import 'package:flutter_tube/models/video_model.dart';

class VideosBloc extends BlocBase {
  Api api;
  List<VideoModel> videos;

  final StreamController<List<VideoModel>> _videosStreamController =
      StreamController<List<VideoModel>>();
  Stream<List<VideoModel>> get videosOutput => _videosStreamController.stream;

  final StreamController _searchStreamController = StreamController();
  Sink get searchInput => _searchStreamController.sink;

  VideosBloc() {
    api = Api();

    _searchStreamController.stream.listen(_search);
  }

  _search(search) async {
    videos = await api.search(search);
    _videosStreamController.sink.add(videos);
  }

  @override
  void dispose() {
    _videosStreamController.close();
    _searchStreamController.close();
    super.dispose();
  }
}
