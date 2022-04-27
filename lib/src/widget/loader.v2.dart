import 'dart:async';

import 'package:flutter/material.dart';

import '../util/snackbar.dart';

class Loader<T> extends StatelessWidget {
  Loader({
    Key? key,
    required this.load,
    required this.data,
    required this.onData,
    this.onError,
    this.onLoading,
  }) : super(key: key);

  final Future Function(BuildContext) load;
  final T? Function(BuildContext) data;
  // final Widget Function(BuildContext, T, Object?) builder;
  final Widget Function(BuildContext, T) onData;
  final Widget Function(BuildContext, Object)? onError;
  final Widget Function(BuildContext)? onLoading;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: load(context),
      builder: (BuildContext context, AsyncSnapshot snap) {
        // return builder(context, this.data(context), snap.error);
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

  Widget onErrorDefault(context, error) {
    showErrorSnackBar(context, error);
    return Container();
  }

  Widget onLoadingDefault(context) {
    return Center(child: CircularProgressIndicator());
  }
}

class LoaderBuilder<T> extends StatelessWidget {
  LoaderBuilder({
    Key? key,
    required this.load,
    required this.data,
    required this.builder,
  }) : super(key: key);

  final Future Function(BuildContext) load;
  final T Function(BuildContext) data;
  final Widget Function(BuildContext, T, Object?) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: load(context),
      builder: (BuildContext context, AsyncSnapshot snap) {
        return builder(context, this.data(context), snap.error);
      },
    );
  }
}
