import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/logging.dart';

import '../../style.dart';
import '../../ui_logger.dart';
import '../../widget/network_image.dart';
import 'const.dart';

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
              fit: fit,
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
