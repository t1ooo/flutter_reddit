import 'package:flutter/material.dart';

import '../style/style.dart';

class PrimarySliverAppBar extends StatelessWidget {
  PrimarySliverAppBar({
    Key? key,
    this.flexibleSpace,
    this.elevation = 0,
    this.collapsed = false,
    this.forceElevated = false,
  }) : super(key: key);

  final Widget? flexibleSpace;
  final double elevation;
  final bool collapsed;
  final bool forceElevated;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      primary: true,
      automaticallyImplyLeading: false,
      collapsedHeight: appBarCollapsedHeight,
      expandedHeight: collapsed ? null : appBarExpandedHeight,
      elevation: elevation,
      forceElevated: forceElevated,
      flexibleSpace: flexibleSpace,
    );
  }
}
