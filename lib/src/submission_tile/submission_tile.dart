import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/reddit_api/post_hint.dart';
import 'package:flutter_reddit_prototype/src/subreddit/subreddit_screen.dart';
import 'package:flutter_reddit_prototype/src/widget/awards.dart';
import 'package:flutter_reddit_prototype/src/widget/debug.dart';

import 'package:provider/provider.dart';

import '../notifier/auth_notifier.dart';
import '../notifier/collapse_mixin.dart';
import '../notifier/comment_notifier.dart';
import '../notifier/current_user_notifier.dart';
import '../notifier/home_front_notifier.dart';
import '../notifier/home_popular_notifier.dart';
import '../notifier/iterable_sum.dart';
import '../notifier/likable_mixin.dart';
import '../notifier/limit.dart';
import '../notifier/list_notifier.dart';
import '../notifier/message_notifier.dart';
import '../notifier/property_listener.dart';
import '../notifier/replyable.dart';
import '../notifier/reportable.dart';
import '../notifier/rule_notifier.dart';
import '../notifier/savable_mixin.dart';
import '../notifier/score.dart';
import '../notifier/search_notifier.dart';
import '../notifier/search_subreddits.dart';
import '../notifier/submission_loader_notifier.dart';
import '../notifier/submission_notifier.dart';
import '../notifier/submissions_notifier.dart';
import '../notifier/subreddit_loader_notifier.dart';
import '../notifier/subreddit_notifier.dart';
import '../notifier/try_mixin.dart';
import '../notifier/user_loader_notifier.dart';
import '../notifier/user_notifier.dart';
import '../style/style.dart';
import '../submission/submission_screen.dart';
import '../user_profile/user_profile_screen.dart';
import '../util/date_time.dart';

import '../util/size.dart';
import '../widget/snackbar.dart';
import '../widget/icon_text.dart';

import '../widget/like.dart';
import '../widget/save.dart';
import 'media.dart';
import 'submission_popup_menu.dart';

class SubmissionTile extends StatelessWidget {
  const SubmissionTile({
    Key? key,
    this.fullpage = false,
  }) : super(key: key);

  final bool fullpage;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubmissionNotifier>();
    final submission = notifier.submission;

    if (!fullpage && submission.hidden) {
      return Card(
        child: Padding(
          padding: cardPadding,
          child: header(context, notifier),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(context, notifier),
            whenDebug(() => Text(submission.postHint.toString())),
            whenDebug(() => Text(submission.url)),
            Awards(
              awardIcons: submission.awardIcons,
              totalAwardsReceived: submission.totalAwardsReceived,
            ),
            SizedBox(height: 15),
            InkWell(
              onTap: !fullpage
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ChangeNotifierProvider<SubmissionNotifier>.value(
                            value: notifier,
                            child: SubmissionScreen(),
                          ),
                        ),
                      );
                    }
                  : null,
              child: Text(submission.title, textScaleFactor: 1.8),
            ),
            SizedBox(height: 15),
            LayoutBuilder(builder: (context, constraints) {
              return _media(context, constraints, notifier) ?? Container();
            }),
            SizedBox(height: 10),
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
    SubmissionNotifier notifier,
  ) {
    final submission = notifier.submission;

    final maxHeight = MediaQuery.of(context).size.height * 0.7;
    final maxWidth = constraints.maxWidth;
    final minWidth = 200.0;

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

  Widget header(BuildContext context, SubmissionNotifier notifier) {
    final submission = notifier.submission;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: DefaultTextStyle(
        style: TextStyle(color: blackColor, fontSize: 14),
        child: Wrap(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubredditScreen(
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
          // .map((v) => Flexible(child: v, flex:1)).toList(),
        ),
      ),
      // trailing: activeLink ? _popupMenuButton(context, notifier) : null,
      trailing: !fullpage ? SubmissionPopupMenu() : null,
    );
  }

  Widget footer(BuildContext context, SubmissionNotifier notifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LikeButton(likable: notifier),
        IconText(
          icon: Icon(Icons.comment),
          text: Text(notifier.numReplies.toString()),
        ),
        TextButton(
          onPressed: () {
            notifier.share();
          },
          // TODO: replace to TextButton.icon

          child: IconText(
            icon: Icon(Icons.share),
            text: Text('Share'),
          ),
        ),
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

  // CustomPopupMenuButton _popupMenuButton(
  //   BuildContext context,
  //   SubmissionNotifier notifier,
  // ) {
  //   return CustomPopupMenuButton(
  //     icon: Icon(Icons.more_vert),
  //     items: [
  //       savePopupMenuItem(context, notifier),
  //       if (kDebugMode)
  //         CustomPopupMenuItem(
  //           icon: Icon(Icons.visibility_off),
  //           label: 'Hide Post',
  //           onTap: () {
  //             showTodoSnackBar(context); // TODO
  //           },
  //         ),
  //       if (kDebugMode)
  //         CustomPopupMenuItem(
  //           icon: Icon(Icons.report),
  //           label: 'Report',
  //           onTap: () {
  //             showTodoSnackBar(context); // TODO
  //           },
  //         ),
  //       if (kDebugMode)
  //         CustomPopupMenuItem(
  //           icon: Icon(Icons.block),
  //           label: 'Block user',
  //           onTap: () {
  //             showTodoSnackBar(context); // TODO
  //           },
  //         ),
  //     ],
  //   );
  // }
}
