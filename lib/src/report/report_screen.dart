import 'package:flutter/material.dart';

import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:flutter_reddit_prototype/src/widget/sliver_app_bar.dart';
import 'package:provider/provider.dart';

import '../notifier/reddir_notifier.v4_2.dart';
import '../widget/snackbar.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _reason = '';

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
                title: AppBarTitle('Report'),
                trailing: TextButton(
                  onPressed: _submit,
                  child: Text('POST'),
                ),
              ),
            ),
          ];
        },
        body: Container(
          color: Theme.of(context).primaryColor,
          padding: pagePadding,
          child: _form(context),
        ),
      ),
    );
  }

  Widget _form(BuildContext context) {
    return TextField(
      onChanged: (v) => _reason = v,
      onSubmitted: (v) {
        _submit();
      },
      decoration: InputDecoration(
        hintText: 'Reason',
        border: InputBorder.none,
      ),
    );
  }

  void _submit() async {
    _reason = _reason.trim();
    if (_reason == '') {
      showErrorSnackBar(context, 'please enter a reason');
      return;
    }

    context
        .read<Reportable>()
        .report(_reason)
        .catchError((e) => showErrorSnackBar(context, e));

    Navigator.pop(context);
  }
}
