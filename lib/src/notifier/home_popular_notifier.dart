import '../reddit_api/reddit_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import 'const.dart';
import 'submissions_notifier.dart';

class HomePopularNotifier extends SubmissionsNotifier<SubType> {
  HomePopularNotifier(this._redditApi)
      : super(_redditApi, SubType.values.first);

  final RedditApi _redditApi;

  @override
  Future<List<Submission>> loadSubmissions_() {
    return _redditApi.popular(limit: limit, type: subType);
  }
}
