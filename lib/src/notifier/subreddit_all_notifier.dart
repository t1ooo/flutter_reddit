import '../reddit_api/reddit_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import 'const.dart';
import 'submissions_notifier.dart';

class SubredditAllNotifier extends SubmissionsNotifier<SubType> {
  SubredditAllNotifier(this._redditApi)
      : super(_redditApi, SubType.values.first);

  final RedditApi _redditApi;

  String get name => 'all';

  @override
  Future<List<Submission>> loadSubmissions_() {
    return _redditApi.all(limit: limit, type: subType);
  }
}
