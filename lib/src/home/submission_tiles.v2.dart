import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import '../reddit_api/reddir_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import '../style/style.dart';
import '../submission/submission_screen.dart';
import '../user_profile/user_profile_screen.dart';
import '../util/enum.dart';
import '../widget/sized_placeholder.dart';
import '../widget/stream_list_builder.dart';
import 'custom_scroll.dart';
import 'submission_tile.dart';

class SubmissionTiles extends StatelessWidget {
  SubmissionTiles({
    Key? key,
    // this.type = SubType.best, // TODO: make required
    // this.showLocationSelector = true,
    // required this.submissions,
    required this.stream,
    this.activeLink = true,
    this.showTrending = true,
    this.showTypeSelector = true,
  }) : super(key: key);

  // final SubType type;
  // final List<Submission> submissions;
  final Function(BuildContext, SubType) stream;
  // final Function(SubType?) onTypeChanged;
  final bool activeLink;
  final bool showTrending;
  final bool showTypeSelector;
  // final bool showLocationSelector;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubTypeNotifier>();
    return Padding(
      padding: pagePadding,
      child: StreamListBuilder(
        stream: stream(context, notifier.type),
        onData: (context, List<Submission> submissions) {
          return builder(
            context,
            notifier,
            submissions,
            // showLocationSelector: false,
          );
        },
      ),
    );
  }

  @override
  Widget builder(
    BuildContext context,
    SubTypeNotifier notifier,
    List<Submission> submissions,
  ) {
    return ListView(
      shrinkWrap: true,
      children: [
        if (showTypeSelector)
          Row(
            children: [
              DropdownButton<SubType>(
                value: notifier.type,
                onChanged: (type) {
                  if (type != null) notifier.type = type;
                },
                items: [
                  for (final st in SubType.values)
                    DropdownMenuItem<SubType>(
                      value: st,
                      child: Text(_formatSubType(st)),
                    )
                ],
              ),
              Spacer(),
              Text('...'),
            ],
          ),
        SizedBox(height: 50),
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
          SizedBox(height: 10),
        ],
        for (final sub in submissions)
          Padding(
            padding: scrollPadding,
            child: SubmissionTile(submission: sub, activeLink: activeLink),
          ),
      ],
    );
  }

  String _formatSubType(SubType type) {
    return enumToString(type).toUpperCase();
  }
}
