import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget whenDebug(Widget Function() builder) {
  return kDebugMode
      ? Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
          ),
          child: builder(),
        )
      : Container();
}
