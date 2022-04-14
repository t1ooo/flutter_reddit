import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/submission_tiles.v2.dart';
import '../notifier/reddir_notifier.dart';
import '../provider.dart';
import '../reddit_api/reddir_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/subreddit.dart';
import '../reddit_api/vote.dart';
import '../search/search_field.dart';
import '../style/style.dart';
import '../widget/future_elevated_button.dart';
import '../widget/sized_placeholder.dart';
import '../widget/stream_list_builder.dart';

class VoteButton extends StatelessWidget {
  const VoteButton({
    Key? key,
    required this.submission,
    // required this.isVoter,
    // this.isUserPage = false,
  }) : super(key: key);

  final Submission submission;
  // final bool isVoter;
  // final bool isUserPage;

  @override
  Widget build(BuildContext context) {
/*     return Row(
      children: [
        Icon(
          Icons.expand_less,
          color: submission.likes == Vote.up ? Colors.green : null,
        ),
        Text(submission.upvotes.toString()),
        Icon(
          Icons.expand_more,
          color: submission.likes == Vote.up ? Colors.red : null,
        ),
      ],
    ); */

    return MultiProvider(
      providers: [submissionVoteNotifierProvider(submission)],
      child: Builder(
        builder: (c) {
          final notifier = c.watch<SubmissionVoteNotifier>();
          final error = notifier.error;
          if (error != null) {
            // TODO: handle error
          }
          return Row(
            children: [
              IconButton(
                onPressed: () async {
                  notifier.vote == Vote.up
                      ? notifier.clearVote(submission.id)
                      : notifier.upVote(submission.id);
                },
                icon: Icon(
                  Icons.expand_less,
                  color: notifier.vote == Vote.up ? Colors.green : null,
                ),
              ),

              // FutureElevatedButton(
              //   onPressed: () async {},
              //   child: Icon(
              //     Icons.expand_less,
              //     color: submission.likes == Vote.up ? Colors.green : null,
              //   ),
              // ),
              // FutureGestureDetector(
              //   onTap: () => Future.delayed(Duration(seconds: 2)),
              //   child: IconButton(
              //     onPressed: () {},
              //     icon: Icon(
              //       Icons.expand_less,
              //       color: submission.likes == Vote.up ? Colors.green : null,
              //     ),
              //   ),
              // ),
              // Icon(
              //   Icons.expand_more,
              //   color: submission.likes == Vote.up ? Colors.red : null,
              // ),

              Text(notifier.score.toString()),
              IconButton(
                onPressed: () async {
                  notifier.vote == Vote.down
                      ? notifier.clearVote(submission.id)
                      : notifier.downVote(submission.id);
                },
                icon: Icon(
                  Icons.expand_more,
                  color: notifier.vote == Vote.down ? Colors.red : null,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
