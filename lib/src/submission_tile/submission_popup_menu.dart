import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reportable.dart';
import '../notifier/submission_notifier.dart';
import '../report/report_screen.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/save.dart';
import '../widget/snackbar.dart';

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

            // final hidden = submission.hidden;
            // return (submission.hidden ? notifier.unhide() : notifier.hide())
            //     .then(
            //   (_) {
            //     if (!hidden && fullpage) Navigator.pop(context);
            //   },
            //   onError: (e) => (e) => showErrorSnackBar(context, e),
            // );

            // final catchError = (e) => showErrorSnackBar(context, e);

            // return submission.hidden
            //     ? notifier.unhide().catchError(catchError)
            //     : notifier.hide().then((_) {
            //         if (fullpage) Navigator.pop(context);
            //       }, onError: catchError);

            // return (submission.hidden
            //         ? notifier.unhide()
            //         : notifier.hide().then((_) {
            //             if (fullpage) Navigator.pop(context);
            //           }))
            //     .catchError((e) => showErrorSnackBar(context, e));

            return notifier.hide(!submission.hidden).then(
              (_) {
                if (fullpage && submission.hidden) Navigator.pop(context);
              },
              onError: (e) => showErrorSnackBar(context, e),
            );
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
