import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/blocs/favorites_bloc.dart';
import 'package:flutter_tube/models/video_model.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

import 'package:flutter_tube/app_env.dart' as APP_ENV;

class VideoTile extends StatelessWidget {
  final VideoModel videoModel;

  VideoTile(this.videoModel);

  @override
  Widget build(BuildContext context) {
    FavoritesBloc favoritesBloc = BlocProvider.getBloc<FavoritesBloc>();

    return GestureDetector(
      onTap: () {
        FlutterYoutube.playYoutubeVideoById(
            apiKey: APP_ENV.API_KEY, videoId: videoModel.id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                videoModel.thumb,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(
                        videoModel.title,
                        maxLines: 2,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        videoModel.channel,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                )),
                StreamBuilder<Map<String, VideoModel>>(
                    stream: favoritesBloc.favoriteOutput,
                    builder: (context, favoritesVideosSnapshot) {
                      return favoritesVideosSnapshot.hasData
                          ? IconButton(
                              icon: Icon(
                                favoritesVideosSnapshot.data
                                        .containsKey(videoModel.id)
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () {
                                favoritesBloc.toggleFavorite(videoModel);
                              },
                            )
                          : CircularProgressIndicator();
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
