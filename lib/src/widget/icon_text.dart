import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  IconText({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final Icon icon;
  final Text text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        SizedBox(width: 5),
        text,
      ],
    );
  }
}
