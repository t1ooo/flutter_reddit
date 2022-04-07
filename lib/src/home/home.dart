import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import 'post_tiles.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PostTiles(showLocationSelector:false);
  }
}
