// ignore_for_file: annotate_overrides

import '../reddit_api/reddit_api.dart';
import 'base_notifier.dart';
import 'const.dart';
import 'submission_notifier.dart';

class SearchNotifier extends BaseNotifier {
  SearchNotifier(this._redditApi);

  final RedditApi _redditApi;

  // void reset() {
  //   _subredditName = '';
  //   _query = '';
  //   _sort = Sort.relevance;
  //   _submissions = null;
  //   // notifyListeners();
  // }

  String _subredditName = '';
  String _query = '';

  Sort _sort = Sort.relevance;
  Sort get sort => _sort;

  List<Sort> get sorts => Sort.values;

  List<SubmissionNotifier>? _submissions;
  List<SubmissionNotifier>? get submissions => _submissions;

  Future<void> reloadSearch() {
    _submissions = null;
    return search(_query, _sort, _subredditName);
  }

  Future<void> search(
    String query, [
    Sort sort = Sort.relevance,
    String subredditName = 'all',
  ]) {
    return try_(
      () async {
        if (_submissions != null &&
            _query == query &&
            _sort == sort &&
            _subredditName == subredditName) return;

        _query = query;
        _sort = sort;
        _subredditName = subredditName;

        _submissions = (await _redditApi.search(
          query,
          limit: limit,
          sort: _sort,
          subreddit: _subredditName,
        ))
            .map((v) => SubmissionNotifier(_redditApi, v))
            .toList();
        notifyListeners();
      },
      'fail to search',
    );
  }
}
