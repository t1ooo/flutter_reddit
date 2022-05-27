import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../notifier/subreddit_all_notifier.dart';
import '../notifier/subreddit_loader_notifier.dart';
import '../notifier/subreddit_notifier.dart';
import '../reddit_api/submission_type.dart';
import '../submission_tile/submission_tiles.dart';
import '../util/color.dart';
import '../widget/snackbar.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/loader.dart';
import '../widget/sliver_app_bar.dart';
import '../widget/swipe_to_refresh.dart';
import 'subreddit_submission.dart';
import 'subreddit_about.dart';
import 'subreddit_info.dart';

class SubredditAllScreen extends StatelessWidget {
  const SubredditAllScreen({
    Key? key,
    this.name,
  }) : super(key: key);

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            print(_);
            return [
              PrimarySliverAppBar(
                collapsed: true,
                flexibleSpace: SpaceBar(
                  leading: AppBarBackButton(),
                  title: AppBarTitle('All'),
                ),
              ),
            ];
          },
          body: Builder(builder: (_) {
            final notifier = context.watch<SubredditAllNotifier>();

            return SwipeToRefresh(
              onRefresh: () => notifier
                  .reloadSubmissions()
                  .catchError((e) => showErrorSnackBar(context, e)),
              child: SubmissionTiles<SubType>(
                type: notifier.subType,
                types: SubType.values,
                submissions: notifier.submissions,
                load: notifier.loadSubmissions,
              ),
            );
          }),
        ),
      ),
    );
  }
}
