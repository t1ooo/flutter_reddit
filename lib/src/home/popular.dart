import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../widget/sized_placeholder.dart';
import 'custom_scroll.dart';
import 'post_tile.dart';
import 'post_tiles.dart';

class Popular extends StatelessWidget {
  const Popular({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PostTiles();
  }
}
