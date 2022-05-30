import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({
    Key? key,
    required this.children,
    this.padding = EdgeInsets.zero,
    this.shrinkWrap = true,
  }) : super(key: key);

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: key,
      primary: false,
      padding: padding,
      shrinkWrap: shrinkWrap,
      children: children,
    );
  }
}

class ListTitle extends StatelessWidget {
  const ListTitle(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ListDivider extends StatelessWidget {
  const ListDivider({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: height,
    );
  }
}
