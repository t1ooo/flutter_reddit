import 'package:flutter/material.dart';

const _margin = EdgeInsets.only(left: 20, right: 20, bottom: 20);

// void showSnackBar(BuildContext context, String text) {
//   WidgetsBinding.instance?.addPostFrameCallback((_) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(text),
//     ));
//   });
// }

void showErrorSnackBar(BuildContext context, Object error) {
  WidgetsBinding.instance?.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: _margin,
      backgroundColor: Colors.red[100],
      content: Text(error.toString()),
    ));
  });
}

void showTodoSnackBar(BuildContext context) {
  WidgetsBinding.instance?.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: _margin,
      content: Text('TODO'),
    ));
  });
}
