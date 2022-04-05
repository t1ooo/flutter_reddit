import 'package:flutter/material.dart';

import '../style/style.dart';
import 'style.dart';

class Comment extends StatelessWidget {
  const Comment({
    Key? key,
    this.depth = 0,
  }) : super(key: key);

  final int depth;

  @override
  Widget build(BuildContext context) {
    if (depth == 0) {
      return withCard(context);
    }
    return body(context);
  }

  Widget withCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: cardPadding,
        child: body(context),
      ),
    );
  }

  Widget body(BuildContext context) {
    print(depth);
    return Padding(
      padding: commentPadding(depth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Placeholder(fallbackWidth: 20, fallbackHeight: 20),
              SizedBox(width: 10),
              Text('user name * 4h'),
            ],
          ),
          Text('user comment text'),
          Row(
            // alignment: WrapAlignment.end,
            // crossAxisAlignment: WrapCrossAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Spacer(),
              Text('...'),
              SizedBox(width: 10),
              Text('Reply'),
              SizedBox(width: 10),
              Text('388'),
            ],
          ),
          if (depth < 2) ...[
            for (int i = 0; i < 2; i++) Comment(depth: depth + 1),
          ],
        ],
      ),
    );
  }
}
