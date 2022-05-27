import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/replyable.dart';
import '../notifier/submission_notifier.dart';
import '../style.dart';
import 'reply_screen.dart';

class ReplyField extends StatelessWidget {
  const ReplyField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: pagePadding.copyWith(top: 10, bottom: 10),
        child: TextField(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InheritedProvider<Replyable>.value(
                  value: context.read<SubmissionNotifier>(),
                  child: ReplyScreen(),
                ),
              ),
            );
          },
          decoration: InputDecoration(
            hintText: 'Add a comment',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
