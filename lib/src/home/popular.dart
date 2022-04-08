import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import 'post_tiles.dart';

class Popular extends StatelessWidget {
  const Popular({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<RedditNotifier>();
    return PostTiles(
      submissions: notifier.popular,
    );
  }
}
