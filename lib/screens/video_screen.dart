import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/blocs/favorites_bloc.dart';
import 'package:flutter_tube/models/video_model.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

import 'package:flutter_tube/app_env.dart' as APP_ENV;

class VideoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FavoritesBloc favoritesBloc = BlocProvider.getBloc<FavoritesBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder<Map<String, VideoModel>>(
        initialData: {},
        stream: favoritesBloc.favoriteOutput,
        builder: (context, favoritesVideosSnapshot) {
          return ListView(
            children: favoritesVideosSnapshot.data.values
                .map((videoModel) => InkWell(
                      onTap: () {
                        FlutterYoutube.playYoutubeVideoById(
                            apiKey: APP_ENV.API_KEY, videoId: videoModel.id);
                      },
                      onLongPress: () {
                        favoritesBloc.toggleFavorite(videoModel);
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 50,
                            child: Image.network(videoModel.thumb),
                          ),
                          Expanded(
                              child: Text(
                            videoModel.title,
                            maxLines: 2,
                            style: TextStyle(color: Colors.white70),
                          ))
                        ],
                      ),
                    ))
                .toList(),
          );
        },
      ),
    );
  }
}
