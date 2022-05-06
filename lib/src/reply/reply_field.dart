import 'package:flutter/material.dart';

import 'reply_screen.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../style/style.dart';

class ReplyField extends StatelessWidget {
  const ReplyField({
    Key? key,
    required this.id, // TODO: remove
  }) : super(key: key);

  final String id;

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
              // MaterialPageRoute(builder: (_) => AddCommentScreen(id: id)),
              MaterialPageRoute(builder: (_) => 
                ChangeNotifierProvider<SubmissionNotifierQ>.value(
                  value: context.read<SubmissionNotifierQ>(),
                  child: ReplyScreen(id: id),
                ),
              ),
            );
          },
          cursorColor: blackColor,
          decoration: InputDecoration(
            hintText: 'Add a comment',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
