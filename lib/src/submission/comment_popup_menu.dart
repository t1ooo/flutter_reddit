import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/util/date_time.dart';
import 'package:provider/provider.dart';

import '../reply/reply_screen.dart';
import '../notifier/reddir_notifier.v4_2.dart';
import '../style/style.dart';
import '../user_profile/user_profile_screen.dart';
import '../widget/awards.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/like.dart';
import '../widget/save.dart';

class CommentPopupMenu extends StatelessWidget {
  const CommentPopupMenu({
    Key? key,
    this.showCollapse = true,
  }) : super(key: key);

  final bool showCollapse;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<CommentNotifier>();

    return CustomPopupMenuButton(
      icon: Icon(Icons.more_vert),
      items: [
        savePopupMenuItem(context, notifier),

        CustomPopupMenuItem(
          icon: Icon(Icons.share),
          label: 'Share',
          onTap: () async {
            return notifier.share();
          },
        ),

        CustomPopupMenuItem(
          icon: Icon(Icons.content_copy),
          label: 'Copy Text',
          onTap: () async {
            return notifier.copyText();
          },
        ),

        if (showCollapse)
          CustomPopupMenuItem(
            icon: Icon(Icons.expand_less),
            label: 'Collapse thread',
            onTap: () {
              notifier.collapse();
            },
          ),

        // TODO
        CustomPopupMenuItem(
            icon: Icon(Icons.circle), label: 'Report', onTap: () {}),
        // CustomPopupMenuItem(
        // icon: Icon(Icons.circle), label: 'Block user', onTap: () {}),
      ],
    );
  }
}
