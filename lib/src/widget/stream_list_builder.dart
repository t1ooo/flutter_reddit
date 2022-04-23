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
  StreamSubscription<T>? _sub;
  List<T> _list = [];

  @override
  void didUpdateWidget(StreamListBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stream != widget.stream) {
      _list.clear();
      _unsubscribe();
      _subscribe();
    }
  }

  void _subscribe() {
    _sub = widget.stream.listen((T data) {
      setState(() {
        _list.add(data);
      });
    });
  }

  void _unsubscribe() {
    if (_sub != null) {
      _sub!.cancel();
      _sub = null;
    }
  }

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(_list.length);
    if (_list.isNotEmpty) {
      return widget.onData(context, _list);
    }

    return (widget.onLoading ?? onLoadingDefault)(context);
  }

  Widget onLoadingDefault(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
