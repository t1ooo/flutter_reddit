import 'package:flutter/material.dart';

import '../style/style.dart';
import '../thread/post_screen.dart';
import '../user_profile/user_profile_screen.dart';
import '../widget/sized_placeholder.dart';

class PostTile extends StatelessWidget {
  const PostTile({
    Key? key,
    this.activeLink = true,
  }) : super(key: key);

  final bool activeLink;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedPlaceholder(width: 20, height: 20),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('r/subreddit'),
                        Row(children: [
                          Text('Posted by'),
                          Text(' '),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => UserProfileScreen()),
                              );
                            },
                            child: Text('u/User'),
                          ),
                          Text(' * '),
                          Text('v.redd.it'),
                        ]),
                      ],
                    ),
                  ],
                ),
                // Text('+'),
                Row(children: [
                  Text('+'),
                  SizedBox(width: 10),
                  Text('...'),
                ]),
              ],
            ),
            // Text('r/subreddit'),
            // Text('Posted by u/User * 3h * v.redd.it'),
            SizedBox(height: 10),
            Text('26 Awards'),
            SizedBox(height: 10),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PostScreen()),
                );
              },
              child: Text('Some Title', textScaleFactor: 2),
            ),

            SizedBox(height: 10),
            Placeholder(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // runAlignment: WrapAlignment.spaceBetween,
              children: [
                Text('30.2k'),
                // Spacer(),
                Text('5.4k'),
                // Spacer(),
                Text('Share'),
                Text('+'),
              ],
            ),
            // ),
          ],
        ),
      ),
    );
  }
}
