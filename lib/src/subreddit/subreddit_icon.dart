import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/logging/logging.dart';

import '../logger.dart';
import '../widget/network_image.dart';

class SubredditIcon extends StatelessWidget {
  const SubredditIcon(
      {Key? key,
      required this.icon,
      this.fallbackIcon = 'communityIcon.png',
      this.radius = 20})
      : super(key: key);

  final String icon;
  final String fallbackIcon;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (icon == '') {
      return _icon(AssetImage(fallbackIcon));
    }

    return CustomNetworkImage(
      icon,
      onData: (_, image) => _icon(image),
      onError: (_, e) {
        uiLogger.error('$e');
        return _icon(AssetImage(fallbackIcon));
      },
    );
  }

  Widget _icon(ImageProvider<Object> image) {
    return CircleAvatar(
      radius: radius,
      foregroundImage: image,
      onForegroundImageError: (e, _) => uiLogger.error('$e'),
    );
  }
}
