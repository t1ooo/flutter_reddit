import 'dart:async';

import 'package:flutter/material.dart';

class Loader<T> extends StatelessWidget {
  Loader({
    Key? key,
    required this.load,
    required this.data,
    required this.builder,
  }) : super(key: key);

  final Future Function(BuildContext) load;
  final T Function(BuildContext) data;
  final Widget Function(BuildContext, T,  Object?) builder;

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
