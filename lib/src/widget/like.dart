import 'package:flutter/material.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/like.dart';
import '../util/snackbar.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({
    Key? key,
    required this.likable,
  }) : super(key: key);

  final Likable likable;

  @override
  Widget build(BuildContext context) {
    return Row(
    children: [
      IconButton(
        onPressed: () {
          likable.like().catchError((e) => showErrorSnackBar(context, e));
        },
        icon: Icon(
          Icons.expand_less,
          color: likable.likes == Like.up ? Colors.green : null,
        ),
      ),
      Text(likable.score.toString()),
      // TODO: disable on progress
      IconButton(
        onPressed: () {
          likable.dislike().catchError((e) => showErrorSnackBar(context, e));
        },
        icon: Icon(
          Icons.expand_more,
          color: likable.likes == Like.down ? Colors.red : null,
        ),
      ),
    ],
  );
  }
}

// Widget likeButton(BuildContext context, Likable likable) {
//   return Row(
//     children: [
//       IconButton(
//         onPressed: () {
//           likable.like().catchError((e) => showErrorSnackBar(context, e));
//         },
//         icon: Icon(
//           Icons.expand_less,
//           color: likable.likes == Like.up ? Colors.green : null,
//         ),
//       ),
//       Text(likable.score.toString()),
//       // TODO: disable on progress
//       IconButton(
//         onPressed: () {
//           likable.dislike().catchError((e) => showErrorSnackBar(context, e));
//         },
//         icon: Icon(
//           Icons.expand_more,
//           color: likable.likes == Like.down ? Colors.red : null,
//         ),
//       ),
//     ],
//   );
// }
