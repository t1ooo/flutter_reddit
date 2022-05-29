import 'package:flutter/material.dart';

import '../../widget/sliver_app_bar.dart';
import 'sized_network_image.dart';

class FullScreenImage extends StatelessWidget {
  const FullScreenImage({
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
  const ImageScreen({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            PrimarySliverAppBar(
              collapsed: true,
              flexibleSpace: SpaceBar(
                leading: AppBarCloseButton(),
              ),
            ),
          ];
        },
        body: SizedNetworkImage(
          imageUrl: imageUrl,
          size: MediaQuery.of(context).size,
        ),
      ),
    );
  }
}
