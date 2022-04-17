import 'package:flutter/material.dart';

import 'search.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({
    Key? key,
    required this.query,
  }) : super(key: key);

  final String query;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('SearchScreen'),
        ),
        body: Search(query:query),
      ),
    );
  }

}
