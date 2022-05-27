import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/replyable.dart';
import '../style.dart';
import '../widget/list.dart';
import '../widget/sliver_app_bar.dart';
import '../widget/snackbar.dart';

class ReplyScreen extends StatefulWidget {
  const ReplyScreen({Key? key}) : super(key: key);

  @override
  State<ReplyScreen> createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            PrimarySliverAppBar(
              collapsed: true,
              flexibleSpace: SpaceBar(
                leading: AppBarCloseButton(),
                title: AppBarTitle('Add comment'),
                trailing: TextButton(
                  onPressed: _submit,
                  child: Text('POST'),
                ),
              ),
            ),
          ];
        },
        body: Container(
          color: primaryColor,
          padding: pagePadding,
          child: _form(context),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return CustomListView(
      children: [
        Text(context.read<Replyable>().replyToMessage),
        Divider(),
        TextField(
          onChanged: (v) => _message = v,
          onSubmitted: (v) {
            _submit();
          },
          decoration: InputDecoration(
            hintText: 'You comment',
            border: InputBorder.none,
          ),
        ),
      ],
    );
  }

  void _submit() {
    _message = _message.trim();
    if (_message == '') {
      showErrorSnackBar(context, 'please enter a message');
      return;
    }

    context
        .read<Replyable>()
        .reply(_message)
        .catchError((e) => showErrorSnackBar(context, e));

    Navigator.pop(context);
  }
}
