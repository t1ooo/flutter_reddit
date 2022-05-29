import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/comment_notifier.dart';
import '../notifier/reportable.dart';
import '../report/report_screen.dart';
import '../widget/custom_popup_menu_button.dart';
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
          onTap: () => notifier.share(),
        ),
        CustomPopupMenuItem(
          icon: Icon(Icons.content_copy),
          label: 'Copy Text',
          onTap: () => notifier.copyText(),
        ),
        if (showCollapse)
          CustomPopupMenuItem(
            icon: Icon(Icons.expand_less),
            label: 'Collapse thread',
            onTap: () => notifier.collapse(),
          ),
        CustomPopupMenuItem(
          icon: Icon(Icons.circle),
          label: 'Report',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InheritedProvider<Reportable>.value(
                  value: notifier,
                  child: ReportScreen(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
