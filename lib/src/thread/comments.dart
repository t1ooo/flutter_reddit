import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import '../home/thread_tile.dart';
import 'comment.dart';

class Comments extends StatelessWidget {
  const Comments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          child: Text('BEST COMMENTS'),
          onPressed: () {},
        ),
        Comment(),
        Comment(),
        Comment(),
        Comment(),
        // Card(
        //     child: Padding(
        //   padding: cardPadding,
        //   child: Comment(),
        // )),
      ],
    );
  }
}
