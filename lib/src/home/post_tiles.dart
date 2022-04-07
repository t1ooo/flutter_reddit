import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
import '../style/style.dart';
import '../thread/post_screen.dart';
import '../user_profile/user_profile_screen.dart';
import '../widget/sized_placeholder.dart';
import 'custom_scroll.dart';
import 'post_tile.dart';

class PostTiles extends StatelessWidget {
  const PostTiles({
    Key? key,
    this.activeLink = true,
    this.showTrending = true,
    this.showTypeSelector = true,
    this.showLocationSelector = true,
  }) : super(key: key);

  final bool activeLink;
  final bool showTrending;
  final bool showTypeSelector;
  final bool showLocationSelector;

  @override
  Widget build(BuildContext context) {
    // return Column(
    final notifier = context.read<RedditNotifier>();
    return ListView(
      // controller: ScrollController(),
      shrinkWrap: true,
      // physics: ClampingScrollPhysics(),
      children: [
        // if (showTypeSelector) ...[
        Row(
          children: [
            // DropdownButton(
            //   value: 'HOT POSTS',
            //   items: [
            //     DropdownMenuItem(
            //       onTap: () {},
            //       value: 'HOT POSTS',
            //       child: Text('HOT POSTS'),
            //     ),
            //   ],
            //   onChanged: (_) {},
            // ),
            // Text('HOT POSTS'),
            if (showTypeSelector)
              TextButton(
                child: Text('HOT POSTS'),
                onPressed: () {},
              ),
            if (showLocationSelector)
              TextButton(
                child: Text('GLOBAL'),
                onPressed: () {},
              ),
            Spacer(),
            Text('...'),
          ],
        ),
        SizedBox(height: 50),
        // ],
        if (showTrending) ...[
          Text('Trending today'),

          SizedBox(
            height: 200,
            child: CustomScroll(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  for (int i = 0; i < 10; i++)
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: SizedPlaceholder(width: 200, height: 200 * 3 / 4),
                    ),
                ],
              ),
            ),
          ),

          // PostTile(),
          // PostTile(),
          // PostTile(),
          SizedBox(height: 10),
        ],
        // PostTiles(),
        // for (int i = 0; i < 3; i++)
        for(final sub in notifier.frontBest!)
          Padding(
            padding: scrollPadding,
            child: PostTile(submission: sub, activeLink: activeLink),
          ),
      ],
    );
  }
}
