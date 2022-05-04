import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../search/search_screen.dart';
import '../style/style.dart';
import 'network_image.dart';

class PrimarySliverAppBar extends StatelessWidget {
  PrimarySliverAppBar({
    Key? key,
    this.flexibleSpace,
  }) : super(key: key);

  final Widget? flexibleSpace;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      primary: true,
      automaticallyImplyLeading: false,
      collapsedHeight: 120,
      expandedHeight: appBarExpandedHeight,
      flexibleSpace: flexibleSpace,
    );
  }
}
