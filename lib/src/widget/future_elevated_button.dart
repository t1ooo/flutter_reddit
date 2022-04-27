import 'dart:async';

import 'package:flutter/material.dart';

typedef FutureVoidCallback = Future<void> Function();

// TODO: remove unnessery fields
/// auto disabled during onPressed and onLongPress
class FutureElevatedButton extends StatefulWidget {
  const FutureElevatedButton({
    Key? key,
    this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.child,
  }) : super(key: key);

  // final Key? key;
  final FutureVoidCallback? onPressed;
  final FutureVoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip clipBehavior;
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
      onPressed: _disabled ? null : () => _call(widget.onPressed),
      onLongPress: _disabled ? null : () => _call(widget.onLongPress),
      onHover: widget.onHover,
      onFocusChange: widget.onFocusChange,
      style: widget.style,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      clipBehavior: widget.clipBehavior,
      child: widget.child,
    );
  }

  Future<void> _call(FutureVoidCallback? fn) async {
    if (fn == null) return;
    setState(() => _disabled = true);
    await fn();
    setState(() => _disabled = false);
  }

  // Future<void> _onPressed() async {
  //   final fn = widget.onPressed;

  //   if (fn == null) return;

  //   setState(() {
  //     _disabled = true;
  //   });
  //   await fn();
  //   setState(() {
  //     _disabled = false;
  //   });
  // }

  // Future<void> _onLongPress() async {
  //   final fn = widget.onLongPress;

  //   if (fn == null) return;

  //   setState(() {
  //     _disabled = true;
  //   });
  //   await fn();
  //   setState(() {
  //     _disabled = false;
  //   });
  // }
}
