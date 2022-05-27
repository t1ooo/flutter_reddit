import '../reddit_api/reddit_api.dart';
import 'base_notifier.dart';
import 'submission_notifier.dart';

class SubmissionLoaderNotifier extends BaseNotifier {
  SubmissionLoaderNotifier(this._redditApi);

  final RedditApi _redditApi;

  String? _id;

  SubmissionNotifier? _submission;
  SubmissionNotifier? get submission => _submission;

  Future<void> loadSubmission(String id) {
    return try_(
      () async {
        if (_submission != null && _id == id) return;
        _id = id;

        _submission =
            SubmissionNotifier(_redditApi, await _redditApi.submission(_id!));
        notifyListeners();
      },
      'fail to load submission',
    );
  }
}
