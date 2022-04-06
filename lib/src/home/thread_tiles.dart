import 'package:flutter/material.dart';

import '../style/style.dart';
import '../thread/thread_screen.dart';
import '../user_profile/user_profile_screen.dart';
import '../widget/sized_placeholder.dart';
import 'thread_tile.dart';

class ThreadTiles extends StatelessWidget {
  const ThreadTiles({
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
          padding: const EdgeInsets.all(20),
          child: ThreadTile(activeLink:activeLink),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: ThreadTile(activeLink:activeLink),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: ThreadTile(activeLink:activeLink),
        ),
      ],
    );
  }
}
