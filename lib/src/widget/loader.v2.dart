import 'dart:async';

import 'package:flutter/material.dart';

import '../util/snackbar.dart';

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

class Loader<T> extends StatelessWidget {
  Loader({
    Key? key,
    required this.load,
    required this.data,
    required this.onData,
    this.onError,
  }) : super(key: key);

  final Future Function(BuildContext) load;
  final T? Function(BuildContext) data;
  // final Widget Function(BuildContext, T, Object?) builder;
  final Widget Function(BuildContext, T) onData;
  final Widget Function(BuildContext, Object)? onError;

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
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget onErrorDefault(context, error) {
    showErrorSnackBar(context, error);
    return Container();
  }
}
