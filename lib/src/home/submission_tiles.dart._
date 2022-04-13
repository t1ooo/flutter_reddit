import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import '../reddit_api/reddir_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import '../style/style.dart';
import '../submission/submission_screen.dart';
import '../user_profile/user_profile_screen.dart';
import '../widget/sized_placeholder.dart';
import 'custom_scroll.dart';
import 'submission_tile.dart';

class SubmissionTiles extends StatelessWidget {
  SubmissionTiles({
    Key? key,
    this.type = SubType.best, // TODO: make required
    required this.submissions,
    required this.onTypeChanged,
    this.activeLink = true,
    this.showTrending = true,
    this.showTypeSelector = true,
    // this.showLocationSelector = true,
  }) : super(key: key);

  final SubType type;
  final List<Submission> submissions;
  final Function(SubType?) onTypeChanged;
  final bool activeLink;
  final bool showTrending;
  final bool showTypeSelector;
  // final bool showLocationSelector;

  @override
  Widget build(BuildContext context) {
    // return Column(
    // final notifier = context.read<RedditNotifier>();
    return ListView(
      // controller: ScrollController(),
      shrinkWrap: true,
      // physics: ClampingScrollPhysics(),
      children: [
        // if (showTypeSelector) ...[
        Row(
          children: [
            // DropdownButton(
            //   value: 'HOT POSTS',
            //   items: [
            //     DropdownMenuItem(
            //       onTap: () {},
            //       value: 'HOT POSTS',
            //       child: Text('HOT POSTS'),
            //     ),
            //   ],
            //   onChanged: (_) {},
            // ),
            // Text('HOT POSTS'),
            if (showTypeSelector)
              // TextButton(
              //   child: Text('HOT POSTS'),
              //   onPressed: () {},
              // ),
              DropdownButton<SubType>(
                value: type,
                onChanged: onTypeChanged,
                items: SubType.values
                    .map<DropdownMenuItem<SubType>>((SubType type) {
                  return DropdownMenuItem<SubType>(
                    value: type,
                    child: Text(type.toString()),
                  );
                }).toList(),
              ),
            // if (showLocationSelector)
            //   TextButton(
            //     child: Text('GLOBAL'),
            //     onPressed: () {},
            //   ),
            Spacer(),
            Text('...'),
          ],
        ),
        SizedBox(height: 50),
        // ],
        if (showTrending) ...[
          Text('Trending today'),

          SizedBox(
            height: 200,
            child: CustomScroll(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  for (int i = 0; i < 10; i++)
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: SizedPlaceholder(width: 200, height: 200 * 3 / 4),
                    ),
                ],
              ),
            ),
          ),

          // SubmissionTile(),
          // SubmissionTile(),
          // SubmissionTile(),
          SizedBox(height: 10),
        ],
        // SubmissionTiles(),
        // for (int i = 0; i < 3; i++)
        // for(final sub in notifier.front!)
        for (final sub in submissions)
          SubmissionTile(submission: sub, activeLink: activeLink)
      ],
    );
  }
}
