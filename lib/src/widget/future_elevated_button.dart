import 'dart:async';

import 'package:flutter/material.dart';

typedef FutureVoidCallback = Future<void> Function();

class FutureElevatedButton extends StatefulWidget {
  const FutureElevatedButton({
    Key? key,
    required this.onPressed,
    this.style,
    this.child,
  }) : super(key: key);

  final FutureVoidCallback onPressed;
  final ButtonStyle? style;
  final Widget? child;

  @override
  State<FutureElevatedButton> createState() => _FutureElevatedButtonState();
}

class _FutureElevatedButtonState extends State<FutureElevatedButton> {
  bool _disabled = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: widget.key,
      onPressed: _disabled ? null : () => _onPressed(),
      style: widget.style,
      child: widget.child,
    );
  }

  Future<void> _onPressed() async {
    setState(() => _disabled = true);
    await widget.onPressed();
    setState(() => _disabled = false);
  }
}
