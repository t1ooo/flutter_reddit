import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/user_profile/user_comment.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../style/style.dart';
import '../widget/loader.dart';

class UserComments extends StatelessWidget {
  const UserComments({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserNotifierQ>();
    return Padding(
      padding: pagePadding,
      child: Loader<List<CommentNotifierQ>>(
        load: (_) => notifier.loadComments(),
        data: (_) => notifier.comments,
        onData: (_, comments) {
          return ListView(
            children: [
              for (final comment in comments)
                ChangeNotifierProvider<CommentNotifierQ>.value(
                  value: comment,
                  child: UserComment(),
                ),
            ],
          );
        },
      ),
    );
  }
}
