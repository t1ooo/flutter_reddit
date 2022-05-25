import 'dart:io';
import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/logging.dart';
import 'package:video_player/video_player.dart';

import '../../style.dart';
import '../../ui_logger.dart';
import '../../widget/network_image.dart';
import 'const.dart';
import 'sized_network_image.dart';

abstract class BaseVideoPlayer extends StatefulWidget {
  BaseVideoPlayer({
    Key? key,
    required this.videoUrl,
    required this.size,
    this.previewImageUrl,
  }) : super(key: key);

  final String videoUrl;
  final Size size;
  final String? previewImageUrl;

  // @override
  // State<BaseVideoPlayer> createState() => _BaseVideoPlayerState();
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

    // final image = _previewImage();
    // if (!_showPlayer && image != null) {
    //   return image;
    // }

    // return videoBuilder(true);
  }

  Widget? _previewImage() {
    // final previewImageUrl = widget.previewImageUrl;
    // if (_showPlayer || previewImageUrl == null) {
    //   return null;
    // }

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
                  alignment: Alignment.center,
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
  // void play();
}

class VideoPlayer extends BaseVideoPlayer {
  VideoPlayer({
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

    players.forEach((_, p) => p.dispose());
    players.clear();
    await DartVLC.initialize(useFlutterNativeView: true);
    print('init end');
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
        registerTexture: true,
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
        player: _player!,
        width: widget.size.width,
        height: widget.size.height,
        volumeThumbColor: Colors.blue,
        volumeActiveColor: Colors.blue,
        fillColor: Colors.white,
        showControls: true,
        fit: fit,
      ),
    );
  }
}

