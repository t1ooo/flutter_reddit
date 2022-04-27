import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/submission_tiles.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/submission_type.dart';
import '../search/search_field.dart';
import '../style/style.dart';
import '../widget/subscribe_button.dart';
// import '../widget/subscribe_button.dart';

class SubredditWidget extends StatelessWidget {
  const SubredditWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifierQ>();
    final subreddit = notifier.subreddit;
    return ListView(
      children: [
        SearchField(
          src: subreddit.bannerBackgroundImage,
          subreddit: subreddit.displayNamePrefixed,
        ),
        Padding(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(height: 100),
                  if (subreddit.communityIcon != '')
                    CircleAvatar(
                      radius: 16, // Image radius
                      backgroundImage: NetworkImage(subreddit.communityIcon),
                    ),
                  SizedBox(width: 10),
                  Text(subreddit.displayNamePrefixed, textScaleFactor: 2),
                  Spacer(),
                  ElevatedButton(onPressed: () {}, child: Icon(Icons.doorbell)),
                  SizedBox(width: 10),
                  SubscribeButton(),
                ],
              ),
              SizedBox(height: 20),
              Text('${subreddit.subscribers} members'),
              SizedBox(height: 20),
              Text(subreddit.publicDescription),
            ],
          ),
        ),
        Divider(),
        GSubmissionTiles<SubType>(
          type: notifier.subType,
          types: SubType.values,
          submissions: notifier.submissions,
          onTypeChanged: notifier.loadSubmissions,
        ),
      ],
    );
  }
}
