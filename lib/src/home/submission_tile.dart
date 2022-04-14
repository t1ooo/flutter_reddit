import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/subreddit/subreddit_screen.dart';
import 'package:flutter_reddit_prototype/src/widget/awards.dart';

import '../reddit_api/submission.dart';
import '../style/style.dart';
import '../submission/submission_screen.dart';
import '../user_profile/user_profile_screen.dart';
import '../util/enum.dart';
import '../widget/sized_placeholder.dart';
import '../widget/vote_button.dart';

class SubmissionTile extends StatelessWidget {
  const SubmissionTile({
    Key? key,
    required this.submission,
    this.activeLink = true,
  }) : super(key: key);

  final Submission submission;
  final bool activeLink;

  @override
  Widget build(BuildContext context) {
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
                    SizedPlaceholder(width: 20, height: 20),
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
                          // Text(' * '),
                          // Text(submission.domain),
                        ]),
                      ],
                    ),
                  ],
                ),
                // Text('+'),
                Row(children: [
                  Text('+'),
                  SizedBox(width: 10),
                  Text('...'),
                ]),
              ],
            ),
            // Text('r/subreddit'),
            // Text('Submissioned by u/User * 3h * v.redd.it'),
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
                      );
                    }
                  : null,
              child: Text(
                '${enumNToString(submission.type)}: ${submission.title}',
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
                SubmissionVoteButton(submission:submission),
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
                Row(
                  children: [
                    Icon(Icons.share),
                    Text('Share'),
                  ],
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
}
