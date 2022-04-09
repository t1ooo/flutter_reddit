import 'package:flutter/material.dart';

import '../reddit_api/submission.dart';
import '../style/style.dart';
import '../submission/submission_screen.dart';
import '../user_profile/user_profile_screen.dart';
import '../widget/sized_placeholder.dart';

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
                        // Text('r/subreddit'),
                        Text(submission.subredditNamePrefixed),
                        Row(children: [
                          Text('Post by'),
                          Text(' '),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => UserProfileScreen()),
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
            Row(children: [
              for (final icon in (submission.awardIcons).take(4))
                Image.network(icon, width: 16, height: 16),
              SizedBox(width: 5),
              if (submission.numAwards != 0)
                Text('${submission.numAwards} Awards'),
            ]),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SubmissionScreen()),
                );
              },
              child: Text(submission.title, textScaleFactor: 2),
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
                Text(submission.upvotes > 0
                    ? submission.upvotes.toString()
                    : 'Vote'),
                // Spacer(),
                Text(submission.numComments > 0
                    ? submission.numComments.toString()
                    : 'Comment'),
                // Spacer(),
                Text('Share'),
                Text('+'),
              ],
            ),
            // ),
          ],
        ),
      ),
    );
  }
}