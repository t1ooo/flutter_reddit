import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../logging/logging.dart';
import '../reddit_api/reddit_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import 'limit.dart';
import 'submissions_notifier.dart';

class HomePopularNotifier extends SubmissionsNotifier<SubType> {
  HomePopularNotifier(this._redditApi)
      : super(_redditApi, SubType.values.first);

  final RedditApi _redditApi;
  static final _log = getLogger('HomeFrontNotifier');

  // TODO: remove
  @override
  Future<List<Submission>> _loadSubmissions() {
    return _redditApi.popular(limit: limit, type: subType);
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}
