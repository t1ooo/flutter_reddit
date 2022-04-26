import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  WidgetsBinding.instance?.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  });
}

void showErrorSnackBar(BuildContext context, Object error) {
  WidgetsBinding.instance?.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error.toString()),
    ));
  });
}
