import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'search_item.dart';

class FirestoreSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchItem(
      query: query,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return buildRecent(context);
    } else {
      return SearchItem(
        query: query,
      );
    }
  }

  buildRecent(BuildContext context) {
    return StreamBuilder<SharedPreferences>(
      stream: Stream.fromFuture(SharedPreferences.getInstance()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<String> recents = snapshot.data.getStringList('SearchRecent');

        if (recents != null) {
          
          recents = recents != null ? recents.toSet().toList() : null;

          int length = recents.length;

          return ListView.builder(
            itemCount: recents.length,
            itemBuilder: (context, i) {
              return ListTile(
                title: Text(recents[(length - 1) - i]),
                leading: Icon(Icons.call_missed_outgoing),
                onTap: () {
                  query = recents[(length - 1) - i];
                  showResults(context);
                },
              );
            },
          );
        }

        else{
          return Container();
        }
      },
    );
  }

  @override
  void showResults(BuildContext context) async {
    SharedPreferences snapshot = await SharedPreferences.getInstance();

    List<String> recents = snapshot.getStringList('SearchRecent') ?? [];
    if (query != null) {
      recents.add(query);
      snapshot.setStringList('SearchRecent', recents);
    }
    super.showResults(context);
  }
}
