import 'package:flutter/material.dart';

typedef FutureVoidCallback = Future<void> Function();

/// pass onPressed argument to the builder or null when onPressed is executed
class AsyncButtonBuilder extends StatefulWidget {
  const AsyncButtonBuilder({
    Key? key,
    required this.onPressed,
    required this.builder,
  }) : super(key: key);

  final FutureVoidCallback onPressed;
  final Widget Function(BuildContext, FutureVoidCallback?) builder;

  @override
  State<AsyncButtonBuilder> createState() => _AsyncButtonBuilderState();
}

class _AsyncButtonBuilderState extends State<AsyncButtonBuilder> {
  bool _disabled = false;

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _disabled ? null : _onPressed);
  }

  Future<void> _onPressed() async {
    setState(() => _disabled = true);
    await widget.onPressed();
    setState(() => _disabled = false);
  }
}
