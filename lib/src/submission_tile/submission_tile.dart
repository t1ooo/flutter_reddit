import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/submission_notifier.dart';
import '../reddit_api/post_hint.dart';
import '../style.dart';
import '../submission/submission_screen.dart';
import '../subreddit/subreddit_screen.dart';
import '../user_profile/user_profile_screen.dart';
import '../util/date_time.dart';
import '../util/size.dart';
import '../util/youtube.dart';
import '../widget/awards.dart';
import '../widget/debug.dart';
import '../widget/icon_text.dart';
import '../widget/like.dart';
import '../widget/snackbar.dart';
import 'media/external_link.dart';
import 'media/fullscreen_image.dart';
import 'media/image_link.dart';
import 'media/image_slider.dart';
import 'media/video_player.dart';
import 'media/youtube_player.dart';
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
          child: _header(context, notifier),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context, notifier),
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
            LayoutBuilder(
              builder: (context, constraints) {
                return _media(context, constraints, notifier) ?? Container();
              },
            ),
            SizedBox(height: 10),
            Text(
              submission.selftext,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 10),
            _footer(context, notifier),
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

    final images = notifier.images(maxWidth, maxHeight);
    final previewImage = images.isEmpty ? null : images.first.preview;

    Size _adjustSize(double width, double height) => adjustSize(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          width: width,
          height: height,
        );

    Widget? _link() {
      if (submission.url == '') {
        return null;
      }

      if (previewImage == null) {
        return ExternalLink(url: submission.url);
      }

      return ImageLink(
        imageUrl: previewImage.url,
        url: submission.url,
        size: _adjustSize(previewImage.width, previewImage.height),
      );
    }

    Widget? _richVideo() {
      if (YoutubePlayer.isSupportedPlatform) {
        final youtubeVideo = parseYoutubeUrl(submission.url);
        if (youtubeVideo != null) {
          return YoutubePlayer(youtubeVideo: youtubeVideo);
        }
      }

      // return _link();
      return null;
    }

    Widget? _hostedVideo() {
      final video = submission.video;
      if (video == null || video.fallbackUrl == '') {
        return null;
      }

      if (VideoPlayer.isSupportedPlatform) {
        return VideoPlayer(
          videoUrl: video.fallbackUrl,
          previewImageUrl: previewImage?.url,
          size: _adjustSize(video.width, video.height),
        );
      } else if (MobileVideoPlayer.isSupportedPlatform) {
        return MobileVideoPlayer(
          videoUrl: video.fallbackUrl,
          previewImageUrl: previewImage?.url,
          size: _adjustSize(video.width, video.height),
        );
      } else {
        // return _link();
        return null;
      }
    }

    Widget? _image() {
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
    }

    switch (submission.postHint) {
      case PostHint.hostedVideo:
        return _hostedVideo();
      case PostHint.image:
        return _image();
      case PostHint.richVideo:
        return _richVideo() ?? _link();
      case PostHint.link:
        return _link();
      case PostHint.none:
      case PostHint.self:
        // return null;
        return _richVideo() ?? _link();
    }
  }

  Widget _header(BuildContext context, SubmissionNotifier notifier) {
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
        ),
      ),
      trailing: !fullpage ? SubmissionPopupMenu() : null,
    );
  }

  Widget _footer(BuildContext context, SubmissionNotifier notifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LikeButton(likable: notifier),
        IconText(
          icon: Icon(Icons.comment),
          text: Text(_formatNumReplies(notifier.numReplies)),
        ),
        TextButton.icon(
          onPressed: () => notifier.share(),
          icon: Icon(Icons.share),
          label: Text('Share'),
        ),
        if (kDebugMode)
          TextButton(
            onPressed: () => showTodoSnackBar(context), // TODO
            child: Icon(Icons.star_outline),
          ),
      ],
    );
  }

  String _formatNumReplies(int score) {
    if (score < 1000) {
      return score.toString();
    }
    return '${(score * 10 / 1000).ceil() / 10}k';
  }
}
