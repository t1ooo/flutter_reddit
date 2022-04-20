import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.dart';
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
        Text('Making food on the street'),
        SizedBox(height: 10),
        Divider(),
        TextFormField(
          onChanged: (v) {
            _message = v.trim();
          },
          onFieldSubmitted: (v) {
            print(1);
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
        // SizedBox(height: 50),
        // Spacer(),
        ElevatedButton(
          onPressed: () async {
            // if (widget.isComment) {
            //   context.read<SubmissionNotifier>().commentReply(widget.id, _message);
            // } else {
            //   context
            //       .read<SubmissionNotifier>()
            //       .submissionReply(widget.id, _message);
            // }

            final notifer = context.read<SubmissionNotifier>();
            final result = await (widget.isComment
                ? notifer.commentReply(widget.id, _message)
                : notifer.submissionReply(widget.id, _message));
            if (result != null) {
              showSnackBar(context, result);
            }
            Navigator.pop(context);
          },
          child: Text('Post'),
        ),
      ],
    );
  }
}
