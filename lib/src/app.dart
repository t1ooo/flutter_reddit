import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/home/home_screen.dart';

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
      // home: HomeScreen(),
      home: Tabs(),
    );
  }
}
