import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/style/style.dart';

import '../home/submission_tile.dart';
import 'comment.dart';

class Comments extends StatelessWidget {
  const Comments({
    Key? key,
    this.showNested = true,
  }) : super(key: key);

  final bool showNested;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      // return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TextButton(
        //   child: Text('BEST COMMENTS'),
        //   onPressed: () {},
        // ),
        Padding(
          padding: scrollPadding,
          child: Comment(showNested: showNested),
        ),
        Padding(
          padding: scrollPadding,
          child: Comment(showNested: showNested),
        ),
        Padding(
          padding: scrollPadding,
          child: Comment(showNested: showNested),
        ),
        // Comment(showNested: showNested),
        // Comment(showNested: showNested),
        // Comment(showNested: showNested),
        // Comment(showNested: showNested),
        // Card(
        //     child: Padding(
        //   padding: cardPadding,
        //   child: Comment(),
        // )),
      ],
    );
  }
}
