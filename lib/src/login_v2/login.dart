import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../style/style.dart';
import '../util/snackbar.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              context
                  .read<UserAuth>()
                  .login('', '')
                  .catchError((e) => showErrorSnackBar(context, e));
            },
            child: Text('Log in'),
          ),
        ],
      ),
    );
  }
}
