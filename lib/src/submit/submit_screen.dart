import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/submission_notifier.dart';
import '../notifier/subreddit_notifier.dart';
import '../style.dart';
import '../submission/submission_screen.dart';
import '../subreddit/subreddit_icon.dart';
import '../widget/list.dart';
import '../widget/sliver_app_bar.dart';
import '../widget/snackbar.dart';
import 'choose_subreddit_screen.dart';

class SubmitScreen extends StatefulWidget {
  const SubmitScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  SubredditNotifier? _subreddit;
  String _title = '';
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
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
          color: primaryColor,
          padding: pagePadding,
          child: _form(context),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return CustomListView(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChooseSubredditScreen(onChanged: (v) {
                  // TODO: remove bracket
                  setState(() {
                    _subreddit = v;
                  });
                }),
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
                if (_subreddit != null)
                  Text(_subreddit!.name)
                else
                  Text('Choose a community'),
                Icon(Icons.expand_more),
              ],
            ),
          ),
        ),
        Divider(),
        SizedBox(height: 20),
        TextField(
          onChanged: (v) => _title = v,
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
            builder: (_) => ChangeNotifierProvider<SubmissionNotifier>.value(
              value: s,
              child: SubmissionScreen(),
            ),
          ),
        );
      },
      onError: (e) => showErrorSnackBar(context, e),
    );

    Navigator.pop(context);
  }
}
