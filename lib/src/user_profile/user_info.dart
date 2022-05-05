import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_reddit_prototype/src/logging/logging.dart';
import 'package:flutter_reddit_prototype/src/util/snackbar.dart';
import 'package:provider/provider.dart';

import '../logger.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../style/style.dart';
import '../util/date_time.dart';
import '../widget/network_image.dart';
import '../widget/subscribe_button.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<UserNotifierQ>();
    final subreddit = notifier.subreddit.subreddit;
    final user = notifier.user;

    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(height: 100),
                if (user.iconImg != '')
                  CircleAvatar(
                    radius: 16, // Image radius
                    foregroundImage: CachedNetworkImageProvider(
                      user.iconImg,
                      cacheManager: context.read<CacheManager>(),
                    ),
                    onForegroundImageError: (e, _) => uiLogger.error('$e'),
                  ),
                // CachedNetworkImage(
                //   imageUrl: subreddit.communityIcon,
                //   fit: BoxFit.fitHeight,
                //   errorWidget: (_, __, error) {
                //     print(error);
                //     return Container();
                //   },
                //   imageBuilder: (context, imageProvider) => CircleAvatar(
                //     radius: 16, // Image radius
                //     backgroundImage: imageProvider,
                //   ),
                // ),
                SizedBox(width: 10),
                Text(subreddit.displayNamePrefixed, textScaleFactor: 2),
                Spacer(),
                // ElevatedButton(onPressed: () {}, child: Icon(Icons.doorbell)),
                // SizedBox(width: 10),
                if (notifier.isCurrentUser)
                  if (kDebugMode)
                    ElevatedButton(
                        onPressed: () {
                          showTodoSnackBar(context); // TODO
                        },
                        child: Text('EDIT'))
                  else
                    ChangeNotifierProvider<SubredditNotifierQ>.value(
                      value: notifier.subreddit,
                      child: SubscribeButton(),
                    ),
              ],
            ),
            // SizedBox(height: 10),
            Text(
                '${user.totalKarma} karma • ${formatDateTime(user.created)} • ${'${user.subreddit.subscribers} followers'}'),
            SizedBox(height: 20),
            Text(subreddit.publicDescription),
            SizedBox(height: 50),
          ],
        ),
      ),
    );

    // return Container(
    //   color: Theme.of(context).primaryColor,
    //   padding: pagePadding,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       SizedBox(height: topPadding),
    //       Row(
    //         children: [
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               SizedBox(
    //                 width: iconSize,
    //                 height: iconSize,
    //                 // child: Image.network(user.iconImg),
    //                 child: CustomNetworkImageBuilder(user.iconImg),
    //               ),
    //             ],
    //           ),
    //           SizedBox(width: 10),
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(user.name, textScaleFactor: 2),
    //               Text(user.subreddit.displayNamePrefixed),
    //             ],
    //           ),
    //         ],
    //       ),
    //       SizedBox(height: 20),
    //       if (notifier.isCurrentUser)
    //         ElevatedButton(onPressed: () {}, child: Text('EDIT'))
    //       else
    //         Row(
    //           // alignment: MainAxisAlignment.start,
    //           children: [
    //             ElevatedButton(onPressed: () {}, child: Text('CHAT')),
    //             SizedBox(width: 10),
    //             ChangeNotifierProvider<SubredditNotifierQ>.value(
    //               value: notifier.subreddit,
    //               child: SubscribeButton(isUserPage: true),
    //             ),
    //           ],
    //         ),
    //       SizedBox(height: 20),
    //       Text(
    //           '${user.totalKarma} karma • ${formatDateTime(user.created)} • ${'${user.subreddit.subscribers} followers'}'),
    //       SizedBox(height: 10),
    //       Text(user.subreddit.publicDescription),
    //       SizedBox(height: 20),
    //     ],
    //   ),
    // );
  }
}
