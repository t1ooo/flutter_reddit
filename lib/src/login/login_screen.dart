import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/auth_notifier.dart';
import '../widget/async_button_builder.dart';
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
            AsyncButtonBuilder(
              onPressed: () => context
                  .read<AuthNotifier>()
                  .login()
                  .catchError((e) => showErrorSnackBar(context, e)),
              builder: (_, onPressed) =>
                  ElevatedButton(onPressed: onPressed, child: Text('Log in')),
            ),
          ],
        ),
      ),
    );
  }
}
