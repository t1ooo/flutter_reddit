import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:flutter_reddit_prototype/src/widget/sliver_app_bar.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../util/snackbar.dart';
import '../widget/space_bar.dart';
import 'choose_subreddit_screen.dart';

class SubmitScreen extends StatefulWidget {
  SubmitScreen({
    Key? key,
    // required this.id,
  }) : super(key: key);

  // final String id;

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  String _subreddit = '';
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            PrimarySliverAppBar(
              collapsed: true,
              flexibleSpace: SpaceBar(
                leading: AppBarCloseButton(),
                title: AppBarTitle('Post'),
                trailing: TextButton(
                  onPressed: _submit,
                  child: Text('POST'),
                ),
              ),
            ),
          ];
        },
        body: Container(
          color: Theme.of(context).primaryColor,
          padding: pagePadding,
          child: _form(context),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return ListView(
      children: [
        // SizedBox(height: topPadding),
        // Text(
        //   (widget.isComment)
        //       ? context.read<CommentNotifierQ>().comment.body
        //       : context.read<SubmissionNotifierQ>().submission.title,
        // ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ChangeNotifierProvider<CurrentUserNotifierQ>.value(
                  value: context.read<UserAuth>().user!,
                  child: ChooseSubredditScreen(),
                ),
              ),
            );
          },
          child: Row(
            children: [
              Text('Choose a community'),
              Icon(Icons.expand_more),
            ],
          ),
        ),
        Divider(),
        TextField(
          onChanged: (v) => _message = v,
          onSubmitted: (v) {
            _submit();
          },
          cursorColor: blackColor,
          decoration: InputDecoration(
            hintText: 'You comment',
            border: InputBorder.none,
          ),
        ),
      ],
    );
  }

  void _submit() async {
    _message = _message.trim();
    if (_message == '') {
      showErrorSnackBar(context, 'please enter a message');
      return;
    }

    context
        .read<SubmissionNotifierQ>()
        .reply(_message)
        .catchError((e) => showErrorSnackBar(context, e));

    Navigator.pop(context);
  }
}
