import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'network_image.dart';

class CustomListView extends StatelessWidget {
  CustomListView({
    Key? key,
    required this.children,
    this.padding,
  }) : super(key: key);

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: padding,
      child: ListView(
        shrinkWrap: true,
        children: children,
      ),
    );
  }
}

class ListTitle extends StatelessWidget {
  ListTitle(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 40,
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
  ListDivider({
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
