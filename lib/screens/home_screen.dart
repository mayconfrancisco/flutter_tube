import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tube/blocs/videos_bloc.dart';
import 'package:flutter_tube/delegates/data_search.dart';
import 'package:flutter_tube/models/video_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            height: 25, child: Image.asset('images/yt_logo_rgb_dark.png')),
        backgroundColor: Colors.black,
        actions: [
          Align(
            alignment: Alignment.center,
            child: Text('0'),
          ),
          IconButton(icon: Icon(Icons.star), onPressed: () {}),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                String searchResult =
                    await showSearch(context: context, delegate: DataSearch());

                BlocProvider.getBloc<VideosBloc>()
                    .searchInput
                    .add(searchResult);
              }),
        ],
      ),
      body: StreamBuilder<List<VideoModel>>(
        stream: BlocProvider.getBloc<VideosBloc>().videosOutput,
        builder: (context, videosSnapshot) {
          if (videosSnapshot.hasData) {
            return ListView.builder(
                itemCount: videosSnapshot.data.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(videosSnapshot.data[index].title),
                    ),
                  );
                });
          }
          return Container();
        },
      ),
    );
  }
}
