import 'package:flutter/material.dart';

import '../style/style.dart';
import '../widget/sliver_app_bar.dart';
import '../widget/space_bar.dart';
import 'search.dart';
// import 'search_field.dart';

// class SearchScreen extends StatelessWidget {
//   const SearchScreen({
//     Key? key,
//     required this.query,
//   }) : super(key: key);

//   final String query;

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('SearchScreen'),
//         ),
//         body: Column(
//           children: [
//             SizedBox(height: topPadding),
//             Padding(
//               padding: pagePadding,
//               child: SearchField(query: query),
//             ),
//             Expanded(child: Search(query: query)),
//           ],
//         ),
//       ),
//     );
//   }
// }

class SearchScreen extends StatelessWidget {
  SearchScreen({
    Key? key,
    required this.query,
  }) : super(key: key);

  final String query;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          print(innerBoxIsScrolled);
          return [
            PrimarySliverAppBar(
              flexibleSpace: SpaceBar(
                leading: AppBarBackButton(),
                // leading: AppBarBackButton.black(),
                title: SearchForm(query: query),
              ),
            ),
          ];
        },
        // body: Expanded(child: Search(query: query)),
        body: Search(query: query),
      ),
    );
  }
}
