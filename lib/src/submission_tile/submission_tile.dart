import 'dart:developer';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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
    // this.showSubreddit = true,
  }) : super(key: key);

  final bool activeLink;
  // final bool showSubreddit;

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
            // SizedBox(height: 10),
            Awards(
              awardIcons: submission.awardIcons,
              totalAwardsReceived: submission.totalAwardsReceived,
            ),
            SizedBox(height: 15),
            InkWell(
              onTap: activeLink
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ChangeNotifierProvider<SubmissionNotifierQ>.value(
                            value: notifier,
                            child: SubmissionScreen(
                              id: submission.id,
                            ),
                          ),
                        ),
                      );
                    }
                  : null,
              child: Text(submission.title, textScaleFactor: 1.8),
            ),
            SizedBox(height: 10),
            // if (submission.thumbnail != '')
            // CustomNetworkImageBuilder(submission.thumbnail),
            Builder(builder: (_) {
              final screenWidth = MediaQuery.of(context).size.width;
              final previewImage =
                  // notifier.previewImage(screenWidth / 4, screenWidth);
                  notifier.previewImage(200, screenWidth);
              // print(image);
              final maxScale = 5;
              return previewImage != null
                  // ? CustomNetworkImageBuilder(image)
                  ? Center(
                      child: CustomNetworkImage(
                        previewImage.url,
                        onData: (_, image) {
                          return Image(
                            image: image,
                            // width: screenWidth,
                            // width: previewImage.width <= screenWidth / maxScale
                            //     ? previewImage.width
                            //     : screenWidth,
                            width:
                                min(previewImage.width * maxScale, screenWidth),
                            // height: previewImage.height,
                            fit: BoxFit.fitWidth,
                            errorBuilder: imageErrorBuilder,
                          );
                        },
                      ),
                    )
                  : Container();
            }),
            SizedBox(height: 10),
            // Text(submission.desc),
            Text(
              submission.selftext,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10),
            footer(context, notifier),
          ],
        ),
      ),
    );
  }

  Widget previewImage(BuildContext context, SubmissionNotifierQ notifier) {
    final minWidth = 200.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final previewImage = notifier.previewImage(minWidth, screenWidth);
    if (previewImage == null) {
      return Container();
    }

    final maxScale = 5;
    final width = min(previewImage.width * maxScale, screenWidth);
    return Center(
      child: CustomNetworkImage(
        previewImage.url,
        onData: (_, image) {
          return Image(
            image: image,
            // width: screenWidth,
            // width: previewImage.width <= screenWidth / maxScale
            //     ? previewImage.width
            //     : screenWidth,
            width: width,
            // height: previewImage.height,
            fit: BoxFit.fitWidth,
            errorBuilder: imageErrorBuilder,
          );
        },
      ),
    );
  }

  Widget header(BuildContext context, SubmissionNotifierQ notifier) {
    final submission = notifier.submission;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      // minVerticalPadding: 0,
      // horizontalTitleGap: 0,
      // minLeadingWidth: 0,
      // visualDensity: VisualDensity(),
      // dense:true,
      /* leading: showSubreddit ? SizedBox.square(
        dimension: 40,
        // child: Loader<String>(
        //   load: (_) => notifier.loadIcon(),
        //   data: (_) => notifier.icon,
        //   onData: (_, icon) => SubredditIcon(icon: icon),
        //   onError: (_, e) {
        //     uiLogger.error('$e');
        //     return SubredditIcon(icon: '');
        //   },
        // ),
        child: Loader<SubredditNotifierQ>(
          load: (_) => notifier.loadSubreddit(),
          data: (_) => notifier.subreddit,
          onData: (_, subreddit) =>
              SubredditIcon(icon: subreddit.subreddit.communityIcon),
          onError: (_, e) {
            uiLogger.error('$e');
            return SubredditIcon(icon: '');
          },
        ),
      ) : null, */
      title: DefaultTextStyle(
        style: TextStyle(color: blackColor, fontSize: 14),
        child: Row(
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
            Text(' • '),
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
              child: Text('u/${submission.author}'),
            ),
            Text(' • '),
            Text(formatDateTime(submission.created)),
          ],
        ),
      ),
      // title: RichText(
      //     text: TextSpan(
      //   // style: DefaultTextStyle.of(context).style.copyWith(color: blackColor),
      //   style: TextStyle(color: blackColor, fontSize: 20),
      //   children: [
      //     TextSpan(text: submission.subredditNamePrefixed, recognizer: TapGestureRecognizer()..onTap = () {

      //     }),
      //     TextSpan(text: ' • '),
      //     TextSpan(text: 'Posted by '),
      //     TextSpan(text: 'u/${submission.author}'),
      //     TextSpan(text: ' • '),
      //     TextSpan(text: formatDateTime(submission.created)),
      //   ],
      // )),
      /* title: showSubreddit
          ? GestureDetector(
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
            )
          : null,
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
          'Posted by u/${submission.author} • ${formatDateTime(submission.created)}',
          softWrap: true,
          // overflow: TextOverflow.clip,
        ),
      ), */
      trailing:
          // width: 50,
          // height: 50,
          activeLink ? _popupMenuButton(context, notifier) : null,
      /* Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // activeLink ? _popupMenuButton(context, notifier) : null,
            if (notifier.subreddit != null)
              AnimatedBuilder(
                animation: notifier.subreddit!,
                builder: (_, __) {
                  if (!notifier.subreddit!.subreddit.userIsSubscriber) {
                    return IconButton(
                      onPressed: () {
                        notifier.subreddit!
                            .subscribe()
                            .catchError((e) => showErrorSnackBar(context, e));
                      },
                      icon: Icon(Icons.add_box, color: selectedColor),
                    );
                  }
                  return Container();
                },
              ),
            if (activeLink) _popupMenuButton(context, notifier)
          ],
        ), */
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
          // text: Text(submission.numComments.toString()),
          text: Text(notifier.numReplies.toString()),
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
