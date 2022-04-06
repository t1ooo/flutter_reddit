import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import '../home/thread_tile.dart';
import 'comments.dart';

class Thread extends StatelessWidget {
  const Thread({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ThreadTile(activeLink: false),
        Comments(),
        // Positioned(
        //   left: 0,
        //   right: 0,
        //   bottom: 0,
        //   child: TextField(
        //     decoration: InputDecoration(
        //       helperText: 'Add a comment',
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
