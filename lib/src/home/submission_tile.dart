import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/subreddit/subreddit_screen.dart';
import 'package:flutter_reddit_prototype/src/widget/awards.dart';
import 'package:flutter_reddit_prototype/src/widget/loader.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/vote.dart';
import '../style/style.dart';
import '../submission/submission_screen.dart';
import '../user_profile/user_profile_screen.dart';
import '../util/date_time.dart';
import '../util/login.dart';
import '../util/snackbar.dart';
import '../widget/network_image.dart';

class SubmissionTile extends StatelessWidget {
  const SubmissionTile({
    Key? key,
    this.activeLink = true,
  }) : super(key: key);

  final bool activeLink;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubmissionNotifierQ>();
    final submission = notifier.submission;
    if (submission == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Card(
      child: Padding(
        padding: cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: Loader<String>(
                        load: (context) => notifier.loadIcon(),
                        data: (context) => notifier.icon,
                        onData: (BuildContext context, String icon) {
                          // return Image.network(icon);
                          return NetworkImageBuilder(icon);
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
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SubredditScreenLoader(
                                  name: submission.subreddit,
                                ),
                              ),
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
                                    name: submission.author,
                                  ),
                                ),
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
                PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (_) => [
                    _savePopupMenuItem(context, submission),
                    _sharePopupMenuItem(context, submission),
                    // TODO
                    PopupMenuItem(child: Text('Report')),
                    PopupMenuItem(child: Text('Block user')),
                  ],
                ),
              ],
            ),

            SizedBox(height: 10),

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
                          builder: (_) => SubmissionScreen(
                            id: submission.id,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Text(submission.title, textScaleFactor: 2),
            ),

            SizedBox(height: 10),

            if (submission.thumbnail != '')
              // Image.network(submission.thumbnail),
              NetworkImageBuilder(submission.thumbnail),
            SizedBox(height: 10),
            Text(submission.desc),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _voteButton(context, submission),
                Row(
                  children: [
                    Icon(Icons.comment),
                    Text(submission.numComments.toString()),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    notifier.share();
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
      onTap: () async {
        await loggedInGuard(context);

        final notifier = context.read<SubmissionNotifierQ>();

        (submission.saved ? notifier.unsave() : notifier.save())
            .catchError((e) => showErrorSnackBar(context, e));
      },
      child: Builder(
        builder: (_) {
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
          onPressed: () async {
            await loggedInGuard(context);
            notifier.voteUp().catchError((e) => showErrorSnackBar(context, e));
          },
          icon: Icon(
            Icons.expand_less,
            color: submission.likes == Vote.up ? Colors.green : null,
          ),
        ),
        Text(submission.score.toString()),
        IconButton(
          onPressed: () async {
            await loggedInGuard(context);
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
