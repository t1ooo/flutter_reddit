import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_reddit_prototype/src/logging.dart';
import 'package:flutter_reddit_prototype/src/widget/snackbar.dart';
import 'package:provider/provider.dart';

import '../ui_logger.dart';
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
import '../style.dart';
import '../util/date_time.dart';
import '../widget/subscribe_button.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserNotifier>();
    final subreddit = notifier.subreddit.subreddit;
    final user = notifier.user;

    return Container(
      color: primaryColor,
      child: Padding(
        padding: pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(height: 100),
                if (user.iconImg != '')
                  CircleAvatar(
                    radius: 16,
                    foregroundImage: CachedNetworkImageProvider(
                      user.iconImg,
                      cacheManager: context.read<CacheManager>(),
                    ),
                    onForegroundImageError: (e, _) => uiLogger.error('$e'),
                  ),
                SizedBox(width: 10),
                Text(subreddit.displayNamePrefixed, textScaleFactor: 2),
                Spacer(),
                if (notifier is CurrentUserNotifier) ...[
                  if (kDebugMode)
                    ElevatedButton(
                      onPressed: () {
                        showTodoSnackBar(context); // TODO
                      },
                      child: Text('EDIT'),
                    )
                ] else
                  ChangeNotifierProvider<SubredditNotifier>.value(
                    value: notifier.subreddit,
                    child: SubscribeButton(),
                  ),
              ],
            ),
            Text(
                '${user.totalKarma} karma • ${formatDateTime(user.created)} • ${'${user.subreddit.subscribers} followers'}'),
            SizedBox(height: 20),
            Text(subreddit.publicDescription),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
