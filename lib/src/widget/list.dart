import 'package:flutter/material.dart';

import '../style.dart';

class PrimaryColorListView extends StatelessWidget {
  const PrimaryColorListView({
    Key? key,
    required this.children,
    this.padding,
  }) : super(key: key);

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      padding: padding,
      child: CustomListView(
        key: key,
        children: children,
      ),
    );
  }
}

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

//   @override
//   State<CustomListView> createState() => _CustomListViewState();
// }

// class _CustomListViewState extends State<CustomListView> {
//   late final ScrollController _controller;

//   @override
//   void initState() {
//     _controller = ScrollController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

  @override
  Widget build(BuildContext context) {
    return ListView(
      // controller: _controller,
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
