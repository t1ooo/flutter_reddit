import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_reddit_prototype/src/widget/swipe_to_refresh.dart';
import 'package:provider/provider.dart';

import '../submission_tile/submission_tiles.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/submission_type.dart';
import '../search/search_field.dart';
import '../style/style.dart';
import '../util/snackbar.dart';
import '../widget/subscribe_button.dart';
import 'subreddit_info.dart';
// import '../widget/subscribe_button.dart';

class SubredditWidget extends StatelessWidget {
  const SubredditWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifierQ>();
    final subreddit = notifier.subreddit;

    // TODO: remove ListView
    return ListView(
      shrinkWrap: true,
      children: [
        // SearchField(
        //   src: subreddit.bannerBackgroundImage,
        //   subreddit: subreddit.displayNamePrefixed,
        // ),
        // SubredditInfo(),
        // Text('123'),
        SwipeToRefresh(
          onRefresh: () => notifier
              .reloadSubmissions()
              .catchError((e) => showErrorSnackBar(context, e)),
          child: GSubmissionTiles<SubType>(
            type: notifier.subType,
            types: SubType.values,
            submissions: notifier.submissions,
            load:  notifier.loadSubmissions,
            // showSubreddit: false,
          ),
        ),
      ],
    );
  }
}
