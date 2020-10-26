import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_tube/models/video_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesBloc extends BlocBase {
  Map<String, VideoModel> _favorites = {};

  final BehaviorSubject<Map<String, VideoModel>> _favoritesController =
      BehaviorSubject<Map<String, VideoModel>>();

  Stream<Map<String, VideoModel>> get favoriteOutput =>
      _favoritesController.stream;

  FavoritesBloc() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey("favorites")) {
        _favorites =
            json.decode(prefs.getString('favorites')).map((key, value) {
          return MapEntry(key, VideoModel.fromJson(value));
        }).cast<String, VideoModel>();

        _favoritesController.sink.add(_favorites);
      }
    });
  }

  void toggleFavorite(VideoModel videoModel) {
    if (_favorites.containsKey(videoModel.id)) {
      _favorites.remove(videoModel.id);
    } else {
      _favorites[videoModel.id] = videoModel;
    }

    _favoritesController.sink.add(_favorites);

    _saveFavorite();
  }

  void _saveFavorite() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("favorites", json.encode(_favorites));
    });
  }

  @override
  void dispose() {
    _favoritesController.close();
    super.dispose();
  }
}
