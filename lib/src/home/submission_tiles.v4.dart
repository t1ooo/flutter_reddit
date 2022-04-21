import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import '../provider.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import '../style/style.dart';
import '../util/enum.dart';
import '../widget/sized_placeholder.dart';
import '../widget/stream_list_builder.dart';
import 'custom_scroll.dart';
import 'submission_tile.dart';

class SubmissionTiles<Notifier extends SubmissionsNotifier> extends StatelessWidget {
  SubmissionTiles({
    Key? key,
    // this.type = SubType.best, // TODO: make required
    // this.showLocationSelector = true,
    // required this.submissions,
    // required this.stream,
    this.activeLink = true,
    this.showTrending = true,
    this.showTypeSelector = true,
    this.pageStorageKey,
  }) : super(key: key);

  // final SubType type;
  // final List<Submission> submissions;
  // final Function(BuildContext, SubType) stream;
  // final Function(SubType?) onTypeChanged;
  final bool activeLink;
  final bool showTrending;
  final bool showTypeSelector;
  // final bool showLocationSelector;
  PageStorageKey? pageStorageKey;

  @override
  Widget build(BuildContext context) {
    // print('build SubmissionTiles');
    final notifier = context.watch<Notifier>();
    return Padding(
      padding: pagePadding,
      child: StreamListBuilder(
        stream: notifier.submissions(),
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
    SubmissionsNotifier notifier,
    List<Submission> submissions,
  ) {
    return ListView(
      key: pageStorageKey,
      shrinkWrap: true,
      children: [
        if (showTypeSelector) ...[
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
        ],
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
        for (final submission in submissions)
          // SubmissionTile(submission: sub, activeLink: activeLink),
          MultiProvider(
            providers: [
              submissionNotifierProvider(submission),
            ],
            child:
                SubmissionTile(submission: submission, activeLink: activeLink),
          )
      ],
    );
  }

  String _formatSubType(SubType type) {
    return enumToString(type).toUpperCase();
  }
}
