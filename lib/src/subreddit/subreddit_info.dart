import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_reddit_prototype/src/logging/logging.dart';
import 'package:provider/provider.dart';

import '../logger.dart';
import '../submission_tile/submission_tiles.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/submission_type.dart';
import '../search/search_field.dart';
import '../style/style.dart';
import '../widget/network_image.dart';
import '../widget/subscribe_button.dart';
import 'subreddit_icon.dart';
// import '../widget/subscribe_button.dart';

class SubredditInfo extends StatelessWidget {
  const SubredditInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifierQ>();
    final subreddit = notifier.subreddit;

    // return (
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
                // if (subreddit.communityIcon != '')
                // CircleAvatar(
                //   radius: 16, // Image radius
                //   foregroundImage: CachedNetworkImageProvider(
                //     subreddit.communityIcon,
                //     cacheManager: context.read<CacheManager>(),
                //   ),
                //   // backgroundImage:  AssetImage('communityIcon.png'),
                //   onForegroundImageError: (e, _) => uiLogger.error('$e'),
                //   // onBackgroundImageError: (e, _) => uiLogger.error('$e'),
                // ),

                SubredditIcon(icon: subreddit.communityIcon),

                // else
                //   CircleAvatar(
                //     radius: 16, // Image radius
                //     foregroundImage: AssetImage('communityIcon.png'),
                //     onForegroundImageError: (e, _) => uiLogger.error('$e'),
                //   ),
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
                SubscribeButton(),
              ],
            ),
            // SizedBox(height: 10),
            Text('${subreddit.subscribers} members'),
            SizedBox(height: 20),
            Text(subreddit.publicDescription),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // Widget _subredditIcon(context, subreddit) {
  //   return CustomNetworkImageBuilder(subreddit.communityIcon,
  //       builder: (_, image, error) {
  //     Widget _icon(ImageProvider<Object> image) {
  //       return CircleAvatar(
  //         radius: 16, // Image radius
  //         foregroundImage: image,
  //         onForegroundImageError: (e, _) => uiLogger.error('$e'),
  //       );
  //     }

  //     if (error != null) {
  //       return _icon(AssetImage('communityIcon.png'));
  //     }
  //     if (image != null) {
  //       return _icon(image);
  //     }
  //     return Container();
  //   });
  // }
}
