import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

import '../logging.dart';
import '../notifier/current_user_notifier.dart';
import '../notifier/subreddit_notifier.dart';
import '../notifier/user_notifier.dart';
import '../style.dart';
import '../ui_logger.dart';
import '../util/date_time.dart';
import '../widget/snackbar.dart';
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
              '${user.totalKarma} karma • ${formatDateTime(user.created)} • ${'${user.subreddit.subscribers} followers'}',
            ),
            SizedBox(height: 20),
            if (subreddit.publicDescription != '') ...[
              Text(subreddit.publicDescription),
              SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}
