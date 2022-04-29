import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'network_image.dart';

class Awards extends StatelessWidget {
  Awards({
    Key? key,
    required this.awardIcons,
    required this.totalAwardsReceived,
  }) : super(key: key);

  final List<String> awardIcons;
  final int totalAwardsReceived;

  @override
  Widget build(BuildContext context) {
    if (totalAwardsReceived == 0) return Container();
    return Row(children: [
      // for (final icon in (awardIcons).take(4))
      for (final icon in awardIcons)
        // Image.network(icon, width: 16, height: 16),
        NetworkImageBuilder(icon, builder: (context, image, error) {
          if (error != null) {
            log('$error');
            return Container();
          }
          if (image != null) {
            return Image(width: 16, height: 16, image: image);
          }
          return Container();
        }),
      SizedBox(width: 5),
      Text('$totalAwardsReceived Awards'),
    ]);
  }
}
