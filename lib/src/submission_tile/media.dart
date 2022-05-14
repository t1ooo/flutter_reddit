import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_reddit_prototype/src/logging/logging.dart';

import '../logger.dart';
import '../style/style.dart';
import '../widget/network_image.dart';

Future<void> initVideoPlayer() async {
  // dispose and clear players after hot restart
  players.forEach((_, p) => p.dispose());
  players.clear();
  await DartVLC.initialize(useFlutterNativeView: true);
}

const _fit = BoxFit.contain;
// const _fit =  BoxFit.fill;

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
        fit: _fit,
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

    // return Center(
    //   child: TapableImage(
    //     width: widget.width,
    //     height: widget.height,
    //     imageUrl: previewImageUrl,
    //     icon: Icons.play_circle,
    //     onTap: () {
    //       setState(
    //         () {
    //           _showPlayer = true;
    //           _player.play();
    //         },
    //       );
    //     },
    //   ),
    // );

    return Center(
      // child: InkWell(
      child: GestureDetector(
        onTap: () {
          setState(
            () {
              _showPlayer = true;
              _player.play();
            },
          );
        },
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: [
              SizedNetworkImage(
                imageUrl: previewImageUrl,
                width: widget.width,
                height: widget.height,
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

// class TapableImage extends StatelessWidget {
//   TapableImage({
//     Key? key,
//     required this.width,
//     required this.height,
//     required this.imageUrl,
//     required this.icon,
//     required this.onTap,
//   }) : super(key: key);

//   final String imageUrl;
//   final double width;
//   final double height;
//   final IconData icon;
//   final void Function() onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       // child: InkWell(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Stack(
//           children: [
//             SizedImageWidget(
//               imageUrl: imageUrl,
//               width: width,
//               height: height,
//             ),
//             Positioned.fill(
//               child: Align(
//                 alignment: Alignment.center,
//                 child: Container(
//                   color: Colors.black54,
//                   child: Icon(
//                     icon,
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

class ImageLink extends StatelessWidget {
  ImageLink({
    Key? key,
    required this.width,
    required this.height,
    // required this.icon,
    required this.imageUrl,
    required this.url,
  }) : super(key: key);

  final String imageUrl;
  final String url;
  final double width;
  final double height;
  // final IconData icon;
  // final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final host = Uri.tryParse(url)?.host ?? '';

    return Center(
      child: InkWell(
        // child: GestureDetector(
        onTap: () {
          launch(url);
        },
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              SizedNetworkImage(
                imageUrl: imageUrl,
                width: width,
                height: height,
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    color: Colors.black54,
                    height: 100,
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          host,
                          style: TextStyle(color: Colors.white),
                        ),
                        Spacer(),
                        Icon(
                          Icons.open_in_new,
                          color: Colors.white,
                          // size: 100,
                        ),
                      ],
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
}

// class SizedImageWidget extends StatelessWidget {
//   SizedImageWidget({
//     Key? key,
//     required this.width,
//     required this.height,
//     required this.imageUrl,
//   }) : super(key: key);

//   final String imageUrl;
//   final double width;
//   final double height;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.red),
//         ),
//         child: CustomNetworkImage(
//           imageUrl,
//           onData: (_, image) {
//             return Image(
//               // alignment:Alignment.topLeft,
//               image: image,
//               width: width,
//               height: height,
//               fit: _fit,
//               errorBuilder: imageErrorBuilder,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

class SizedNetworkImage extends StatelessWidget {
  const SizedNetworkImage({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.showErrorText = true,
  }) : super(key: key);

  final String imageUrl;
  final double width;
  final double height;
  final bool showErrorText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomNetworkImageBuilder(
        imageUrl,
        builder: (_, image, error) {
          if (image != null) {
            return Image(
              image: image,
              width: width,
              height: height,
              fit: _fit,
              errorBuilder: errorBuilder,
            );
          }
          if (error != null) {
            return errorBuilder(context, error);
          }
          return Container(width: width, height: height);
        },
      ),
    );
  }

  Widget errorBuilder(BuildContext context, Object error, [StackTrace? st]) {
    uiLogger.error('$error');
    return Container(
      decoration: BoxDecoration(border: Border.all(color: blackColor)),
      width: width,
      height: height,
      child: showErrorText
          ? Center(
              heightFactor: 0.5,
              child: Text('fail to load image :('),
            )
          : null,
    );
  }
}

// Widget _sizedPlaceholder(double width, double height) {
//   return Center(
//     child: Container(
//       width: width,
//       height: height,
//     ),
//   );
// }

// Widget _sizedError(double width, double height) {
//   return Center(
//     child: Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: blackColor),
//       ),
//       width: width,
//       height: height,
//       child: Center(heightFactor: 0.5, child: Text('fail to load image :(')),
//     ),
//   );
// }

class ExternalLink extends StatelessWidget {
  ExternalLink({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        launch(url);
      },
      child: Row(children: [
        Flexible(
          child: Text(
            url,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 5),
        Icon(Icons.open_in_new),
      ]),
    );
  }
}

class ImageSlider extends StatefulWidget {
  const ImageSlider({
    Key? key,
    // required this.imageUrls,
    required this.items,
    // required this.width,
    required this.height,
  }) : super(key: key);

  // final List<String> imageUrls;
  final List<Widget> items;
  // final double width;
  final double height;

  @override
  State<StatefulWidget> createState() {
    return _ImageSliderState();
  }
}

class _ImageSliderState extends State<ImageSlider> {
  final _controller = CarouselController();
  int _currentPage = 0;

  @override
  void initState() {
    // _controller.jumpToPage(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          // items: imageSliders,
          // items: [
          //   for (final imageUrl in widget.imageUrls)
          //     SizedNetworkImage(
          //       imageUrl: imageUrl,
          //       width: widget.width,
          //       height: widget.height,
          //     ),
          // ],
          items: widget.items,
          options: CarouselOptions(
            enlargeCenterPage: false,
            height: widget.height,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
          ),
          carouselController: _controller,
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Row(
              children: [
                if (_currentPage > 0)
                  // if (_controller.hasPrevious)
                  IconButton(
                    onPressed: () {
                      _controller.previousPage();
                      setState(() {
                        _currentPage -= 1;
                      });
                      // print(_currentPage);
                    },
                    icon: Container(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      decoration: ShapeDecoration(
                        shadows: [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 15,
                            spreadRadius: 15,
                          )
                        ],
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
                Spacer(),
                if (_currentPage + 1 < widget.items.length)
                  // if (_controller.hasNext)
                  IconButton(
                    onPressed: () {
                      _controller.nextPage();
                      setState(() {
                        _currentPage += 1;
                      });
                      // print(_currentPage);
                    },
                    icon: Container(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black87,
                      ),
                      decoration: ShapeDecoration(
                        shadows: [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 15,
                            spreadRadius: 15,
                          )
                        ],
                        // shape: CircleBorder(side: BorderSide()),
                        shape: CircleBorder(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
