import 'package:flutter/material.dart';

import '../style/style.dart';
import '../user_profile/user_profile_screen.dart';
import '../widget/sized_placeholder.dart';
import 'style.dart';

class Comment extends StatelessWidget {
  const Comment({
    Key? key,
    this.depth = 0,
    this.showNested = true,
  }) : super(key: key);

  final int depth;
  final bool showNested;

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
    return Padding(
      padding: commentPadding(depth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedPlaceholder(width: 20, height: 20),
              SizedBox(width: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UserProfileScreen()),
                  );
                },
                child: Text('u/User'),
              ),
              Text(' * '),
              Text('4h'),
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
            for (int i = 0; i < 2; i++)
              Comment(
                depth: depth + 1,
                showNested: showNested,
              ),
          ],
        ],
      ),
    );
  }
}
