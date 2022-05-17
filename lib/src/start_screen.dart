import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/login/login_screen.dart';
import 'package:flutter_reddit_prototype/src/widget/custom_future_builder.dart';
import 'package:provider/provider.dart';

import 'notifier/reddir_notifier.v4_2.dart';
import 'tabs.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final notifier = context.watch<UserAuth>();
        return CustomFutureBuilder<bool>(
          future: notifier.loginSilently('', ''),
          onData: (_, ok) {
            if (ok) {
              return Tabs();
            }
            return LoginScreen();
          },
          onError: (_, e) {
            print('$e');
            return LoginScreen();
          },
        );
      },
    );
  }
}
