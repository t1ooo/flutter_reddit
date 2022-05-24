import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../logging.dart';
import '../reddit_api/reddit_api.dart';
import 'submission_notifier.dart';
import 'try_mixin.dart';

class SubmissionLoaderNotifier with TryMixin, ChangeNotifier {
  SubmissionLoaderNotifier(this._redditApi);

  final RedditApi _redditApi;
  static final _log = getLogger('SubmissionLoaderNotifier');
  Logger get log => _log;

  // void reset() {
  //   _id = null;
  //   _submission = null;
  //   // notifyListeners();
  // }

  String? _id;

  SubmissionNotifier? _submission;
  SubmissionNotifier? get submission => _submission;

  Future<void> loadSubmission(String id) {
    return try_(() async {
      if (_submission != null && _id == id) return;
      _id = id;

      _submission =
          SubmissionNotifier(_redditApi, await _redditApi.submission(_id!));
      notifyListeners();
    }, 'fail to load submission');
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}
