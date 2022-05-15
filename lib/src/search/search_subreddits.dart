import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_reddit_prototype/src/logging/logging.dart';
import 'package:provider/provider.dart';

import '../logger.dart';
import '../style/style.dart';
import '../submission_tile/submission_tile.dart';
import '../submission_tile/submission_tiles.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/reddir_api.dart';
import '../subreddit/subreddit_icon.dart';
import '../util/snackbar.dart';
import '../widget/loader.dart';
import '../widget/network_image.dart';
import '../widget/swipe_to_refresh.dart';
import 'search_subreddit.dart';

class SearchSubreddits extends StatelessWidget {
  const SearchSubreddits({
    Key? key,
    required this.query,
  }) : super(key: key);

  final String query;

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<SearchSubredditsQ>();

    return SwipeToRefresh(
      onRefresh: () => notifier
          .reloadSearch()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: Loader<List<SubredditNotifierQ>>(
        load: (_) => notifier.search(query),
        data: (_) => notifier.subreddits,
        onData: (_, subreddits) {
          return Container(
            color: Theme.of(context).primaryColor,
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final subreddit in subreddits)
                  ChangeNotifierProvider<SubredditNotifierQ>.value(
                    value: subreddit,
                    child: SearchSubreddit(),
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget _subredditIcon(context, subreddit) {
  //   return CustomNetworkImageBuilder(subreddit.communityIcon,
  //       builder: (_, image, error) {
  //     Widget _icon(ImageProvider<Object> image) {
  //       return CircleAvatar(
  //         radius: 16, // Image radius
  //         foregroundImage: image,
  //         onForegroundImageError: (e, _) => uiLogger.error('$e'),
  //       );
  //     }

  //     if (error != null) {
  //       uiLogger.error('$error');
  //       return _icon(AssetImage('communityIcon.png'));
  //     }
  //     if (image != null) {
  //       return _icon(image);
  //     }
  //     return Container();
  //   });
  // }
}
