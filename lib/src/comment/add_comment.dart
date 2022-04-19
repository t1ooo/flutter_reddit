import 'package:flutter/material.dart';

import '../style/style.dart';

class AddComment extends StatefulWidget {
  const AddComment({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  final Function(String) onSubmit;

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
            if ((v ?? '').trim() == '') {
              return 'Please, enter a message';
            }
            return null;
          },
          decoration: InputDecoration(hintText: 'You comment'),
        ),
        // SizedBox(height: 50),
        // Spacer(),
        ElevatedButton(
          onPressed: () {
            widget.onSubmit(_message);
          },
          child: Text('Post'),
        ),
      ],
    );
  }
}
