import 'dart:async';

import 'package:flutter/material.dart';

import 'snackbar.dart';

class Loader<T> extends StatelessWidget {
  const Loader({
    Key? key,
    required this.load,
    required this.data,
    required this.onData,
    this.onError,
    this.onLoading,
  }) : super(key: key);

  final Future<dynamic> Function(BuildContext) load;
  final T? Function(BuildContext) data;

  final Widget Function(BuildContext, T) onData;
  final Widget Function(BuildContext, Object)? onError;
  final Widget Function(BuildContext)? onLoading;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: load(context),
      builder: (context, snap) {
        final error = snap.error;
        if (error != null) {
          return (onError ?? onErrorDefault)(context, error);
        }
        final data = this.data(context);
        if (data != null) {
          return onData(context, data);
        }
        return (onLoading ?? onLoadingDefault)(context);
      },
    );
  }

  Widget onErrorDefault(BuildContext context, Object error) {
    showErrorSnackBar(context, error);
    return Container();
  }

  Widget onLoadingDefault(BuildContext context) {
    return context.findAncestorStateOfType<ScaffoldState>() == null
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Center(child: CircularProgressIndicator());
  }
}

class LoaderBuilder<T> extends StatelessWidget {
  const LoaderBuilder({
    Key? key,
    required this.load,
    required this.data,
    required this.builder,
  }) : super(key: key);

  final Future<dynamic> Function(BuildContext) load;
  final T Function(BuildContext) data;
  final Widget Function(BuildContext, T, Object?) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: load(context),
      builder: (context, snap) {
        return builder(context, data(context), snap.error);
      },
    );
  }
}
