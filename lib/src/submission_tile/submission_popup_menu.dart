import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/reddit_api/submission.dart';

import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';

import '../report/report_screen.dart';
import '../widget/snackbar.dart';
import '../widget/custom_popup_menu_button.dart';

import '../widget/save.dart';

class SubmissionPopupMenu extends StatelessWidget {
  const SubmissionPopupMenu({
    Key? key,
    this.fullpage = false,
  }) : super(key: key);

  final bool fullpage;

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
            // return (submission.hidden ? notifier.unhide() : notifier.hide())
            //     .catchError((e) => showErrorSnackBar(context, e));

            final hidden = submission.hidden;
            return (submission.hidden ? notifier.unhide() : notifier.hide())
                .then(
              (_) {
                if (!hidden && fullpage) Navigator.pop(context);
              },
              onError: (e) => (e) => showErrorSnackBar(context, e),
            );

            // return submission.hidden
            //     ? notifier
            //         .unhide()
            //         .catchError((e) => showErrorSnackBar(context, e))
            //     : notifier.hide().then((_) {
            //         if (popOnHide) Navigator.pop(context);
            //       }, onError: (e) => (e) => showErrorSnackBar(context, e));
          },
        ),
        // CustomPopupMenuItem(
        //   icon: Icon(Icons.visibility_off),
        //   label: 'Hide Post',
        //   onTap: () {
        //     showTodoSnackBar(context); // TODO
        //   },
        // ),

        CustomPopupMenuItem(
          icon: Icon(Icons.report),
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
