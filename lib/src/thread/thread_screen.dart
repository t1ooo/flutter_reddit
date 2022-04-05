import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import 'thread.dart';

class ThreadScreen extends StatelessWidget {
  const ThreadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thread'),
      ),
      body: Thread(),
    );
  }
}
