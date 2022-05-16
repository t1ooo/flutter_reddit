import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../search/search_field.dart';
import '../user_menu.dart';
import '../widget/sliver_app_bar.dart';
import '../widget/space_bar.dart';
import 'subscriptions.dart';

// class SubscriptionsScreen extends StatelessWidget {
//   const SubscriptionsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('SubscriptionsScreen'),
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: pagePadding,
//               child: SearchField(),
//             ),
//             Container(
//               child: TabBar(
//                 labelColor: Colors.blue,
//                 tabs: [
//                   Tab(text: 'Subscriptions'),
//                   Tab(text: 'Popular'),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   Subscriptions(),
//                   Text('Custom Feed'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class SubscriptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserMenu(),
      body: DefaultTabController(
        length: 2, // This is the number of tabs.
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              PrimarySliverAppBar(
                collapsed: true,
                flexibleSpace: SpaceBar(
                  leading: IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: SpaceBarIcon(Icons.account_circle),
                    // iconData: Icons.account_circle,
                    // theme: appBarIconThemeDark,
                  ),
                  title: SearchForm(),
                ),
              ),
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  width: 100,
                  child: TabBar(
                    indicatorColor: selectedColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(text: 'Subscriptions'),
                      Tab(text: 'Custom Feed'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              ChangeNotifierProvider<CurrentUserNotifier>.value(
                value: context.read<UserAuth>().user!,
                child: Subscriptions(),
              ),
              Text('TODO'),
            ],
          ),
        ),
      ),
    );
  }
}
