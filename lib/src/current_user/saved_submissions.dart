import 'package:flutter/material.dart';
import 'package:flutter_reddit_prototype/src/style/style.dart';
import 'package:provider/provider.dart';

import '../home/submission_tiles.v2.dart';
import '../notifier/reddir_notifier.dart';
import '../search/search_field.dart';
import '../widget/sized_placeholder.dart';

class SavedSubmissions extends StatelessWidget {
  const SavedSubmissions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SubmissionTiles(
      showTrending: false,
      showTypeSelector: false,
      stream: (context, type) =>
          context.read<CurrentUserNotifier>().savedSubmissions(),
    );
  }
}
