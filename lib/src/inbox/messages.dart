import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/widget/swipe_to_refresh.dart';
import 'package:provider/provider.dart';

import '../notifier/auth_notifier.dart';
import '../notifier/collapse_mixin.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/current_user_notifier.dart';
import '../notifier/home_front_notifier.dart';
import '../notifier/home_popular_notifier.dart';
import '../notifier/iterable_sum.dart';
import '../notifier/likable_mixin.dart';
import '../notifier/limit.dart';
import '../notifier/list_notifier.dart';
import '../notifier/message_notifier.dart';
import '../notifier/property_listener.dart';
import '../notifier/replyable.dart';
import '../notifier/reportable.dart';
import '../notifier/rule_notifier.dart';
import '../notifier/savable_mixin.dart';
import '../notifier/score.dart';
import '../notifier/search_notifier.dart';
import '../notifier/search_subreddits.dart';
import '../notifier/submission_loader_notifier.dart';
import '../notifier/submission_notifier.dart';
import '../notifier/submissions_notifier.dart';
import '../notifier/subreddit_loader_notifier.dart';
import '../notifier/subreddit_notifier.dart';
import '../notifier/try_mixin.dart';
import '../notifier/user_loader_notifier.dart';
import '../notifier/user_notifier.dart';
import '../util/date_time.dart';
import '../widget/snackbar.dart';
import '../widget/loader.dart';
import 'message_screen.dart';

class Messages extends StatelessWidget {
  Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<AuthNotifier>().user!;

    return SwipeToRefresh(
      onRefresh: () => notifier
          .reloadInboxMessages()
          .catchError((e) => showErrorSnackBar(context, e)),
      child: Loader<List<MessageNotifier>>(
        load: (_) => notifier.loadInboxMessages(),
        data: (_) => notifier.inboxMessages,
        onData: (_, messages) {
          return ListView(
            shrinkWrap: true,
            children: [
              for (final message in messages) ...[
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ChangeNotifierProvider<MessageNotifier>.value(
                          value: message,
                          child: MessageScreen(),
                        ),
                      ),
                    );
                  },
                  leading: Icon(Icons.mail),
                  title: Text(message.message.subject),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.message.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            'u/${message.message.author}',
                            style: TextStyle(color: Colors.red),
                          ),
                          Text(' • '),
                          Text(formatDateTime(message.message.created)),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(height: 0),
              ],
            ],
          );
        },
      ),
    );
  }
}
