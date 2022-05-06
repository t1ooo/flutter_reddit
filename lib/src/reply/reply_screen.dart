import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:flutter_reddit_prototype/src/widget/sliver_app_bar.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../util/snackbar.dart';
import '../widget/space_bar.dart';
import 'reply.dart';

class ReplyScreen extends StatefulWidget {
  ReplyScreen({
    Key? key,
    required this.id, // TODO: remove
    this.isComment = false,
  }) : super(key: key);

  final String id;
  final bool isComment;
  // final Function(String) onSubmit;

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
              collapsed:  true,
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

    // return Scaffold(
    //   appBar: AppBar(
    //     automaticallyImplyLeading: false,
    //     // toolbarHeight:
    //     // toolbarHeight: 150,
    //     flexibleSpace: SpaceBar(
    //       leading: AppBarBackButton(),
    //       // title: Text('Add comment', style: TextStyle(fontSize: 18)),
    //       // title: Text('Add comment', style: Theme.of(context).textTheme.titleLarge),
    //       title: AppBarTitle('Add comment'),
    //       // title: Text('Add comment'),
    //       trailing: TextButton(
    //         onPressed: _submit,
    //         // style: ButtonStyle(
    //         //   // overlayColor: MaterialStateProperty.all(Colors.transparent),
    //         //   // padding: MaterialStateProperty.all(EdgeInsets.zero),
    //         //   enableFeedback: false,
    //         // ),
    //         child: Text('POST'),
    //       ),
    //     ),
    //     // title: Text('Add comment'),
    //     // actions: [
    //     //   // IconButton(
    //     //   //   hoverColor: Colors.transparent,
    //     //   //   onPressed: _submit,
    //     //   //   icon: Icon(Icons.add),
    //     //   //   // icon: Text('POST'),
    //     //   // ),
    //     //   //  ElevatedButton(onPressed: _submit,child: Text('POST'),),
    //     //   // InkWell(onTap: _submit,child: Text('POST'),),
    //     //   // TextButton(
    //     //   //   onPressed: _submit,
    //     //   //   // onFocusChange: (_) {},
    //     //   //   style: TextButton.styleFrom(hoverColor:Colors.white),
    //     //   //   child: Text('POST'),
    //     //   // ),
    //     //   TextButton(
    //     //     onPressed: _submit,
    //     //     style: ButtonStyle(
    //     //       // overlayColor: MaterialStateProperty.all(Colors.transparent),
    //     //       // padding: MaterialStateProperty.all(EdgeInsets.zero),
    //     //       enableFeedback: false,
    //     //     ),
    //     //     child: Text('POST'),
    //     //   ),
    //     // ],
    //   ),
    //   body: Container(
    //     color: Theme.of(context).primaryColor,
    //     padding: pagePadding,
    //     child: _form(context),
    //   ),
    // );
  }

  Widget _form(BuildContext context) {
    return ListView(
      children: [
        // SizedBox(height: topPadding),
        Text(
          (widget.isComment)
              ? context.read<CommentNotifierQ>().comment.body
              : context.read<SubmissionNotifierQ>().submission.title,
        ),
        Divider(),
        TextField(
          onChanged: (v) => _message = v,
          onSubmitted: (v) {
            _submit();
          },
          // maxLines: 10,
          // validator: (v) {
          //   if (v == null || v.trim() == '') {
          //     return 'Please enter a message';
          //   }
          //   return null;
          // },
          // expands: true,
          cursorColor: blackColor,
          decoration: InputDecoration(
            hintText: 'You comment',
            border: InputBorder.none,
          ),
        ),
        // ElevatedButton(
        //   onPressed: submit,
        //   child: Text('Post'),
        // ),
      ],
    );
  }

  void _submit() async {
    _message = _message.trim();
    if (_message == '') {
      showErrorSnackBar(context, 'please enter a message');
      return;
    }

    if (widget.isComment) {
      context
          .read<CommentNotifierQ>()
          .reply(_message)
          .catchError((e) => showErrorSnackBar(context, e));
    } else {
      context
          .read<SubmissionNotifierQ>()
          .reply(_message)
          .catchError((e) => showErrorSnackBar(context, e));
    }

    Navigator.pop(context);
  }
}
