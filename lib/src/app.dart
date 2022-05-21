import 'package:flutter/material.dart';

import 'start_screen.dart';
import 'style.dart';
import 'widget/custom_scroll.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reddit App',
      theme: theme,
      home: CustomScroll(
        child: StartScreen(),
      ),
    );
  }
}
