import 'dart:async';

import 'package:flutter/material.dart';

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
      for (final icon in (awardIcons).take(4))
        Image.network(icon, width: 16, height: 16),
      SizedBox(width: 5),
      Text('$totalAwardsReceived Awards'),
    ]);
  }
}
