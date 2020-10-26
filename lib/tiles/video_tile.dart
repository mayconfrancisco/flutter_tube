import 'package:flutter/material.dart';
import 'package:flutter_tube/models/video_model.dart';

class VideoTile extends StatelessWidget {
  final VideoModel videoModel;

  VideoTile(this.videoModel);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              IconButton(
                icon: Icon(
                  Icons.star_border,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );
  }
}
