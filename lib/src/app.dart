import 'package:flutter/material.dart';

import 'start_screen.dart';
import 'style/style.dart';
import 'widget/custom_scroll.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: CustomScroll(
        child: StartScreen(),
      ),
    );
  }
}
