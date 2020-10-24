import 'package:flutter/material.dart';
import 'package:flutter_tube/delegates/data_search.dart';

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
                print(searchResult);
              }),
        ],
      ),
      body: Container(),
    );
  }
}