class MobileVideoPlayer extends BaseVideoPlayer {
  MobileVideoPlayer({
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
      // isLive: true,
      autoInitialize: false,
      autoPlay: false,
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
      // _chewieController.play();
      if (!_videoController.value.isInitialized) {
        await _videoController.initialize();
      }
      if (autoPlay) {
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

// class VideoPlayer extends StatefulWidget {
//   VideoPlayer({
//     Key? key,
//     required this.videoUrl,
//     required this.size,
//     this.scale = 1.0, // TODO: remove
//     this.previewImageUrl,
//   }) : super(key: key);

//   final String videoUrl;
//   final Size size;
//   final double scale;
//   final String? previewImageUrl;

//   static bool isSupportedPlatform =
//       Platform.isLinux || Platform.isMacOS || Platform.isWindows;

//   @override
//   State<VideoPlayer> createState() => _VideoPlayerState();
// }

// class _VideoPlayerState extends State<VideoPlayer> {
//   late final Player _player;
//   bool _showPlayer = false;

//   @override
//   void initState() {
//     _player = Player(
//       id: Random().nextInt(1000 * 1000),
//       registerTexture: true,
//     );
//     _player.open(
//       Playlist(
//         medias: [Media.network(widget.videoUrl)],
//       ),
//       autoStart: false, //default
//     );
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }

//   void _play() {
//     setState(
//       () {
//         _showPlayer = true;
//         _player.play();
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final image = _previewImage(context);
//     // if (image != null) {
//     //   return image;
//     // }

//     if (!_showPlayer || widget.previewImageUrl != null) {
//       return GestureDetector(
//         onTap: _play,
//         child: VideoPreviewImage(
//           size: widget.size,
//           previewImageUrl: widget.previewImageUrl!,
//         ),
//       );
//     }

//     return Center(
//       child: Video(
//         player: _player,
//         scale: widget.scale,
//         width: widget.size.width,
//         height: widget.size.height,
//         volumeThumbColor: Colors.blue,
//         volumeActiveColor: Colors.blue,
//         fillColor: Colors.white,
//         showControls: true,
//         fit: _fit,
//       ),
//     );
//   }

//   // Widget? _previewImage(BuildContext context) {
//   //   final previewImageUrl = widget.previewImageUrl;
//   //   if (_showPlayer || previewImageUrl == null) {
//   //     return null;
//   //   }

//   //   return Center(
//   //     child: GestureDetector(
//   //       onTap: _play,
//   //       child: SizedBox(
//   //         width: widget.size.width,
//   //         height: widget.size.height,
//   //         child: Stack(
//   //           children: [
//   //             _SizedNetworkImage(
//   //               imageUrl: previewImageUrl,
//   //               size: widget.size,
//   //               showErrorText: false,
//   //             ),
//   //             Positioned.fill(
//   //               child: Align(
//   //                 alignment: Alignment.center,
//   //                 child: Container(
//   //                   color: Colors.black54,
//   //                   child: Icon(
//   //                     Icons.play_circle,
//   //                     color: Colors.white,
//   //                     size: 100,
//   //                   ),
//   //                 ),
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
// }

// class MobileVideoPlayer extends StatefulWidget {
//   MobileVideoPlayer({
//     Key? key,
//     required this.videoUrl,
//     required this.size,
//     this.scale = 1.0, // TODO: remove
//     this.previewImageUrl,
//   }) : super(key: key);

//   final String videoUrl;
//   final Size size;
//   final double scale;
//   final String? previewImageUrl;

//   static bool isSupportedPlatform =
//       Platform.isAndroid || Platform.isIOS || kIsWeb;

//   @override
//   State<MobileVideoPlayer> createState() => _MobileVideoPlayerState();
// }

// class _MobileVideoPlayerState extends State<MobileVideoPlayer> {
//   late final VideoPlayerController _videoController;
//   late final ChewieController _chewieController;
//   bool _showPlayer = false;

//   @override
//   void initState() {
//     _videoController = VideoPlayerController.network(widget.videoUrl);
//     _chewieController = ChewieController(
//       videoPlayerController: _videoController,
//       // isLive: true,
//       autoInitialize: true,
//     );
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
//     _chewieController.dispose();
//     super.dispose();
//   }

//   Future<void> _play() async {
//     if (!_videoController.value.isInitialized) {
//       await _videoController.initialize();
//     }
//     _chewieController.play();
//     setState(() => _showPlayer = true);
//   }

//   // Widget _video() {
//   //   return Center(
//   //     child: SizedBox(
//   //       width: widget.size.width,
//   //       height: widget.size.height,
//   //       child: Chewie(controller: _chewieController),
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // final image = _previewImage(context);
//     // if (image != null) {
//     //   return image;
//     // }

//     if (!_showPlayer || widget.previewImageUrl != null) {
//       return GestureDetector(
//         onTap: _play,
//         child: VideoPreviewImage(
//           size: widget.size,
//           previewImageUrl: widget.previewImageUrl!,
//         ),
//       );
//     }

//     return Center(
//       child: SizedBox(
//         width: widget.size.width,
//         height: widget.size.height,
//         child: Chewie(controller: _chewieController),
//       ),
//     );
//   }

//   // Widget? _previewImage(BuildContext context) {
//   //   final previewImageUrl = widget.previewImageUrl;
//   //   if (_showPlayer || previewImageUrl == null) {
//   //     return null;
//   //   }

//   //   return Center(
//   //     child: GestureDetector(
//   //       onTap: _play,
//   //       child: SizedBox(
//   //         width: widget.size.width,
//   //         height: widget.size.height,
//   //         child: Stack(
//   //           children: [
//   //             _SizedNetworkImage(
//   //               imageUrl: previewImageUrl,
//   //               size: widget.size,
//   //               showErrorText: false,
//   //             ),
//   //             Positioned.fill(
//   //               child: Align(
//   //                 alignment: Alignment.center,
//   //                 child: Container(
//   //                   color: Colors.black54,
//   //                   child: Icon(
//   //                     Icons.play_circle,
//   //                     color: Colors.white,
//   //                     size: 100,
//   //                   ),
//   //                 ),
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
// }

// class VideoPreviewImage extends StatelessWidget {
//   VideoPreviewImage({
//     Key? key,
//     required this.size,
//     required this.previewImageUrl,
//   }) : super(key: key);

//   final Size size;
//   final String previewImageUrl;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         width: size.width,
//         height: size.height,
//         child: Stack(
//           children: [
//             _SizedNetworkImage(
//               imageUrl: previewImageUrl,
//               size: size,
//               showErrorText: false,
//             ),
//             Positioned.fill(
//               child: Align(
//                 alignment: Alignment.center,
//                 child: Container(
//                   color: Colors.black54,
//                   child: Icon(
//                     Icons.play_circle,
//                     color: Colors.white,
//                     size: 100,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
