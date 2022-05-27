import '../logging.dart';
import '../reddit_api/reddit_api.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/submission_type.dart';
import 'const.dart';
import 'submissions_notifier.dart';

class HomeFrontNotifier extends SubmissionsNotifier<FrontSubType> {
  HomeFrontNotifier(this._redditApi)
      : super(_redditApi, FrontSubType.values.first);

  final RedditApi _redditApi;

  @override
  Future<List<Submission>> loadSubmissions_() {
    return _redditApi.front(limit: limit, type: subType);
  }
}
