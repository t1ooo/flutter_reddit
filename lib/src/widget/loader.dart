import 'dart:async';

import 'package:flutter/material.dart';

class Loader<D, L> extends StatelessWidget {
  Loader({
    Key? key,
    required this.load,
    required this.data,
    required this.builder,
  }) : super(key: key);

  final Future<L> Function() load;
  final D Function() data;
  final Widget Function(BuildContext, D, L?) builder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<L>(
      future: load(),
      builder: (BuildContext context, AsyncSnapshot<L> snap) {
        final error = snap.error;
        if (error != null) {
          throw Exception(error.toString());
        }
        return builder(context, this.data(), snap.data);
      },
    );
  }
}
