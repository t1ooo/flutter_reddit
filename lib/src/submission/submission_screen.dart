import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/util/color.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reply/reply_field.dart';
import '../util/snackbar.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/sliver_app_bar.dart';
import '../widget/space_bar.dart';
import 'submission.dart';

class SubmissionScreen extends StatelessWidget {
  const SubmissionScreen({
    Key? key,
    this.id,
  }) : super(key: key);

  final String? id;

  @override
  Widget build(BuildContext context) {
    return _SubmissionScreen();
  }
}

class _SubmissionScreen extends StatelessWidget {
  const _SubmissionScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          ReplyField(id: context.read<SubmissionNotifier>().submission.id),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              PrimarySliverAppBar(
                collapsed: true,
                flexibleSpace: SpaceBar(
                  backgroundColor: generateColor(
                      context.read<SubmissionNotifier>().submission.id),
                  leading: AppBarBackButton(),
                  trailing: _submissionMenu(context),
                ),
              ),
            ];
          },
          body: SubmissionWidget(),
        ),
      ),
    );
  }

  Widget _submissionMenu(BuildContext context) {
    return CustomPopupMenuButton(
      icon: SpaceBarIcon(Icons.more_vert),
      items: [
        if (kDebugMode)
          CustomPopupMenuItem(
            icon: Icon(Icons.circle),
            label: 'Share',
            onTap: () {
              showTodoSnackBar(context); // TODO
            },
          ),
        if (kDebugMode)
          CustomPopupMenuItem(
            icon: Icon(Icons.circle),
            label: 'Hide post',
            onTap: () {
              showTodoSnackBar(context); // TODO
            },
          ),
        if (kDebugMode)
          CustomPopupMenuItem(
            icon: Icon(Icons.circle),
            label: 'Report',
            onTap: () {
              showTodoSnackBar(context); // TODO
            },
          ),
        if (kDebugMode)
          CustomPopupMenuItem(
            icon: Icon(Icons.circle),
            label: 'Block user',
            onTap: () {
              showTodoSnackBar(context); // TODO
            },
          ),
      ],
    );
  }
}
