import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/submission_loader_notifier.dart';
import '../notifier/submission_notifier.dart';
import '../reply/reply_field.dart';
import '../submission_tile/submission_popup_menu.dart';
import '../util/color.dart';
import '../widget/loader.dart';
import '../widget/sliver_app_bar.dart';
import 'submission.dart';

class SubmissionScreen extends StatelessWidget {
  const SubmissionScreen({
    Key? key,
    this.id,
  }) : super(key: key);

  final String? id;

  @override
  Widget build(BuildContext context) {
    if (id == null) {
      return _SubmissionScreen();
    }

    final notifier = context.watch<SubmissionLoaderNotifier>();

    return Loader<SubmissionNotifier>(
      load: (_) => notifier.loadSubmission(id!),
      data: (_) => notifier.submission,
      onData: (_, submission) {
        return ChangeNotifierProvider<SubmissionNotifier>.value(
          value: submission,
          child: _SubmissionScreen(),
        );
      },
    );
  }
}

class _SubmissionScreen extends StatelessWidget {
  const _SubmissionScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final submission = context.watch<SubmissionNotifier>().submission;

    return Scaffold(
      bottomNavigationBar: ReplyField(),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              PrimarySliverAppBar(
                collapsed: true,
                flexibleSpace: SpaceBar(
                  backgroundColor: generateColor(submission.id),
                  leading: AppBarBackButton(),
                  trailing: SubmissionPopupMenu(fullpage: true),
                ),
              ),
            ];
          },
          body: SubmissionWidget(),
        ),
      ),
    );
  }
}
