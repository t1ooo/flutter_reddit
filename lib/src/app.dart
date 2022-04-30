import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/login_v2/login_screen.dart';
import 'package:flutter_reddit_prototype/src/util/snackbar.dart';
import 'package:flutter_reddit_prototype/src/widget/custom_future_builder.dart';
import 'package:provider/provider.dart';

import 'notifier/reddir_notifier.v4_2.dart';
import 'start_screen.dart';
import 'tabs.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: Tabs(),
      home: StartScreen(),
    );
  }
}
