import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import '../widget/sized_placeholder.dart';
import 'custom_scroll.dart';
import 'submission_tile.v2.dart';

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
  final List<SubmissionNotifierQ> submissions;
  final Function(SubType?) onTypeChanged;
  final bool activeLink;
  final bool showTrending;
  final bool showTypeSelector;
  // final bool showLocationSelector;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          children: [
            if (showTypeSelector)
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
          SizedBox(height: 10),
        ],
        for (final sub in submissions)
          ChangeNotifierProvider<SubmissionNotifierQ>.value(
            value: sub,
            child: SubmissionTile(activeLink: activeLink),
          ),
      ],
    );
  }
}


class SearchSubmissionTiles extends StatelessWidget {
  SearchSubmissionTiles({
    Key? key,
    this.sort = Sort.relevance, // TODO: make required
    required this.submissions,
    required this.onTypeChanged,
    this.activeLink = true,
    this.showTrending = true,
    this.showTypeSelector = true,
    // this.showLocationSelector = true,
  }) : super(key: key);

  final Sort sort;
  final List<SubmissionNotifierQ> submissions;
  final Function(Sort?) onTypeChanged;
  final bool activeLink;
  final bool showTrending;
  final bool showTypeSelector;
  // final bool showLocationSelector;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          children: [
            if (showTypeSelector)
              DropdownButton<Sort>(
                value: sort,
                onChanged: onTypeChanged,
                items: Sort.values
                    .map<DropdownMenuItem<Sort>>((Sort sort) {
                  return DropdownMenuItem<Sort>(
                    value: sort,
                    child: Text(sort.toString()),
                  );
                }).toList(),
              ),
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
          SizedBox(height: 10),
        ],
        for (final sub in submissions)
          ChangeNotifierProvider<SubmissionNotifierQ>.value(
            value: sub,
            child: SubmissionTile(activeLink: activeLink),
          ),
      ],
    );
  }
}
