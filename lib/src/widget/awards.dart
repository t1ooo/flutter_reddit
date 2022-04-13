import 'dart:async';

import 'package:flutter/material.dart';

class Awards extends StatelessWidget {
  Awards({
    Key? key,
    required this.awardIcons,
    required this.numAwards,
  }) : super(key: key);

  final List<String> awardIcons;
  final int numAwards;

  @override
  Widget build(BuildContext context) {
    if (numAwards == 0) return Container();
    return Row(children: [
      for (final icon in (awardIcons).take(4))
        Image.network(icon, width: 16, height: 16),
      SizedBox(width: 5),
      Text('$numAwards Awards'),
    ]);
  }
}
