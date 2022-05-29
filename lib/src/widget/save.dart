import 'package:flutter/material.dart';

import '../notifier/savable.dart';
import 'custom_popup_menu_button.dart';
import 'snackbar.dart';

CustomPopupMenuItem savePopupMenuItem(BuildContext context, Savable savable) {
  return CustomPopupMenuItem(
    icon: Icon(
      savable.saved ? Icons.bookmark : Icons.bookmark_border,
    ),
    label: savable.saved ? 'Unsave' : 'Save',
    onTap: () => savable
        .save(!savable.saved)
        .catchError((e) => showErrorSnackBar(context, e)),
  );
}
