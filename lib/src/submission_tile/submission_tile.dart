import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_reddit_prototype/src/logging/logging.dart';
import 'package:flutter_reddit_prototype/src/subreddit/subreddit_screen.dart';
import 'package:flutter_reddit_prototype/src/widget/awards.dart';
import 'package:flutter_reddit_prototype/src/widget/loader.dart';
import 'package:provider/provider.dart';

import '../logger.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/vote.dart';
import '../style/style.dart';
import '../submission/submission_screen.dart';
import '../subreddit/subreddit_icon.dart';
import '../user_profile/user_profile_screen.dart';
import '../util/date_time.dart';

import '../util/snackbar.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/icon_text.dart';
import '../widget/network_image.dart';

class SubmissionTile extends StatelessWidget {
  const SubmissionTile({
    Key? key,
    this.activeLink = true,
  }) : super(key: key);

  final bool activeLink;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubmissionNotifierQ>();
    final submission = notifier.submission;

    return Card(
      child: Padding(
        padding: cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(context, notifier),
            SizedBox(height: 10),
            Awards(
              awardIcons: submission.awardIcons,
              totalAwardsReceived: submission.totalAwardsReceived,
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: activeLink
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SubmissionScreen(
                            id: submission.id,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Text(submission.title, textScaleFactor: 2),
            ),
            SizedBox(height: 10),
            if (submission.thumbnail != '')
              // Image.network(submission.thumbnail),
              CustomNetworkImageBuilder(submission.thumbnail),
            SizedBox(height: 10),
            Text(submission.desc),
            SizedBox(height: 10),
            footer(context, notifier),
          ],
        ),
      ),
    );
  }

  Widget header(BuildContext context, SubmissionNotifierQ notifier) {
    final submission = notifier.submission;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SizedBox.square(
        dimension: 40,
        child: Loader<String>(
          load: (_) => notifier.loadIcon(),
          data: (_) => notifier.icon,
          onData: (_, icon) => SubredditIcon(icon: icon),
          onError: (_, e) {
            uiLogger.error('$e');
            return SubredditIcon(icon: '');
          },
        ),
      ),
      title: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SubredditScreenLoader(
                name: submission.subreddit,
              ),
            ),
          );
        },
        child: Text(submission.subredditNamePrefixed),
      ),
      subtitle: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserProfileScreen(
                name: submission.author,
              ),
            ),
          );
        },
        child: Text(
          'Posted by ${submission.author} • ${formatDateTime(submission.created)}',
          softWrap: true,
          // overflow: TextOverflow.clip,
        ),
      ),
      trailing: activeLink ? _popupMenuButton(context, notifier) : null,
    );

    /* return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Wrap(
          clipBehavior: Clip.hardEdge,
          children: [
            // SizedBox(
            //   width: iconSize,
            //   height: iconSize,
            //   child: _subredditIcon(context, notifier),),
            _subredditIcon(context, notifier),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SubredditScreenLoader(
                          name: submission.subreddit,
                        ),
                      ),
                    );
                  },
                  child: Text(submission.subredditNamePrefixed),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => UserProfileScreen(
                          name: submission.author,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Posted by ${submission.author} • ${formatDateTime(submission.created)}',
                    softWrap: true,
                    // overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
          ],
        ),
        _popupMenuButton(context, notifier),
      ],
    ); */
  }

  // Widget _subredditIcon(ImageProvider<Object> image) {
  //   return CircleAvatar(
  //     radius: 50,
  //     foregroundImage: image,
  //     onForegroundImageError: (e, _) => uiLogger.error('$e'),
  //   );
  // }

  // Widget _subredditIconV2(context, String? icon, String? fallbackIcon) {
  //   if (icon != null) {
  //     return _subredditIcon(CachedNetworkImageProvider(icon,
  //         cacheManager: context.read<CacheManager>()));
  //   }
  //   if (icon != null) {
  //     _subredditIcon(AssetImage('communityIcon.png'));
  //   }
  //   return Container(decoration: BoxDecoration());
  // }

  // Widget _subredditIcon(BuildContext context, SubmissionNotifierQ notifier) {
  //   // Widget _icon(ImageProvider<Object> image) {
  //   //   return CircleAvatar(
  //   //     radius: 20,
  //   //     foregroundImage: image,
  //   //     onForegroundImageError: (e, _) => uiLogger.error('$e'),
  //   //   );
  //   // }

  //   // return LoaderBuilder<String?>(
  //   //   load: (_) => notifier.loadIcon(),
  //   //   data: (_) => notifier.icon,
  //   //   builder: (_, icon, error) {
  //   //     if (error != null) {
  //   //       // _icon(AssetImage('communityIcon.png'));
  //   //       return SubredditIcon(icon:'');
  //   //     }
  //   //     if (icon != null) {
  //   //       return SubredditIcon(icon:icon);
  //   //       // return _icon(
  //   //       //   CachedNetworkImageProvider(
  //   //       //     icon,
  //   //       //     cacheManager: context.read<CacheManager>(),
  //   //       //   ),
  //   //       // );
  //   //     }
  //   //     return Container(decoration: BoxDecoration());
  //   //   },
  //   // );

  //   return Loader<String>(
  //     load: (_) => notifier.loadIcon(),
  //     data: (_) => notifier.icon,
  //     onData: (_, icon) => SubredditIcon(icon: icon),
  //     onError: (_, e) {
  //       uiLogger.error('$e');
  //       return SubredditIcon(icon: '');
  //     },
  //   );
  // }

  Widget footer(BuildContext context, SubmissionNotifierQ notifier) {
    final submission = notifier.submission;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _voteButton(context, notifier),
        // Row(
        //   children: [
        //     Icon(Icons.comment),
        //     SizedBox(width: 5),
        //     Text(submission.numComments.toString()),
        //   ],
        // ),
        IconText(
          icon: Icon(Icons.comment),
          text: Text(submission.numComments.toString()),
        ),
        TextButton(
          onPressed: () {
            notifier.share();
          },
          // TODO: replace to TextButton.icon
          // child: Row(
          //   children: [
          //     Icon(Icons.share),
          //     SizedBox(width: 5),
          //     Text('Share'),
          //   ],
          // ),
          child: IconText(
            icon: Icon(Icons.share),
            text: Text('Share'),
          ),
        ),
        // TextButton.icon(
        //   onPressed: () {
        //     notifier.share();
        //   },
        //   icon:Icon(Icons.share),
        //   label:Text('Share'),
        // ),
        if (kDebugMode)
          TextButton(
            onPressed: () {
              showTodoSnackBar(context); // TODO
            },
            child: Icon(Icons.star_outline),
          ),
      ],
    );
  }

  CustomPopupMenuButton _popupMenuButton(
    BuildContext context,
    SubmissionNotifierQ notifier,
  ) {
    final submission = notifier.submission;

    return CustomPopupMenuButton(
      icon: Icon(Icons.more_vert),
      items: [
        CustomPopupMenuItem(
          icon: Icon(
            submission.saved ? Icons.bookmark : Icons.bookmark_border,
          ),
          label: submission.saved ? 'Unsave' : 'Save',
          onTap: () {
            return (submission.saved ? notifier.unsave() : notifier.save())
                .catchError((e) => showErrorSnackBar(context, e));
          },
        ),

        // CustomPopupMenuItem(
        //   icon: Icon(Icons.share),
        //   label: 'Share',
        //   onTap: () async {
        //     return notifier.share();
        //   },
        // ),

        if (kDebugMode)
          CustomPopupMenuItem(
            icon: Icon(Icons.visibility_off),
            label: 'Hide Post',
            onTap: () {
              showTodoSnackBar(context); // TODO
            },
          ),
        if (kDebugMode)
          CustomPopupMenuItem(
            icon: Icon(Icons.report),
            label: 'Report',
            onTap: () {
              showTodoSnackBar(context); // TODO
            },
          ),
        if (kDebugMode)
          CustomPopupMenuItem(
            icon: Icon(Icons.block),
            label: 'Block user',
            onTap: () {
              showTodoSnackBar(context); // TODO
            },
          ),
      ],
    );
  }

  Widget _voteButton(BuildContext context, SubmissionNotifierQ notifier) {
    final submission = notifier.submission;

    return Row(
      children: [
        IconButton(
          onPressed: () {
            notifier.voteUp().catchError((e) => showErrorSnackBar(context, e));
          },
          icon: Icon(
            Icons.expand_less,
            color: submission.likes == Vote.up ? Colors.green : null,
          ),
        ),
        Text(submission.score.toString()),
        IconButton(
          onPressed: () {
            notifier
                .voteDown()
                .catchError((e) => showErrorSnackBar(context, e));
          },
          icon: Icon(
            Icons.expand_more,
            color: submission.likes == Vote.down ? Colors.red : null,
          ),
        ),
      ],
    );
  }
}
