import 'package:flutter/material.dart';

import '../style/style.dart';

class CommentField extends StatelessWidget {
  const CommentField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: pagePadding,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Add a comment',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
