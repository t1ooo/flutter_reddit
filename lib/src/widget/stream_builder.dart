import 'dart:async';

import 'package:flutter/material.dart';

class CustomStreamBuilder<T> extends StatelessWidget {
  const CustomStreamBuilder({
    Key? key,
    required this.stream,
    required this.onData,
    this.onError,
    this.onLoading,
  }) : super(key: key);

  final Stream<T> stream;
  final Widget Function(BuildContext, T) onData;
  final Widget Function(BuildContext, Object)? onError;
  final Widget Function(BuildContext)? onLoading;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
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


class StreamList<T> extends StatefulWidget {
  StreamList({
    Key? key,
    required this.stream,
    required this.onData,
  }) : super(key: key);

  final Stream<T> stream;
  final Widget Function(BuildContext, List<T>) onData;

  @override
  State<StreamList<T>> createState() => _StreamListState<T>();
}

class _StreamListState<T> extends State<StreamList<T>> {
  late StreamSubscription<T> _sub;
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
    return widget.onData(context, _list);
  }
}
