import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_reddit_prototype/src/logging/logging.dart';
import 'package:provider/provider.dart';

import '../logger.dart';
import '../submission_tile/submission_tiles.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/submission_type.dart';
import '../search/search_field.dart';
import '../style/style.dart';
import '../widget/network_image.dart';
import '../widget/subscribe_button.dart';
// import '../widget/subscribe_button.dart';

class SubredditIcon extends StatelessWidget {
  const SubredditIcon({
    Key? key,
    required this.icon,
    this.fallbackIcon = 'communityIcon.png',
    this.radius = 20
  }) : super(key: key);

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
      radius: radius, // Image radius
      foregroundImage: image,
      onForegroundImageError: (e, _) => uiLogger.error('$e'),
    );
  }
}
