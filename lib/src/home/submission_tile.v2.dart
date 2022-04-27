import 'package:flutter/material.dart';
// import 'package:flutter_reddit_prototype/src/notifier/reddir_notifier.dart';
import 'package:flutter_reddit_prototype/src/subreddit/subreddit_screen.dart';
import 'package:flutter_reddit_prototype/src/widget/awards.dart';
import 'package:flutter_reddit_prototype/src/widget/custom_future_builder.dart';
import 'package:flutter_reddit_prototype/src/widget/loader.v2.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/vote.dart';
import '../style/style.dart';
import '../submission/submission_screen.dart';
import '../user_profile/user_profile_screen.dart';
import '../util/date_time.dart';
import '../util/enum.dart';
import '../util/snackbar.dart';
// import '../widget/save_button.dart';
// import '../widget/vote_button.dart';

class SubmissionTile extends StatelessWidget {
  const SubmissionTile({
    Key? key,
    // required this.submission,
    this.activeLink = true,
  }) : super(key: key);

  // final Submission submission;
  final bool activeLink;

  @override
  Widget build(BuildContext context) {
    // print('build SubmissionTile');
    final notifier = context.watch<SubmissionNotifierQ>();
    final submission = notifier.submission;
    if (submission == null) {
      return Center(child: CircularProgressIndicator());
    }
    // print(submission.thumbnail.toString());
    return Card(
      child: Padding(
        padding: cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // SizedPlaceholder(width: 20, height: 20),
                    // SizedBox(
                    //   width: iconSize,
                    //   height: iconSize,
                    //   child: CustomFutureBuilder(
                    //     future: context
                    //         .read<RedditNotifier>()
                    //         .subredditIcon(submission.subreddit),
                    //     onData: (BuildContext context, String icon) {
                    //       return Image.network(icon);
                    //     },
                    //     onLoading: (_) =>
                    //         Container(decoration: BoxDecoration()),
                    //     onError: (_, __) => Container(),
                    //     // onError: voidError,
                    //   ),
                    // ),

                    SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: Loader<String>(
                        load: (context) => notifier.loadIcon(),
                        data: (context) => notifier.icon,
                        onData: (BuildContext context, String icon) {
                          return Image.network(icon);
                        },
                        onLoading: (_) =>
                            Container(decoration: BoxDecoration()),
                        onError: (_, __) => Container(),
                      ),
                    ),

                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TODO: active subreddit link
                        // Text(submission.subredditNamePrefixed),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SubredditScreenLoader(
                                      name: submission.subreddit)),
                            );
                          },
                          child: Text(submission.subredditNamePrefixed),
                        ),
                        Row(children: [
                          Text('Post by'),
                          Text(' '),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => UserProfileScreen(
                                        name: submission.author)),
                              );
                            },
                            child: Text(submission.author),
                          ),
                          Text(' • '),
                          Text(formatDateTime(submission.created)),
                        ]),
                      ],
                    ),
                  ],
                ),
                // Text('+'),
                // Row(children: [
                //   // Text('+'),
                //   SubmissionSaveButton(submission: submission),
                //   SizedBox(width: 10),
                //   Text('...'),
                // ]),
                PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (_) => [
                    _savePopupMenuItem(context, submission),
                    _sharePopupMenuItem(context, submission),
                    // _copyTextPopupMenuItem(context, comment),
                    // _collapsePopupMenuItem(context),
                    // TODO
                    PopupMenuItem(child: Text('Report')),
                    PopupMenuItem(child: Text('Block user')),
                  ],
                ),
              ],
            ),
            // Text('r/subreddit'),
            // Text('Submissioned by u/User • 3h • v.redd.it'),
            SizedBox(height: 10),
            // Row(children: [
            //   for (final icon in (submission.awardIcons).take(4))
            //     Image.network(icon, width: 16, height: 16),
            //   SizedBox(width: 5),
            //   if (submission.numAwards != 0)
            //     Text('${submission.numAwards} Awards'),
            // ]),
            Awards(
              awardIcons: submission.awardIcons,
              totalAwardsReceived: submission.totalAwardsReceived,
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: activeLink
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                SubmissionScreen(id: submission.id)), // TODO
                        // SubmissionScreenV2(submission: submission)), // TODO
                      );
                    }
                  : null,
              child: Text(
                // '${enumNToString(submission.type)}: ${submission.title}',
                submission.title,
                textScaleFactor: 2,
              ),
            ),

            SizedBox(height: 10),
            // Placeholder(),
            if (submission.thumbnail != '') Image.network(submission.thumbnail),
            SizedBox(height: 10),
            Text(submission.desc),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // runAlignment: WrapAlignment.spaceBetween,
              children: [
                // Text(submission.upvotes > 0
                //     ? submission.upvotes.toString()
                //     : 'Vote'),
                // if (submission.upvotes > 0)
                //   Row(
                //     children: [
                //       // Icon(Icons.thumb_up),
                //       Icon(Icons.expand_less),
                //       Text(submission.upvotes.toString()),
                //       Icon(Icons.expand_more),
                //     ],
                //   )
                // else
                //   Text('Vote'),
                // Row(
                //   children: [
                //     Icon(Icons.expand_less),
                //     Text(submission.upvotes.toString()),
                //     Icon(Icons.expand_more),
                //   ],
                // ),
                // SubmissionVoteButton(submission: submission),
                _voteButton(context, submission),
                // Spacer(),
                // Text(submission.numComments > 0
                //     ? submission.numComments.toString()
                //     : 'Comment'),
                // Spacer(),
                // if (submission.numComments > 0)
                Row(
                  children: [
                    Icon(Icons.comment),
                    Text(submission.numComments.toString()),
                  ],
                ),
                // else
                // Text('Comment'),
                // Row(
                //   children: [
                //     Icon(Icons.share),
                //     Text('Share'),
                //   ],
                // ),
                // ShareButton(
                //   title: submission.title,
                //   url: submission.shortLink,
                // ),
                TextButton(
                  onPressed: () {
                    context.read<SubmissionNotifierQ>().share();
                    // shareDesktop('$url', subject:'mail@example.com');
                  },
                  child: Row(
                    children: [
                      Icon(Icons.share),
                      Text('Share'),
                    ],
                  ),
                ),
                Icon(Icons.star_outline),
              ],
            ),
            // ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem _savePopupMenuItem(
      BuildContext context, Submission submission) {
    return PopupMenuItem(
      onTap: () {
        final notifier = context.read<SubmissionNotifierQ>();
        // final submission = notifier.submission;

        // final result = await (submission.saved
        //     ? notifier.unsave()
        //     : notifier.save());
        // if (result != null) {
        //   showSnackBar(context, result);
        // }

        (submission.saved ? notifier.unsave() : notifier.save())
            .catchError((e) => showErrorSnackBar(context, e));
      },
      child: Builder(
        builder: (_) {
          final notifier = context.read<SubmissionNotifierQ>();

          return ListTile(
            contentPadding: EdgeInsets.zero,
            minLeadingWidth: 0,
            leading: Icon(
              submission.saved ? Icons.bookmark : Icons.bookmark_border,
            ),
            title: Text(submission.saved ? 'Unsave' : 'Save'),
          );
        },
      ),
    );
  }

  PopupMenuItem _sharePopupMenuItem(
      BuildContext context, Submission submission) {
    return PopupMenuItem(
      onTap: () async {
        // Share.share('${comment.linkTitle} ${comment.shortLink}');
        context.read<SubmissionNotifierQ>().share();
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 0,
        leading: Icon(Icons.share),
        title: Text('Share'),
      ),
    );
  }

  Widget _voteButton(BuildContext context, Submission submission) {
    final notifier = context.read<SubmissionNotifierQ>();
    return Row(
      children: [
        IconButton(
          onPressed: () {
            // final result = await notifier.voteUp();
            // if (result != null) {
            //   showSnackBar(context, result);
            // }
            notifier.voteUp().catchError((e) => showErrorSnackBar(context, e));
          },
          icon: Icon(
            Icons.expand_less,
            color: submission.likes == Vote.up ? Colors.green : null,
          ),
        ),
        Text(submission.score.toString()),
        IconButton(
          onPressed: () {
            // final result = await notifier.voteDown();

            // if (result != null) {
            //   showSnackBar(context, result);
            // }

            notifier
                .voteDown()
                .catchError((e) => showErrorSnackBar(context, e));
          },
          icon: Icon(
            Icons.expand_more,
            color: submission.likes == Vote.down ? Colors.red : null,
          ),
        ),
      ],
    );
  }
}

// TODO: move to separate file
/* class SubmissionVoteButton extends StatelessWidget {
  const SubmissionVoteButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubmissionNotifier>();
    final submission = notifier.submission;

    return Row(
      children: [
        IconButton(
          onPressed: () async {
            final result = await notifier.upVote();
            if (result != null) {
              showSnackBar(context, result);
            }
          },
          icon: Icon(
            Icons.expand_less,
            color: submission.likes == Vote.up ? Colors.green : null,
          ),
        ),
        Text(submission.score.toString()),
        IconButton(
          onPressed: () async {
            final result = await notifier.downVote();

            if (result != null) {
              showSnackBar(context, result);
            }
          },
          icon: Icon(
            Icons.expand_more,
            color: submission.likes == Vote.down ? Colors.red : null,
          ),
        ),
      ],
    );
  }
} */
