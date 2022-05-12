import 'dart:math';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';

import '../widget/network_image.dart';


Future<void> initVideoPlayer() async {
  // dispose and clear players after hot restart
  players.forEach((_, p) => p.dispose());
  players.clear();
  await DartVLC.initialize(useFlutterNativeView: true);
}

class VideoPlayer extends StatefulWidget {
  VideoPlayer({
    Key? key,
    required this.videoUrl,
    required this.width,
    required this.height,
    this.scale = 1.0,
    this.previewImageUrl,
  }) : super(key: key);

  final String videoUrl;
  final double width;
  final double height;
  final double scale;
  // final SizedImage? previewImage;
  final String? previewImageUrl;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late final Player _player;
  bool _showPlayer = false;

  @override
  void initState() {
    _player = Player(
      id: Random().nextInt(1000 * 1000),
      registerTexture: true,
      // videoDimensions: VideoDimensions(widget.width.toInt(), widget.height.toInt()),
    );
    _player.open(
      Playlist(
        medias: [Media.network(widget.videoUrl)],
      ),
      autoStart: false, //default
    );
    super.initState();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.backgroundImage != null) {
    //   return GestureDetector(child: Image(image: widget.backgroundImage!));
    // }
    final image = _previewImage(context);
    if (image != null) {
      return image;
    }

    // final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Video(
        player: _player,
        scale: widget.scale,
        width: widget.width,
        height: widget.height,
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        volumeThumbColor: Colors.blue,
        volumeActiveColor: Colors.blue,
        fillColor: Colors.white,
        showControls: true,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget? _previewImage(BuildContext context) {
    final previewImageUrl = widget.previewImageUrl;
    if (_showPlayer || previewImageUrl == null) {
      return null;
    }

    // final minWidth = 200.0;
    // final screenWidth = MediaQuery.of(context).size.width;

    // final maxScale = 5;
    // final width = min(previewImage.width * maxScale, screenWidth);

    return TapableImage(
      width: widget.width,
      height: widget.height,
      imageUrl: previewImageUrl,
      icon: Icons.play_circle,
      onTap: () {
          setState(() {
            _showPlayer = true;
            _player.play();
          });
        },
    );

    // final iconSize = 100.0;
    // return Center(
    //   child: GestureDetector(
    //     onTap: () {
    //       setState(() {
    //         _showPlayer = true;
    //         _player.play();
    //       });
    //     },
    //     child: Stack(
    //       children: [
    //         CustomNetworkImage(
    //           previewImage.url,
    //           onData: (_, image) {
    //             return Image(
    //               image: image,
    //               width: widget.width,
    //               height: widget.height,
    //               fit: BoxFit.none,
    //               errorBuilder: imageErrorBuilder,
    //             );
    //           },
    //         ),
    //         Positioned(
    //           top: (widget.height - iconSize) / 2,
    //           left: (widget.width - iconSize) / 2,
    //           child: Icon(
    //             Icons.play_circle,
    //             color: Colors.white,
    //             size: iconSize,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}

class TapableImage extends StatelessWidget {
  TapableImage({
    Key? key,
    required this.width,
    required this.height,
    required this.imageUrl,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final String imageUrl;
  final double width;
  final double height;
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            SizedImageWidget(
              imageUrl: imageUrl,
              width: width,
              height: height,
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  color: Colors.black54,
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SizedImageWidget extends StatelessWidget {
  SizedImageWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomNetworkImage(
        imageUrl,
        onData: (_, image) {
          return Image(
            image: image,
            width: width,
            height: height,
            fit: BoxFit.contain,
            errorBuilder: imageErrorBuilder,
          );
        },
      ),
    );
  }
}
