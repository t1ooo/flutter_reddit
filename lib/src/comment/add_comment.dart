import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../style/style.dart';
import '../util/snackbar.dart';

class AddComment extends StatefulWidget {
  const AddComment({
    Key? key,
    required this.id,
    this.isComment = false,
  }) : super(key: key);

  final String id;
  final bool isComment;
  // final Function(String) onSubmit;

  @override
  State<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: topPadding),
        Divider(),
        TextFormField(
          onChanged: (v) {
            _message = v.trim();
          },
          onFieldSubmitted: (v) {
            submit();
          },
          maxLines: 10,
          validator: (v) {
            if (v == null || v.trim() == '') {
              return 'Please, enter a message';
            }
            return null;
          },
          decoration: InputDecoration(hintText: 'You comment'),
        ),
        ElevatedButton(
          onPressed: submit,
          child: Text('Post'),
        ),
      ],
    );
  }

  void submit() {
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
