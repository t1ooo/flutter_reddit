import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import '../reddit_api/comment.dart';
import '../search/search_field.dart';
import '../user_profile/user_comment.dart';
import '../widget/sized_placeholder.dart';
import '../widget/stream_list_builder.dart';

class SavedComments extends StatelessWidget {
  const SavedComments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pagePadding,
      child: StreamListBuilder(
        stream: context.read<CurrentUserNotifier>().savedComments(),
        onData: (context, List<Comment> comments) {
          return ListView(
            children: [
              // for (final comment in comments) UserComment(comment: comment),
            ],
          );
        },
      ),
    );
  }
}
