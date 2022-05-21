import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style.dart';
import 'package:provider/provider.dart';

import '../notifier/auth_notifier.dart';
import '../notifier/collapsible.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/current_user_notifier.dart';
import '../notifier/home_front_notifier.dart';
import '../notifier/home_popular_notifier.dart';
import '../notifier/iterable_sum.dart';
import '../notifier/likable.dart';
import '../notifier/limit.dart';
import '../notifier/list_notifier.dart';
import '../notifier/message_notifier.dart';
import '../notifier/property_listener.dart';
import '../notifier/replyable.dart';
import '../notifier/reportable.dart';
import '../notifier/rule_notifier.dart';
import '../notifier/savable.dart';
import '../notifier/score.dart';
import '../notifier/search_notifier.dart';
import '../notifier/search_subreddits_notifier.dart';
import '../notifier/submission_loader_notifier.dart';
import '../notifier/submission_notifier.dart';
import '../notifier/submissions_notifier.dart';
import '../notifier/subreddit_loader_notifier.dart';
import '../notifier/subreddit_notifier.dart';
import '../notifier/try_mixin.dart';
import '../notifier/user_loader_notifier.dart';
import '../notifier/user_notifier.dart';
import '../current_user/user_menu.dart';
import '../widget/sliver_app_bar.dart';
import 'subscriptions.dart';

class SubscriptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: UserMenu(),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              PrimarySliverAppBar(
                collapsed: true,
                flexibleSpace: SpaceBar(
                  leading: IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: SpaceBarIcon(Icons.account_circle),
                  ),
                  title: SearchForm(),
                ),
              ),
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                flexibleSpace: TabBar(
                  tabs: [
                    Tab(text: 'Subscriptions'),
                    Tab(text: 'Custom Feed'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              ChangeNotifierProvider<CurrentUserNotifier>.value(
                value: context.read<AuthNotifier>().user!,
                child: Subscriptions(),
              ),
              Card(child: Padding(
                padding: cardPadding,
                child: Text('TODO'),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
