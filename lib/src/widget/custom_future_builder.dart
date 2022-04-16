import 'dart:async';

import 'package:flutter/material.dart';

// Widget voidError(_, __) => Container();

class CustomFutureBuilder<T> extends StatelessWidget {
  const CustomFutureBuilder({
    Key? key,
    required this.future,
    required this.onData,
    this.onError,
    this.onLoading,
  }) : super(key: key);

  final Future<T> future;
  final Widget Function(BuildContext, T) onData;
  final Widget Function(BuildContext, Object)? onError;
  final Widget Function(BuildContext)? onLoading;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<T> snap) {
        final error = snap.error;
        if (error != null) {
          return (onError ?? onErrorDefault)(context, error);
        }

        final data = snap.data;
        if (data != null) {
          // print(data);
          return onData(context, data);
        }

        return (onLoading ?? onLoadingDefault)(context);
      },
    );
  }

  Widget onErrorDefault(BuildContext context, Object error) {
    return Text(error.toString());
  }

  Widget onLoadingDefault(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
