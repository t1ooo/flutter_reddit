import 'package:flutter/material.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/like.dart';
import 'snackbar.dart';

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
        Text(_formatScore(likable.score)),
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

  String _formatScore(int score) {
    if (score < 1000) {
      return score.toString();
    }
    return ((score * 10 / 1000).ceil() / 10).toString() + 'k';
  }
}
