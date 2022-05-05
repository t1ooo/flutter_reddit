import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import '../widget/sliver_app_bar.dart';
import '../widget/space_bar.dart';
import 'saved_comments.dart';
import 'saved_submissions.dart';

// class SavedScreen extends StatelessWidget {
//   const SavedScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           iconTheme: appBarIconThemeDark,
//           title: Text('Saved'),
//         ),
//         body: Column(
//           children: [
//             // SizedBox(height: topPadding),
//             Container(
//               color: Theme.of(context).primaryColor,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: topPadding),
//                 child: TabBar(
//                   // labelColor: Colors.blue,
//                   indicatorColor: selectedColor,
//                   indicatorSize: TabBarIndicatorSize.tab,
//                   tabs: [
//                     Tab(child: Text('Posts')),
//                     Tab(child: Text('Comments')),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   SavedSubmissions(),
//                   SavedComments(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class SavedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2, // This is the number of tabs.
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              PrimarySliverAppBar(
                // stretch: true,
                // pinned: true,
                // // snap: true,
                // primary: false,
                // // leading: Icon(Icons.back_hand),
                // automaticallyImplyLeading: false,
                // collapsedHeight: 120,
                // expandedHeight: appBarExpandedHeight,

                // flexibleSpace: SearchField(
                //   leading: AppBarBackButton.black(),
                //   showSearchForm: false,
                // ),
                flexibleSpace: SpaceBar(
                  leading: AppBarBackButton(),
                  title: AppBarTitle('Saved'),
                ),
              ),
              SliverAppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  width: 100,
                  child: TabBar(
                    indicatorColor: selectedColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(child: Text('Posts')),
                      Tab(child: Text('Comments')),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              SavedSubmissions(),
              SavedComments(),
            ],
          ),
        ),
      ),
    );
  }
}
