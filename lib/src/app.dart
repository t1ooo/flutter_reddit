import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'login/login_screen.dart';
import 'notifier/auth_notifier.dart';
import 'style.dart';
import 'tabs.dart';
import 'widget/custom_future_builder.dart';
import 'widget/custom_scroll.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reddit App',
      theme: theme,
      home:
          // Container(
          // color: primaryColor,
          // SafeArea(
          // child:
          CustomScroll(child: StartScreen()),
      // ),
      // ),
      // builder: (context, child) => ResponsiveWrapper.builder(
      //   child,
      //   breakpoints: [
      //     ResponsiveBreakpoint.resize(480, name: MOBILE),
      //     ResponsiveBreakpoint.resize(800, name: TABLET),
      //     ResponsiveBreakpoint.resize(1000, name: DESKTOP),
      //   ],
      // ),
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final notifier = context.watch<AuthNotifier>();
        return CustomFutureBuilder<bool>(
          future: notifier.loginSilently(),
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
