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
    return Padding(
      padding: pagePadding,
      child: Loader<List<CommentNotifierQ>>(
        load: (context) => context.read<UserNotifierQ>().loadComments(),
        data: (context) => context.read<UserNotifierQ>().comments,
        onData: (context, comments) {
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
