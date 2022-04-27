import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../submission/comment.v2.dart';
import '../widget/loader.v2.dart';

class SavedSubmissions extends StatelessWidget {
  const SavedSubmissions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Loader<List<CommentNotifierQ>>(
      load: (context) => context.watch<UserNotifierQ>().loadSaved(),
      data: (context) => context.watch<UserNotifierQ>().savedComments,
      onData: (context, comments) {
        return ListView(
          shrinkWrap: true,
          children: [
            for (final comment in comments)
              ChangeNotifierProvider<CommentNotifierQ>.value(
                value: comment,
                child: CommentWidget(),
              ),
          ],
        );
      },
    );
  }
}
