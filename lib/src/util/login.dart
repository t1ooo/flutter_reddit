import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login/login_screen.dart';
import '../notifier/reddir_notifier.v4_2.dart';

Future<void> loggedInGuard(BuildContext context) async {
  if (context.read<UserAuth>().user == null) {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(),
      ),
    );
  }
}
