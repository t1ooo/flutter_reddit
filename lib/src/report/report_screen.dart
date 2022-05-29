import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/reportable.dart';
import '../style.dart';
import '../widget/async_button_builder.dart';
import '../widget/sliver_app_bar.dart';
import '../widget/snackbar.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({
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
                trailing: AsyncButtonBuilder(
                  onPressed: _submit,
                  builder: (_, onPressed) =>
                      TextButton(onPressed: onPressed, child: Text('POST')),
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

  Future<void> _submit() async {
    _reason = _reason.trim();
    if (_reason == '') {
      showErrorSnackBar(context, 'please enter a reason');
      return;
    }

    final navigator = Navigator.of(context);

    await context
        .read<Reportable>()
        .report(_reason)
        .catchError((e) => showErrorSnackBar(context, e));

    navigator.pop();
  }
}
