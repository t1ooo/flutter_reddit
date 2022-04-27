import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/submission_tile.v2.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import 'comment.v2.dart';

class SubmissionWidget extends StatelessWidget {
  SubmissionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubmissionNotifierQ>();
    return /* Stack(
      children: [ */
        ListView(
      children: [
        SubmissionTile(
          activeLink: false,
        ),
        ListView(
          shrinkWrap: true,
          children: [
            for (final comment in notifier.comments ?? [])
              ChangeNotifierProvider<CommentNotifierQ>.value(
                value: comment,
                child: CommentWidget(),
              ),
          ],
        ),
        SizedBox(height: 100),
      ],
    );
  }
}
