import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/style/style.dart';

import 'add_comment.dart';

class AddCommentScreen extends StatelessWidget {
  const AddCommentScreen({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  final Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add comment'),
        // actions: [
        //   ElevatedButton(
        //     // textColor: Colors.white,
        //     onPressed: () {},
        //     child: Text('Post'),
        //     // shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
        //   ),
        // ],
      ),
      body: Padding(
        padding: pagePadding,
        child: AddComment(onSubmit:onSubmit),
      ),
      /* bottomNavigationBar: Padding(
        padding: pagePadding.copyWith(bottom: 20),
        child: ElevatedButton(
          onPressed: () {},
          child: Text('Post'),
        ),
      ), */
    );
  }
}
