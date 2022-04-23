import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import '../style/style.dart';
import 'search.dart';
import 'search_field.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({
    Key? key,
    required this.query,
  }) : super(key: key);

  final String query;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read<SearchSubmissionsNotifier>().query = query;
    });
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('SearchScreen'),
        ),
        body: Column(
          children: [
            SizedBox(height: topPadding),
            Padding(
              // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              padding: pagePadding,
              child: SearchField(query: query),
            ),
            // Expanded(child: Search(query: query)),
            Expanded(child: Search()),
          ],
        ),
      ),
    );
  }
}
