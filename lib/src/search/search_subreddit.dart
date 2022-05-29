import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/subreddit_notifier.dart';
import '../style.dart';
import '../subreddit/subreddit_icon.dart';
import '../widget/async_button_builder.dart';
import '../widget/snackbar.dart';

class SearchSubreddit extends StatelessWidget {
  const SearchSubreddit({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifier>();
    final subreddit = notifier.subreddit;

    return ListTile(
      leading: SizedBox.square(
        dimension: 40,
        child: SubredditIcon(icon: subreddit.communityIcon),
      ),
      title: Text(notifier.name),
      subtitle: Text('${subreddit.subscribers} members'),
      trailing: AsyncButtonBuilder(
        onPressed: () => notifier
            .subscribe(!subreddit.userIsSubscriber)
            .catchError((e) => showErrorSnackBar(context, e)),
        builder: (context, onPressed) => IconButton(
          onPressed: onPressed,
          icon: Icon(
            subreddit.userIsSubscriber ? Icons.check_box : Icons.add_box,
            color: selectedColor,
          ),
        ),
      ),
    );
  }
}
