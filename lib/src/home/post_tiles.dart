import 'package:flutter/material.dart';

import '../style/style.dart';
import '../thread/post_screen.dart';
import '../user_profile/user_profile_screen.dart';
import '../widget/sized_placeholder.dart';
import 'post_tile.dart';

class PostTiles extends StatelessWidget {
  const PostTiles({
    Key? key,
    this.activeLink = true,
  }) : super(key: key);

  final bool activeLink;

  @override
  Widget build(BuildContext context) {
    // return Column(
    return ListView(
      // controller: ScrollController(),
      shrinkWrap: true,
      // physics: ClampingScrollPhysics(),
      children: [
        Padding(
          padding: scrollPadding,
          child: PostTile(activeLink: activeLink),
        ),
        Padding(
          padding: scrollPadding,
          child: PostTile(activeLink: activeLink),
        ),
        Padding(
          padding: scrollPadding,
          child: PostTile(activeLink: activeLink),
        ),
      ],
    );
  }
}
