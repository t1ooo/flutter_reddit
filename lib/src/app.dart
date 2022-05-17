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
      theme: ThemeData(
        primaryColor: Colors.white,
        primarySwatch: white,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: blackColor,
            textStyle: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.all(blackColor),
          overlayColor: MaterialStateProperty.all(blackColor),
        ),
        iconTheme: IconThemeData(color: blackColor),
        appBarTheme: AppBarTheme(
          iconTheme: appBarIconThemeDark,
          elevation: 0,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Colors.white,
          contentTextStyle: TextStyle(color: blackColor),
          behavior: SnackBarBehavior.floating,
        ),
        indicatorColor: selectedColor,
      ),
      home: CustomScroll(
        child: StartScreen(),
      ),
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
