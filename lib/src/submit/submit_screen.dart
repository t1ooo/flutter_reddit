import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:flutter_reddit_prototype/src/submission/submission_screen.dart';
import 'package:flutter_reddit_prototype/src/widget/sliver_app_bar.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../reddit_api/subreddit.dart';
import '../subreddit/subreddit_icon.dart';
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
  SubredditNotifierQ? _subreddit;
  String _title = '';
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            PrimarySliverAppBar(
              // forceElevated: true,
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
                  child: ChooseSubredditScreen(onChanged: (v) {
                    setState(() {
                      _subreddit = v;
                    });
                  }),
                ),
              ),
            );
          },
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: SizedBox.square(
                dimension: 40,
                child: SubredditIcon(
                    icon: _subreddit?.subreddit.communityIcon ?? '')),
            title: Row(
              children: [
                _subreddit != null
                    ? Text(_subreddit!.name)
                    : Text('Choose a community'),
                Icon(Icons.expand_more),
              ],
            ),
          ),
        ),
        Divider(),
        SizedBox(height: 20),
        TextField(
          onChanged: (v) => _title = v,
          // onSubmitted: (v) {
          //   _submit();
          // },
          cursorColor: blackColor,
          decoration: InputDecoration(
            hintText: 'An interesting title',
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.characters,
        ),
        Divider(),
        SizedBox(height: 20),
        TextField(
          onChanged: (v) => _message = v,
          onSubmitted: (v) {
            _submit();
          },
          cursorColor: blackColor,
          decoration: InputDecoration(
            hintText: 'You text post(optional)',
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  void _submit() async {
    if (_subreddit == null) {
      showErrorSnackBar(context, 'please select a community');
      return;
    }

    _title = _title.trim();
    if (_title == '') {
      showErrorSnackBar(context, 'please enter a title');
      return;
    }

    _message = _message.trim();

    _subreddit!.submit(title: _title).then(
      (s) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return ChangeNotifierProvider<SubmissionNotifierQ>.value(
                value: s,
                child: SubmissionScreen(),
              );
            },
          ),
        );
      },
      onError: (e) => showErrorSnackBar(context, e),
    );
    // .catchError((e) => showErrorSnackBar(context, e));

    Navigator.pop(context);
  }
}
