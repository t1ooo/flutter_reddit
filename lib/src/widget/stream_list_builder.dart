import 'dart:async';

import 'package:flutter/material.dart';

class StreamListBuilder<T> extends StatefulWidget {
  StreamListBuilder({
    Key? key,
    required this.stream,
    required this.onData,
    this.onLoading,
  }) : super(key: key);

  final Stream<T> stream;
  final Widget Function(BuildContext, List<T>) onData;
  final Widget Function(BuildContext)? onLoading;

  @override
  State<StreamListBuilder<T>> createState() => _StreamListBuilderState<T>();
}

class _StreamListBuilderState<T> extends State<StreamListBuilder<T>> {
  late StreamSubscription<T>? _sub;
  List<T> _list = [];

  @override
  void initState() {
    super.initState();
    _sub = widget.stream.listen((T data) {
      setState(() {
        _list.add(data);
      });
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_list.isNotEmpty) {
      return widget.onData(context, _list);
    }

    return (widget.onLoading ?? onLoadingDefault)(context);
  }

  Widget onLoadingDefault(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
