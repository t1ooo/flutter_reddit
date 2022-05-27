import 'dart:io';
import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'const.dart';
import 'sized_network_image.dart';

abstract class BaseVideoPlayer extends StatefulWidget {
  const BaseVideoPlayer({
    Key? key,
    required this.videoUrl,
    required this.size,
    this.previewImageUrl,
  }) : super(key: key);

  final String videoUrl;
  final Size size;
  final String? previewImageUrl;
}

abstract class _BaseVideoPlayerState<T extends BaseVideoPlayer>
    extends State<T> {
  bool _showPlayer = false;

  @override
  Widget build(BuildContext context) {
    final image = _previewImage();
    if (image != null) {
      return AnimatedCrossFade(
        firstChild: image,
        secondChild: videoBuilder(true),
        crossFadeState:
            _showPlayer ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: Duration(seconds: 1),
      );
    } else {
      return videoBuilder();
    }
  }

  Widget? _previewImage() {
    if (widget.previewImageUrl == null) {
      return null;
    }

    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() => _showPlayer = true);
        },
        child: SizedBox(
          width: widget.size.width,
          height: widget.size.height,
          child: Stack(
            children: [
              SizedNetworkImage(
                imageUrl: widget.previewImageUrl!,
                size: widget.size,
                showErrorText: false,
              ),
              Positioned.fill(
                child: Align(
                  child: Container(
                    color: Colors.black54,
                    child: Icon(
                      Icons.play_circle,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget videoBuilder([bool autoPlay = false]);
}

class VideoPlayer extends BaseVideoPlayer {
  const VideoPlayer({
    Key? key,
    required String videoUrl,
    required Size size,
    String? previewImageUrl,
  }) : super(
            key: key,
            videoUrl: videoUrl,
            size: size,
            previewImageUrl: previewImageUrl);

  static bool isSupportedPlatform =
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  static bool _dartVlcInited = false;

  static Future<void> initDartVlc() async {
    /// dispose and clear players after hot restart
    if (_dartVlcInited) {
      return;
    }
    _dartVlcInited = true;

    players
      ..forEach((_, p) => p.dispose())
      ..clear();
    await DartVLC.initialize(useFlutterNativeView: true);
  }

  @override
  State<VideoPlayer> createState() => _VideoBuilderState();
}

class _VideoBuilderState extends _BaseVideoPlayerState<VideoPlayer> {
  Player? _player;
  bool _ready = false;

  @override
  void initState() {
    VideoPlayer.initDartVlc().then((_) {
      _player = Player(
        id: Random().nextInt(1000 * 1000),
      );
      _player!.open(
        Playlist(medias: [Media.network(widget.videoUrl)]),
        autoStart: false,
      );
      setState(() => _ready = true);
    });
    super.initState();
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget videoBuilder([bool autoPlay = false]) {
    if (!_ready) {
      return Center(
        child: SizedBox(
          width: widget.size.width,
          height: widget.size.height,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (autoPlay) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _player!.play();
      });
    }
    return Center(
      child: Video(
        player: _player,
        width: widget.size.width,
        height: widget.size.height,
        volumeThumbColor: Colors.blue,
        volumeActiveColor: Colors.blue,
        fillColor: Colors.white,
      ),
    );
  }
}

class MobileVideoPlayer extends BaseVideoPlayer {
  const MobileVideoPlayer({
    Key? key,
    required String videoUrl,
    required Size size,
    String? previewImageUrl,
  }) : super(
            key: key,
            videoUrl: videoUrl,
            size: size,
            previewImageUrl: previewImageUrl);

  static bool isSupportedPlatform =
      Platform.isAndroid || Platform.isIOS || kIsWeb;

  @override
  State<MobileVideoPlayer> createState() => _MobileVideoBuilderState();
}

class _MobileVideoBuilderState
    extends _BaseVideoPlayerState<MobileVideoPlayer> {
  late final VideoPlayerController _videoController;
  late final ChewieController _chewieController;

  @override
  void initState() {
    _videoController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      aspectRatio: widget.size.width / widget.size.height,
    );
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget videoBuilder([bool autoPlay = false]) {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      if (!_videoController.value.isInitialized) {
        await _videoController.initialize();
      }
      if (autoPlay) {
        // ignore: unawaited_futures
        _chewieController.play();
      }
    });

    return Center(
      child: SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: Chewie(controller: _chewieController),
      ),
    );
  }
}
