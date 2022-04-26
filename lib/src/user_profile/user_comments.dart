import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/user_profile/user_comment.dart';
import 'package:flutter_reddit_prototype/src/util/snackbar.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../style/style.dart';
import '../widget/loader.v2.dart';

class UserComments extends StatelessWidget {
  const UserComments({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pagePadding,
      // child: Builder(
      //   builder: (context) {
      //     final notifier = context.watch<UserNotifierQ>();
      //     WidgetsBinding.instance?.addPostFrameCallback((_) {
      //       notifier.loadComments();
      //     });
      //     final comments = notifier.comments;
      //     if (comments == null) {
      //       return Center(child: CircularProgressIndicator());
      //     }
      //     return ListView(
      //       children: [
      //         for (final comment in comments)
      //           ChangeNotifierProvider<CommentNotifierQ>.value(
      //             value: comment,
      //             child: UserComment(),
      //           ),
      //       ],
      //     );
      //   },
      // ),
      
      child: Loader<List<CommentNotifierQ>?>(
        load: (context) => context.read<UserNotifierQ>().loadComments(),
        data: (context) => context.read<UserNotifierQ>().comments,
        builder: (context, comments, error) {
          if (error != null) {
            showErrorSnackBar(context, error);
            return Container();
          }
          if (comments == null) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: [
              for (final comment in comments)
                ChangeNotifierProvider<CommentNotifierQ>.value(
                  value: comment,
                  child: UserComment(),
                ),
            ],
          );
        },
      ),

      // child: FutureBuilder(
      //   future: context.read<UserNotifierQ>().loadComments(),
      //   builder: (context, snap) {
      //     if (snap.error != null) {
      //       showErrorSnackBar(context, snap.error!);
      //       return Container();
      //     }
      //     final comments = context.read<UserNotifierQ>().comments;
      //     if (comments == null) {
      //       return Center(child: CircularProgressIndicator());
      //     }
      //     return ListView(
      //       children: [
      //         for (final comment in comments)
      //           ChangeNotifierProvider<CommentNotifierQ>.value(
      //             value: comment,
      //             child: UserComment(),
      //           ),
      //       ],
      //     );
      //   },
      // ),

      // StreamListBuilder(
      //   // stream: context.read<RedditNotifier>().userComments(name),
      //   stream: context.read<UserCommentsNotifier>().comments(),
      //   onData: (context, List<Comment> comments) {
      //     // return Comments(comments:comments);
      //     return ListView(
      //       children: [
      //         for (final comment in comments) UserComment(comment: comment),
      //       ],
      //     );
      //   },
      // ),
    );
  }
}
