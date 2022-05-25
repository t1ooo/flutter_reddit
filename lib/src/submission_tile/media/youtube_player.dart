import 'dart:io';

import 'package:youtube_player_flutter/youtube_player_flutter.dart' as yp;
import 'package:flutter/material.dart';

import '../../util/youtube.dart';

class YoutubePlayer extends StatefulWidget {
  YoutubePlayer({
    Key? key,
    required this.youtubeVideo,
  }) : super(key: key);

  final YoutubeVideo youtubeVideo;

  static bool get isSupportedPlatform => Platform.isAndroid || Platform.isIOS;

  @override
  State<YoutubePlayer> createState() => _YoutubePlayerState();
}

class _YoutubePlayerState extends State<YoutubePlayer> {
  late final yp.YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = yp.YoutubePlayerController(
      initialVideoId: widget.youtubeVideo.id,
      flags: yp.YoutubePlayerFlags(
        autoPlay: false,
        startAt: widget.youtubeVideo.startAt,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return yp.YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
    );
  }
}
