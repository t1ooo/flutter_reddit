import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import '../home/thread_tile.dart';
import 'comments.dart';

class Thread extends StatelessWidget {
  const Thread({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: scrollPadding,
      child: ListView(
        children: [
          ThreadTile(activeLink: false),
          Comments(),
          TextField(
            decoration: InputDecoration(
              helperText: 'Add a comment',
            ),
          ),
        ],
      ),
    );
  }
}
