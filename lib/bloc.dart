import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:space_x/information.dart';

class Bloc {
  StreamController<List<Information>> _controller = StreamController();

  Stream<List<Information>> get stream => _controller.stream;
  TextEditingController textEditingController = TextEditingController();
  final GraphQLClient _client = GraphQLClient(
    cache: GraphQLCache(),
    link: HttpLink('https://api.spacex.land/graphql/'),
  );

  Bloc() {
    textEditingController.addListener(() {
      if (textEditingController.text.length > 3) {
        _loadData();
      }
    });
  }

  void _loadData() async {
    final searchText = textEditingController.text;
    final query = """
  {
  launches(find: {mission_name: "$searchText"}) {
    mission_name
    details
  }
}
""";

    final QueryOptions options = QueryOptions(
      document: gql(query),
    );

    final QueryResult result = await _client.query(options);

    final List<Information> information = [];

    Map<String, dynamic> json = result.data ?? {};
    List<dynamic> launches = json['launches'];
    for (int i = 0; i < launches.length; i++) {
      Map<String, dynamic> map = launches[i];
      String missionName = map['mission_name'];
      String details = map['details'] ?? 'unknown';
      information.add(Information(details: details, missionName: missionName));
    }

    _controller.add(information);
  }

  void dispose() {
    _controller.close();
    textEditingController.dispose();
  }
}
