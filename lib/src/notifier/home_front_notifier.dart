import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../logging/logging.dart';
import '../reddit_api/reddit_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import 'limit.dart';
import 'submissions_notifier.dart';

class HomeFrontNotifier extends SubmissionsNotifier<FrontSubType> {
 HomeFrontNotifier(this._redditApi)
      : super(_redditApi, FrontSubType.values.first);

  final RedditApi _redditApi;
  static final _log = getLogger('HomeFrontNotifier');

  @override
  Future<List<Submission>> _loadSubmissions() {
    return _redditApi.front(limit: limit, type: subType);
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}
