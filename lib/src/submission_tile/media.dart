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

class VideoPlayer extends StatefulWidget {
  VideoPlayer({
    Key? key,
    required this.videoUrl,
    required this.size,
    this.scale = 1.0,
    this.previewImageUrl,
  }) : super(key: key);

  final String videoUrl;
  final Size size;
  final double scale;
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
    final image = _previewImage(context);
    if (image != null) {
      return image;
    }

    return Center(
      child: Video(
        player: _player,
        scale: widget.scale,
        width: widget.size.width,
        height: widget.size.height,
        volumeThumbColor: Colors.blue,
        volumeActiveColor: Colors.blue,
        fillColor: Colors.white,
        showControls: true,
        fit: _fit,
      ),
    );
  }

  void _play() {
    setState(
      () {
        _showPlayer = true;
        _player.play();
      },
    );
  }

  Widget? _previewImage(BuildContext context) {
    final previewImageUrl = widget.previewImageUrl;
    if (_showPlayer || previewImageUrl == null) {
      return null;
    }

    return Center(
      child: GestureDetector(
        onTap: _play,
        child: SizedBox(
          width: widget.size.width,
          height: widget.size.height,
          child: Stack(
            children: [
              SizedNetworkImage(
                imageUrl: previewImageUrl,
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
}

class ImageLink extends StatelessWidget {
  ImageLink({
    Key? key,
    required this.size,
    required this.imageUrl,
    required this.url,
  }) : super(key: key);

  final String imageUrl;
  final String url;

  final Size size;

  @override
  Widget build(BuildContext context) {
    final host = Uri.tryParse(url)?.host ?? '';

    return Center(
      child: InkWell(
        onTap: () {
          launch(url);
        },
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              SizedNetworkImage(
                imageUrl: imageUrl,
                size: size,
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    color: Colors.black54,
                    height: 100,
                    width: size.width,
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

class FullScreenImage extends StatelessWidget {
  FullScreenImage({
    Key? key,
    required this.imageUrl,
    required this.previewImageUrl,
    required this.previewSize,
  }) : super(key: key);

  final String imageUrl;
  final String previewImageUrl;
  final Size previewSize;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ImageScreen(
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: SizedNetworkImage(
        imageUrl: previewImageUrl,
        size: previewSize,
      ),
    );
  }
}

class ImageScreen extends StatelessWidget {
  ImageScreen({
    Key? key,
    required this.imageUrl,
    // required this.size,
  }) : super(key: key);

  final String imageUrl;
  // final Size size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedNetworkImage(
        imageUrl: imageUrl,
        size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
      ),
    );
  }
}

class SizedNetworkImage extends StatelessWidget {
  const SizedNetworkImage({
    Key? key,
    required this.imageUrl,
    required this.size,
    this.showErrorText = true,
  }) : super(key: key);

  final String imageUrl;

  final Size size;
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
              width: size.width,
              height: size.height,
              fit: _fit,
              errorBuilder: errorBuilder,
            );
          }
          if (error != null) {
            return errorBuilder(context, error);
          }
          return Container(width: size.width, height: size.height);
        },
      ),
    );
  }

  Widget errorBuilder(BuildContext context, Object error, [StackTrace? st]) {
    uiLogger.error('$error');
    return Container(
      decoration: BoxDecoration(border: Border.all(color: blackColor)),
      width: size.width,
      height: size.height,
      child: showErrorText
          ? Center(heightFactor: 0.5, child: Text('fail to load image :('))
          : null,
    );
  }
}

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
    required this.items,
    required this.height,
  }) : super(key: key);

  final List<Widget> items;
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
    super.initState();
  }

  bool get _hasNext => _currentPage + 1 < widget.items.length;
  bool get _hasPrev => _currentPage > 0;

  void _next() {
    _controller.nextPage();
    setState(() {
      _currentPage += 1;
    });
  }

  void _prev() {
    _controller.previousPage();
    setState(() {
      _currentPage -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.length == 1) {
      return widget.items.first;
    }

    return Stack(
      children: [
        CarouselSlider(
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
                if (_hasPrev)
                  IconButton(
                    onPressed: _prev,
                    icon: _icon(Icons.arrow_back_ios),
                  ),
                Spacer(),
                if (_hasNext)
                  IconButton(
                    onPressed: _next,
                    icon: _icon(Icons.arrow_forward_ios),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _icon(IconData icon) {
    return Container(
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
    );
  }
}
