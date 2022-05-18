import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/reddit_api/submission.dart';

import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';

import '../widget/snackbar.dart';
import '../widget/custom_popup_menu_button.dart';

import '../widget/save.dart';

class SubmissionPopupMenu extends StatelessWidget {
  const SubmissionPopupMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubmissionNotifier>();
    final submission = notifier.submission;

    return CustomPopupMenuButton(
      icon: Icon(Icons.more_vert),
      items: [
        savePopupMenuItem(context, notifier),
        CustomPopupMenuItem(
          icon: Icon(
            submission.hidden ? Icons.visibility : Icons.visibility_off,
          ),
          label: submission.hidden ? 'Unhide' : 'Hide',
          onTap: () {
            return (submission.hidden ? notifier.unhide() : notifier.hide())
                .catchError((e) => showErrorSnackBar(context, e));
          },
        ),
        // CustomPopupMenuItem(
        //   icon: Icon(Icons.visibility_off),
        //   label: 'Hide Post',
        //   onTap: () {
        //     showTodoSnackBar(context); // TODO
        //   },
        // ),
        if (kDebugMode)
          CustomPopupMenuItem(
            icon: Icon(Icons.report),
            label: 'Report',
            onTap: () {
              showTodoSnackBar(context); // TODO
            },
          ),
        // if (kDebugMode)
        //   CustomPopupMenuItem(
        //     icon: Icon(Icons.block),
        //     label: 'Block user',
        //     onTap: () {
        //       showTodoSnackBar(context); // TODO
        //     },
        //   ),
      ],
    );
  }
}
