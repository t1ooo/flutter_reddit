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
      for (final icon in awardIcons)
        CustomNetworkImage(icon, onData: (_, image) {
          return Image(
            width: 16,
            height: 16,
            image: image,
            errorBuilder: imageErrorBuilder,
          );
        }),
      SizedBox(width: 5),
      Text('$totalAwardsReceived Awards'),
    ]);
  }
}
