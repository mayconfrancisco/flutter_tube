import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    //mayconf - gambiarra para nao dar erro de rebuild de tela
    //esse delagate foi desenvolvido para retornar os resultados aqui e desenhar na propria delegate
    //estamos retornando para a outra tela o resultado;
    Future.delayed(Duration.zero, () {
      close(context, query);
    });
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty || query.length < 3) {
      return const SizedBox();
    } else {
      return FutureBuilder<List>(
          future: suggestions(query),
          builder: (context, searchSnapshot) {
            if (!searchSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount: searchSnapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text(searchSnapshot.data[index]),
                    onTap: () {
                      close(context, searchSnapshot.data[index]);
                    },
                  );
                });
          });
    }
  }

  Future<List> suggestions(String search) async {
    http.Response response = await http.get(
        "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json");
    if (response.statusCode == 200) {
      return json.decode(response.body)[1].map((v) => v[0]).toList();
    }

    throw Exception('Failed to load suggestions');
  }
}
