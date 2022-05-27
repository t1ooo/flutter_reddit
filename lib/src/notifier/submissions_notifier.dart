import '../reddit_api/reddit_api.dart';
import '../reddit_api/submission.dart';
import 'base_notifier.dart';
import 'submission_notifier.dart';

abstract class SubmissionsNotifier<T> extends BaseNotifier {
  SubmissionsNotifier(this._redditApi, this._subType);

  final RedditApi _redditApi;

  // void reset() {
  //   _submissions = null;
  //   _subType = _initialSubType;
  //   // notifyListeners();
  // }

  T _subType;
  T get subType => _subType;

  List<SubmissionNotifier>? _submissions;
  List<SubmissionNotifier>? get submissions => _submissions;

  Future<void> reloadSubmissions() {
    _submissions = null;
    return loadSubmissions(_subType);
  }

  Future<void> loadSubmissions(T subType) {
    return try_(
      () async {
        if (_submissions != null && _subType == subType) return;
        _subType = subType;

        _submissions = (await loadSubmissions_())
            .map((v) => SubmissionNotifier(_redditApi, v))
            .toList();
        notifyListeners();
      },
      'fail to search',
    );
  }

  Future<List<Submission>> loadSubmissions_();
}
