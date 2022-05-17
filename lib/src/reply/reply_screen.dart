import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:flutter_reddit_prototype/src/widget/sliver_app_bar.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../util/snackbar.dart';
import '../widget/space_bar.dart';

class ReplyScreen extends StatefulWidget {
  ReplyScreen({
    Key? key,
    required this.id, // TODO: remove
    this.isComment = false,
  }) : super(key: key);

  final String id;
  final bool isComment;
 

  @override
  State<ReplyScreen> createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
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
                title: AppBarTitle('Add comment'),
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
       
        Text(
          (widget.isComment)
              ? context.read<CommentNotifier>().comment.body
              : context.read<SubmissionNotifier>().submission.title,
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

    (widget.isComment
            ? context.read<CommentNotifier>().reply(_message)
            : context.read<SubmissionNotifier>().reply(_message))
   
   
   
   
    .catchError((e) => showErrorSnackBar(context, e));

   
   
   
   
   
   
   
   
   
   
   
   
   

    Navigator.pop(context);
  }
}
