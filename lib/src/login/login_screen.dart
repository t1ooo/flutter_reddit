import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';

import 'login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoginScreen'),
      ),
      body: Padding(
        padding: pagePadding,
        child: Login(),
      ),
    );
  }
}
