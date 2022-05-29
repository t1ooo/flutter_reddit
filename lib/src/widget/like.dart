import 'package:flutter/material.dart';

import '../notifier/likable.dart';
import '../reddit_api/like.dart';
import 'async_button_builder.dart';
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
        AsyncButtonBuilder(
          onPressed: () =>
              likable.like().catchError((e) => showErrorSnackBar(context, e)),
          builder: (_, onPressed) {
            return IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.expand_less,
                color: likable.likes == Like.up ? Colors.green : null,
              ),
            );
          },
        ),
        Text(_formatScore(likable.score)),
        AsyncButtonBuilder(
          onPressed: () => likable
              .dislike()
              .catchError((e) => showErrorSnackBar(context, e)),
          builder: (_, onPressed) {
            return IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.expand_more,
                color: likable.likes == Like.down ? Colors.red : null,
              ),
            );
          },
        ),
      ],
    );
  }

  String _formatScore(int score) {
    if (score < 1000) {
      return score.toString();
    }
    return '${(score * 10 / 1000).ceil() / 10}k';
  }
}
