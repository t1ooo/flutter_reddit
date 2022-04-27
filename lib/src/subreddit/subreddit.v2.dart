import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/submission_tiles.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/submission_type.dart';
import '../reddit_api/subreddit.dart';
import '../search/search_field.dart';
import '../style/style.dart';
import '../submission/submission.v2.dart';
import '../widget/subscribe_button.dart';
// import '../widget/subscribe_button.dart';

class SubredditWidget extends StatelessWidget {
  const SubredditWidget({
    Key? key,
    // required this.subreddit,
  }) : super(key: key);

  // final Subreddit subreddit;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifierQ>();
    final subreddit = notifier.subreddit;
    return ListView(
      children: [
        // SizedBox(height: topPadding),
        // if (subreddit.headerImg != '')
        //   Image.network(subreddit.headerImg),
        // if (subreddit.communityIcon != '')
        //   Image.network(subreddit.communityIcon),
        // if (subreddit.bannerBackgroundImage != '')
        //   Image.network(subreddit.bannerBackgroundImage),
        // if (subreddit.bannerBackgroundImage != '')
        //   SearchField(
        //     src: subreddit.bannerBackgroundImage,
        //     subreddit: subreddit.displayNamePrefixed,
        //   )
        // else
        //   Padding(
        //     padding: pagePadding,
        //     child: SearchField(),
        //   ),
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
                  // if (subreddit.userIsSubscriber)
                  //   ElevatedButton(onPressed: () {}, child: Text('+JOIN'))
                  // else
                  //   ElevatedButton(onPressed: () {}, child: Text('LEAVE'))

                  // Builder(builder: (c) {
                  //   final sn = c.watch<SubscriptionNotifier>();
                  //   final error = sn.error;
                  //   if (error != null) {
                  //     // TODO: handle error
                  //   }
                  //   if (sn.isSubscriber)
                  //     return FutureElevatedButton(
                  //       onPressed: () => sn.unsubscribe(subreddit.name),
                  //       child: Text('LEAVE'),
                  //     );
                  //   else
                  //     return FutureElevatedButton(
                  //       onPressed: () => sn.subscribe(subreddit.name),
                  //       child: Text('+JOIN'),
                  //     );
                  // }),
                  // SubscribeButton(subreddit: subreddit),
                  SubscribeButton(),

                  // TODO: subscribe

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
              Text('5674 karma • 1y'),
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

        // SubmissionTiles(
        //   stream: (context, type) => context
        //       .read<RedditNotifier>()
        //       .subredditSubmissions(subreddit.displayName, type: type),
        // ),

        // Builder(builder: (context) {
        //   final notifier = context.watch<SubredditNotifierQ>();
        //   WidgetsBinding.instance?.addPostFrameCallback((_) {
        //     context.read<SubredditNotifierQ>().loadSubmissions();
        //     // final result = context.read<SubmissionNotifierQ>().loadSubmission(id);
        //     // if (result is Reload) {

        //     // }
        //     // if (result is Error) {
        //     //   showSnackBar(context, result.toString());
        //     // }
        //   });
        //   // return SubmissionWidget();
        // }),

        // Builder(builder: (context) {
        //   final notifier = context.watch<SubredditNotifierQ>();
        //   final submissions = notifier.submissions;
        //   return SubmissionTiles(
        //       type: notifier.subType,
        //       submissions: submissions,
        //       onTypeChanged: (subType) {
        //         print(subType);
        //         notifier.loadSubmissions(subType);
        //       });
        // }),

        Builder(
          builder: (context) {
            final notifier = context.watch<SubredditNotifierQ>();
            return GSubmissionTiles<SubType>(
              type: notifier.subType,
              types: SubType.values,
              submissions: notifier.submissions,
              onTypeChanged: notifier.loadSubmissions,
            );
          },
        ),
      ],
    );
  }
}
