import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'network_image.dart';

class CustomPopupMenuItem {
  CustomPopupMenuItem({
    this.icon,
    required this.label,
    required this.onTap,
  });

  final Widget? icon;
  final String label;
  final FutureOr Function() onTap;
}

/// PopupMenuButton doesn't work correctly with navigation
class CustomPopupMenuButton extends StatefulWidget {
  CustomPopupMenuButton({
    Key? key,
    required this.items,
    this.child,
    this.icon,
  }) : super(key: key);

  final List<CustomPopupMenuItem> items;
  final Widget? child;
  final Widget? icon;

  @override
  State<CustomPopupMenuButton> createState() => _CustomPopupMenuButtonState();
}

class _CustomPopupMenuButtonState extends State<CustomPopupMenuButton> {
  final Map<int, bool> enabled = {};

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: widget.icon,
      child: widget.child,
      onSelected: (i) async {
        setState(() {
          enabled[i] = false;
        });
        await widget.items[i].onTap();
        setState(() {
          enabled[i] = true;
        });
      },
      itemBuilder: (context) => [
        for (var i = 0; i < widget.items.length; i++)
          PopupMenuItem(
            value: i,
            enabled: enabled[i] ?? true,
            child: Row(
              children: [
                if (widget.items[i].icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: widget.items[i].icon!,
                  ),
                Text(widget.items[i].label),
              ],
            ),
          ),
      ],
    );
  }
}
