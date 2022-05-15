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

void catchFutureError(BuildContext context, Future future) {
  future.catchError((e) => showErrorSnackBar(context, e));
}

// class ErrorSnackBar extends StatelessWidget {
//   const ErrorSnackBar(
//     this.error, {
//     Key? key,
//   }) : super(key: key);

//   final Object error;

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance?.addPostFrameCallback((_) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         margin: _margin,
//         backgroundColor: Colors.red[100],
//         content: Text(error.toString()),
//       ));
//     });
//     return Container();
//   }
// }
