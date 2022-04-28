import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../style/style.dart';
import '../util/snackbar.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _user = '';
  String _pass = '';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: topPadding),
        TextFormField(
          onChanged: (v) => _user = v,
          validator: (v) {
            if (v == null || v.trim() == '') {
              return 'Please enter username';
            }
            return null;
          },
          decoration: InputDecoration(hintText: 'username'),
          textInputAction: TextInputAction.next,
        ),
        TextFormField(
          onChanged: (v) => _pass = v,
          validator: (v) {
            if (v == null || v.trim() == '') {
              return 'Please enter password';
            }
            return null;
          },
          decoration: InputDecoration(hintText: 'password'),
          textInputAction: TextInputAction.done,
        ),
        SizedBox(height: 50),
        ElevatedButton(
          onPressed: submit,
          child: Text('Log in'),
        ),
      ],
    );
  }

  void submit() {
    _user = _user.trim();
    _pass = _pass.trim();

    context
        .read<UserAuth>()
        .login(_user, _pass)
        .then((_) => Navigator.pop(context))
        .catchError((e) => showErrorSnackBar(context, e));
  }
}
