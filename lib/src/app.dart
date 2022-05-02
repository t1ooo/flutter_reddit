import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/login/login_screen.dart';
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
    const black = Colors.black87;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: white,
        // buttonTheme: ButtonThemeData(
        //   buttonColor: black,
        //   textTheme: ButtonTextTheme.primary,
        // ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: black,
            textStyle: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
      ),
      // home: Tabs(),
      home: StartScreen(),
    );
  }
}

final MaterialColor white =
    MaterialColor(Colors.white.value, const <int, Color>{
  50: Colors.white,
  100: Colors.white,
  200: Colors.white,
  300: Colors.white,
  400: Colors.white,
  500: Colors.white,
  600: Colors.white,
  700: Colors.white,
  800: Colors.white,
  900: Colors.white,
});
