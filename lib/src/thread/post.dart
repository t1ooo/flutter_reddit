import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import '../home/post_tile.dart';
import 'comments.dart';

class Post extends StatelessWidget {
  const Post({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        PostTile(activeLink: false),
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
