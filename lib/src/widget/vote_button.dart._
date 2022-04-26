import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/util/snackbar.dart';
import 'package:provider/provider.dart';

import '../home/submission_tiles.v2.dart';
import '../notifier/reddir_notifier.dart';
import '../provider.dart';
import '../reddit_api/comment.dart';
import '../reddit_api/reddir_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/subreddit.dart';
import '../reddit_api/vote.dart';
import '../search/search_field.dart';
import '../style/style.dart';
import '../widget/future_elevated_button.dart';
import '../widget/sized_placeholder.dart';
import '../widget/stream_list_builder.dart';

class SubmissionVoteButton extends StatelessWidget {
  const SubmissionVoteButton({
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
          return Row(
            children: [
              IconButton(
                onPressed: () async {
                  final result = await (notifier.vote == Vote.up
                      ? notifier.clearVote(submission.id)
                      : notifier.upVote(submission.id));
                  if (result != null) {
                    showSnackBar(context, result);
                  }
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
                  final result = await (notifier.vote == Vote.down
                      ? notifier.clearVote(submission.id)
                      : notifier.downVote(submission.id));
                  if (result != null) {
                    showSnackBar(context, result);
                  }
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

/* class CommentVoteButton extends StatelessWidget {
  const CommentVoteButton({
    Key? key,
    // required this.comment,
    // required this.isVoter,
    // this.isUserPage = false,
  }) : super(key: key);

  // final Comment comment;
  // final bool isVoter;
  // final bool isUserPage;

  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [commentVoteNotifierProvider(comment)],
    //   child: Builder(
    //     builder: builder,
    //   ),
    // );
    return builder(context);
  }

  Widget builder(BuildContext context) {
    final notifier = context.watch<CommentNotifier>();

    return Row(
      children: [
        IconButton(
          onPressed: () async {
            final result = await (notifier.comment.likes == Vote.up
                ? notifier.clearVote()
                : notifier.upVote());
            if (result != null) {
              showSnackBar(context, result);
            }
          },
          icon: Icon(
            Icons.expand_less,
            color: notifier.comment.likes == Vote.up ? Colors.green : null,
          ),
        ),
        Text(notifier.comment.score.toString()),
        IconButton(
          onPressed: () async {
            final result = await (notifier.comment.likes == Vote.down
                ? notifier.clearVote()
                : notifier.downVote());
            if (result != null) {
              showSnackBar(context, result);
            }
          },
          icon: Icon(
            Icons.expand_more,
            color: notifier.comment.likes == Vote.down ? Colors.red : null,
          ),
        ),
      ],
    );
  }
} */
