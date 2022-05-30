import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../notifier/user_notifier.dart';
import '../style.dart';
import '../util/date_time.dart';
import '../widget/list.dart';
import '../widget/snackbar.dart';
import 'user_trophies.dart';

class UserAbout extends StatelessWidget {
  const UserAbout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserNotifier>().user;

    return Container(
      color: primaryColor,
      child: CustomListView(
        key: PageStorageKey(runtimeType.toString()),
        children: [
          ListDivider(height: 10),
          CustomListView(
            children: [
              SizedBox(height: 50),
              Table(
                children: [
                  TableRow(
                    children: [
                      Center(child: Text(user.totalKarma.toString())),
                      Center(child: Text(formatDateTime(user.created))),
                    ],
                  ),
                  TableRow(
                    children: const [
                      Center(child: Text('Karma')),
                      Center(child: Text('Reddit age')),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 50),
              ListTile(
                leading: Icon(Icons.mail),
                title: Text('Send a message'),
                onTap: () {
                  showTodoSnackBar(context); // TODO
                },
              ),
              ListTile(
                leading: Icon(Icons.chat),
                title: Text('Start chat'),
                onTap: () {
                  showTodoSnackBar(context); // TODO
                },
              ),
              SizedBox(height: 10),
            ],
          ),
          UserTrophies(),
        ],
      ),
    );
  }
}
