import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/reddit_api/post_hint.dart';
import 'package:flutter_reddit_prototype/src/subreddit/subreddit_screen.dart';
import 'package:flutter_reddit_prototype/src/widget/awards.dart';
import 'package:flutter_reddit_prototype/src/widget/debug.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/vote.dart';
import '../style/style.dart';
import '../submission/submission_screen.dart';
import '../user_profile/user_profile_screen.dart';
import '../util/date_time.dart';

import '../util/size.dart';
import '../util/snackbar.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/icon_text.dart';

import '../widget/network_image.dart';
import 'media.dart';

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
            whenDebug(() => Text(submission.postHint.toString())),
            whenDebug(() => Text(submission.url)),
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
            SizedBox(height: 15),
            // if (submission.postHint == PostHint.link) ...[
            //   ExternalLink(
            //     url: submission.url,
            //   ),
            //   SizedBox(height: 15),
            // ],
            // if (submission.thumbnail != '')
            // CustomNetworkImageBuilder(submission.thumbnail),
            // _video(context, notifier),
            // _previewImage(context, notifier),
            LayoutBuilder(builder: (context, constraints) {
              return _media(context, constraints, notifier) ?? Container();
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

  Widget? _media(
    BuildContext context,
    BoxConstraints constraints,
    SubmissionNotifierQ notifier,
  ) {
    final submission = notifier.submission;

    final maxHeight = MediaQuery.of(context).size.height * 0.7;
    final maxWidth = constraints.maxWidth;
    final minWidth = 200.0;

    // final images = notifier.images(minWidth, maxWidth);
    final images = notifier.images(maxWidth, maxHeight);
    final previewImage = images.isEmpty ? null : images.first.preview;

    Size _adjustSize(double width, double height) => adjustSize(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          width: width,
          height: height,
        );

    switch (submission.postHint) {
      case PostHint.hostedVideo:
        final video = submission.video;
        if (video == null || video.fallbackUrl == '') {
          return null;
        }

        return VideoPlayer(
          videoUrl: video.fallbackUrl,
          previewImageUrl: previewImage?.url,
          size: _adjustSize(video.width, video.height),
        );

      case PostHint.image:
        if (images == []) {
          return null;
        }

        final sizes = images
            .map((v) => _adjustSize(v.preview.width, v.preview.height))
            .toList();
        final maxHeight = sizes.map((v) => v.height).reduce(max);

        return ImageSlider(
          items: [
            for (int i = 0; i < images.length; i++)
              FullScreenImage(
                imageUrl: images[i].image.url,
                previewImageUrl: images[i].preview.url,
                previewSize: sizes[i],
              ),
          ],
          height: maxHeight,
        );

      case PostHint.link:
      case PostHint.richVideo:
        if (previewImage == null) {
          return ExternalLink(url: submission.url);
        }

        return ImageLink(
          imageUrl: previewImage.url,
          url: notifier.submission.url,
          size: _adjustSize(previewImage.width, previewImage.height),
        );

      case PostHint.none:
      case PostHint.self:
        return null;
    }
  }

  /* Widget _video(BuildContext context, SubmissionNotifierQ notifier) {
    final video = notifier.submission.video;
    if (video == null) {
      return Container();
    }
    final url = video.fallbackUrl;
    if (url == '') {
      return Container();
    }

    final size = _adjustSize(context, video.width, video.height);
    final width = size[0];
    final height = size[1];

    final minWidth = 200.0;
    final maxWidth = _maxWidth(context);
    final previewImage = notifier.previewImage(minWidth, maxWidth);

    return VideoPlayer(
      videoUrl: url,
      width: width,
      height: height,
      // scale: scale,
      previewImageUrl: previewImage?.url,
    );
  } */

  // double _maxHeight(BuildContext context) =>
  //     MediaQuery.of(context).size.height * 0.8;
  // double _maxWidth(BuildContext context) =>
  //     MediaQuery.of(context).size.width * 0.9;

  /* Widget _previewImage(BuildContext context, SubmissionNotifierQ notifier) {
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
  } */

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
