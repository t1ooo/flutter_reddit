import '../logging.dart';
import '../reddit_api/reddit_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import 'const.dart';
import 'submissions_notifier.dart';

class SubredditAllNotifier extends SubmissionsNotifier<SubType> {
  SubredditAllNotifier(this._redditApi)
      : super(_redditApi, SubType.values.first);

  final RedditApi _redditApi;

  static final _log = getLogger('SubredditAllNotifier');
  @override
  Logger get log => _log;

  String get name => 'all';

  @override
  Future<List<Submission>> loadSubmissions_() {
    return _redditApi.all(limit: limit, type: subType);
  }

  @override
  void notifyListeners() {
    _log.info('notifyListeners');
    super.notifyListeners();
  }
}
