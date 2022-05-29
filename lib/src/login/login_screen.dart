import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/auth_notifier.dart';
import '../widget/future_elevated_button.dart';
import '../widget/snackbar.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureElevatedButton(
              onPressed: () {
                return context
                    .read<AuthNotifier>()
                    .login()
                    .catchError((e) => showErrorSnackBar(context, e));
              },
              child: Text('Log in'),
            ),
          ],
        ),
      ),
    );
  }
}
