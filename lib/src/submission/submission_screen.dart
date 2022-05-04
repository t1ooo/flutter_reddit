import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../comment/comment_field.dart';
import '../util/snackbar.dart';
import '../widget/custom_popup_menu_button.dart';
import '../widget/loader.dart';
import '../widget/sliver_app_bar.dart';
import '../widget/space_bar.dart';
import 'submission.dart';

// class SubmissionScreen extends StatelessWidget {
//   const SubmissionScreen({
//     Key? key,
//     required this.id,
//   }) : super(key: key);

//   final String id;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Submission'),
//       ),
//       body: body(context),
//       bottomNavigationBar: CommentField(id: id),
//     );
//   }

//   Widget body(BuildContext context) {
//     final notifier = context.watch<SubmissionLoaderNotifierQ>();

//     return Loader<SubmissionNotifierQ>(
//       load: (_) => notifier.loadSubmission(id),
//       data: (_) => notifier.submission,
//       onData: (_, submission) {
//         return ChangeNotifierProvider<SubmissionNotifierQ>.value(
//           value: submission,
//           child: SubmissionWidget(),
//         );
//       },
//     );
//   }
// }

class SubmissionScreen extends StatelessWidget {
  const SubmissionScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CommentField(id: id),
      body: DefaultTabController(
        length: 2, // This is the number of tabs.
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              PrimarySliverAppBar(
                flexibleSpace: SpaceBar(
                  leading: SearchBackButton(),
                  trailing: _submissionMenu(context),
                  // title: Text('Saved'),
                ),
              ),
            ];
          },
          body: body(context),
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    final notifier = context.watch<SubmissionLoaderNotifierQ>();

    return Loader<SubmissionNotifierQ>(
      load: (_) => notifier.loadSubmission(id),
      data: (_) => notifier.submission,
      onData: (_, submission) {
        return ChangeNotifierProvider<SubmissionNotifierQ>.value(
          value: submission,
          child: SubmissionWidget(),
        );
      },
    );
  }

  Widget _submissionMenu(BuildContext context) {
    return CustomPopupMenuButton(
      // icon: IconTheme(data: appBarIconTheme, child: Icon(Icons.more_vert)),
      // icon: Icon(Icons.more_vert),
      // icon: Icon(Icons.more_vert),
      icon : SpaceBarIcon(Icons.more_vert),
      items: [
        CustomPopupMenuItem(
          icon: Icon(Icons.report),
          label: 'Share',
          onTap: () {
            showTodoSnackBar(context); // TODO
          },
        ),
        CustomPopupMenuItem(
          icon: Icon(Icons.block),
          label: 'Block user',
          onTap: () {
            showTodoSnackBar(context); // TODO
          },
        ),
      ],
    );
  }
}
