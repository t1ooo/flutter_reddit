import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/notifier/reddir_notifier.v4_2.dart';

import '../util/snackbar.dart';
import 'custom_popup_menu_button.dart';

CustomPopupMenuItem savePopupMenuItem(BuildContext context, Savable savable) {
  return CustomPopupMenuItem(
    icon: Icon(
      savable.saved ? Icons.bookmark : Icons.bookmark_border,
    ),
    label: savable.saved ? 'Unsave' : 'Save',
    onTap: () {
      return (savable.saved ? savable.unsave() : savable.save())
          .catchError((e) => showErrorSnackBar(context, e));
    },
  );
}
