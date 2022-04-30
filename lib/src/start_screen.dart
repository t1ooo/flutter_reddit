import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/login_v2/login_screen.dart';
import 'package:flutter_reddit_prototype/src/util/snackbar.dart';
import 'package:flutter_reddit_prototype/src/widget/custom_future_builder.dart';
import 'package:provider/provider.dart';

import 'notifier/reddir_notifier.v4_2.dart';
import 'tabs.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   // appBar: AppBar(
    //   //   title: Text('LoginScreen'),
    //   // ),
    //   body:
    return Builder(
      builder: (context) {
        final notifier = context.watch<UserAuth>();
        return CustomFutureBuilder<bool>(
          future: notifier.loginSilently('', ''),
          onData: (_, ok) {
            // if (ok && context.read<UserAuth>().user != null) {
            if (ok) {
              return Tabs();
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => Tabs(),
              //   ),
              // );
              // return Container();
            }
            return LoginScreen();
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => LoginScreen(),
            //   ),
            // );
            // return Container();
          },
          onError: (_, e) {
            print('$e');
            return LoginScreen();
            // return Scaffold(
            //   // print(e);
            //   // return Container();
            //   body: Builder(builder: (context) {
            //     showErrorSnackBar(context, e);
            //     return LoginScreen();
            //   }),
            // );
          },
        );
      },
      // ),
    );
  }
}
