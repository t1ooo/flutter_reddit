import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/submission_tiles.v2.dart';
import '../notifier/reddir_notifier.dart';
import '../provider.dart';
import '../reddit_api/reddir_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/subreddit.dart';
import '../search/search_field.dart';
import '../style/style.dart';
import '../widget/future_elevated_button.dart';
import '../widget/sized_placeholder.dart';
import '../widget/stream_list_builder.dart';

class SubredditWidget extends StatelessWidget {
  const SubredditWidget({
    Key? key,
    required this.subreddit,
  }) : super(key: key);

  final Subreddit subreddit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // if (subreddit.headerImg != '')
        //   Image.network(subreddit.headerImg),
        // if (subreddit.communityIcon != '')
        //   Image.network(subreddit.communityIcon),
        // if (subreddit.bannerBackgroundImage != '')
        //   Image.network(subreddit.bannerBackgroundImage),
        if (subreddit.bannerBackgroundImage != '')
          SearchFieldImage(src: subreddit.bannerBackgroundImage)
        else
          Padding(
            padding: pagePadding,
            child: SearchField(),
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
                  // if (subreddit.userIsSubscriber)
                  //   ElevatedButton(onPressed: () {}, child: Text('+JOIN'))
                  // else
                  //   ElevatedButton(onPressed: () {}, child: Text('LEAVE'))

                  Builder(builder: (c) {
                    final sn = c.watch<SubscriptionNotifier>();
                    final error = sn.error;
                    if (error != null) {
                      // TODO: handle error
                    }
                    if (sn.isSubscriber)
                      return FutureElevatedButton(
                        onPressed: () => sn.unsubscribe(subreddit.name),
                        child: Text('LEAVE'),
                      );
                    else
                      return FutureElevatedButton(
                        onPressed: () => sn.subscribe(subreddit.name),
                        child: Text('+JOIN'),
                      );
                  }),

                  // ValueListenableBuilder(),
                  // ChangeNotifierProvider(
                  //   create: (BuildContext context) => SubscriptionNotifier(
                  //     context.read<RedditApi>(),
                  //     subreddit.userIsSubscriber,
                  //   ),
                  //   child: Builder(builder: (_) {
                  //     if (subreddit.userIsSubscriber)
                  //       return ElevatedButton(
                  //           onPressed: () {}, child: Text('+JOIN'));
                  //     else
                  //       return ElevatedButton(
                  //           onPressed: () {}, child: Text('LEAVE'));
                  //   }),
                  // ),
                ],
              ),
              SizedBox(height: 20),
              Text('${subreddit.subscribers} members'),
              SizedBox(height: 20),
              Text(subreddit.publicDescription),

              /* Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedPlaceholder(
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('UserName', textScaleFactor: 2),
                      Text('u/username'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                // alignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(onPressed: () {}, child: Text('CHAT')),
                  SizedBox(width: 10),
                  ElevatedButton(onPressed: () {}, child: Text('FOLLOW')),
                ],
              ),
              SizedBox(height: 20),
              Text('5674 karma * 1y'),
              SizedBox(height: 10),
              Text('description'),
              SizedBox(height: 20), */
            ],
          ),
        ),
        Divider(),

        // Padding(
        //   padding: pagePadding,
        //   child: StreamListBuilder(
        //     stream: context
        //         .read<RedditNotifier>()
        //         .subredditSubmissions(subreddit.displayName),
        //     onData: (context, List<Submission> submissions) {
        //       return SubmissionTiles(
        //         onTypeChanged: (type) {
        //           // TODO
        //         },
        //         submissions: submissions,
        //         // showLocationSelector: false,
        //       );
        //     },
        //   ),
        // ),

        SubmissionTiles(
          stream: (context, type) =>
              context.read<RedditNotifier>().front(type: type),
        ),
      ],
    );
  }
}
