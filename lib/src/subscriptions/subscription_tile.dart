import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:flutter_reddit_prototype/src/subreddit/subreddit_icon.dart';
import 'package:flutter_reddit_prototype/src/util/snackbar.dart';

import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../subreddit/subreddit_screen.dart';
import '../widget/list.dart';
import '../widget/loader.dart';
import '../widget/network_image.dart';

class SubscriptionTile extends StatelessWidget {
  const SubscriptionTile({
    Key? key,
    this.favorite=true
  }) : super(key: key);

  final bool favorite;

  Widget build(BuildContext context) {
    final notifier = context.watch<SubredditNotifierQ>();
    final subreddit = notifier.subreddit;

    return ListTile(
      leading: SizedBox.square(
        dimension: 40,
        child: SubredditIcon(icon: subreddit.communityIcon),
        // child: (subreddit.subreddit.communityIcon != '')
        // ? CustomNetworkImageBuilder(
        // subreddit.subreddit.communityIcon)
        // : Image.asset('communityIcon.png'),
      ),
      title: Text(subreddit.displayNamePrefixed),
      trailing: favorite ? IconButton(
        onPressed: () {
          (subreddit.userHasFavorited
                  ? notifier.unfavorite()
                  : notifier.favorite())
              .then(
            (_) => context.read<CurrentUserNotifierQ>().refresh(),
            onError: (e) => showErrorSnackBar(context, e),
          );
        } ,
        icon: Icon(Icons.star,
            color: subreddit.userHasFavorited ? selectedColor : null),
      ): null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<SubredditNotifierQ>.value(
              value: notifier,
              child: SubredditScreen(),
            ),
          ),
        );
      },
    );
  }
}