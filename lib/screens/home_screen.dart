import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/blocs/favorites_bloc.dart';
import 'package:flutter_tube/blocs/videos_bloc.dart';
import 'package:flutter_tube/delegates/data_search.dart';
import 'package:flutter_tube/models/video_model.dart';
import 'package:flutter_tube/screens/video_screen.dart';
import 'package:flutter_tube/tiles/video_tile.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VideosBloc videosBloc = BlocProvider.getBloc<VideosBloc>();
    FavoritesBloc favoritesBloc = BlocProvider.getBloc<FavoritesBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Container(
            height: 25, child: Image.asset('images/yt_logo_rgb_dark.png')),
        backgroundColor: Colors.black,
        actions: [
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, VideoModel>>(
                stream: favoritesBloc.favoriteOutput,
                builder: (context, favoritesVideosSnapshot) {
                  if (favoritesVideosSnapshot.hasData) {
                    return Text(favoritesVideosSnapshot.data.length.toString());
                  } else {
                    return const SizedBox();
                  }
                }),
          ),
          IconButton(
              icon: Icon(Icons.star),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => VideoScreen()));
              }),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                String searchResult =
                    await showSearch(context: context, delegate: DataSearch());

                videosBloc.searchInput.add(searchResult);
              }),
        ],
      ),
      backgroundColor: Colors.black,
      body: StreamBuilder<List<VideoModel>>(
        stream: videosBloc.videosOutput,
        builder: (context, videosSnapshot) {
          if (videosSnapshot.hasData) {
            return ListView.builder(
                itemCount: videosSnapshot.data.length + 1,
                itemBuilder: (context, index) {
                  if (index < videosSnapshot.data.length) {
                    return VideoTile(videosSnapshot.data[index]);
                  } else if (index > 0) {
                    videosBloc.searchInput.add(null);
                    return Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                });
          }
          return Container();
        },
      ),
    );
  }
}
