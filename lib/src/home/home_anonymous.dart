import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

// TODO: move to home
// TODO: implements login
class HomeAnonymous extends StatelessWidget {
  const HomeAnonymous({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Welcome'),
      Text('Vote'),
      Text('Join'),
      Spacer(),
      ButtonBar(
        alignment:MainAxisAlignment.center,
        children: [
        ElevatedButton(onPressed: () {}, child: Text('Log in')),
        ElevatedButton(onPressed: () {}, child: Text('Sing up')),
      ],),
    ]);
  }
}
