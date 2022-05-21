import 'package:flutter/material.dart';

const blackColor = Colors.black87;
const pagePadding = EdgeInsets.symmetric(horizontal: 20);
const cardPadding = EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20);
const topPadding = 20.0;
const iconSize = 50.0;
const selectedColor = Colors.blue;
const appBarIconThemeDark = IconThemeData(color: blackColor, size: 30);
const formIconTheme = IconThemeData(color: Colors.black54);
const appBarCollapsedHeight = 120.0;
const appBarExpandedHeight = 200.0;

final white = MaterialColor(Colors.white.value, const <int, Color>{
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

final theme = ThemeData(
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
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: blackColor,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(color: selectedColor),
);
