import 'package:flutter/foundation.dart';

import '../../reddit_api/trophy.dart';
import '../../reddit_api/user.dart';
import '../../reddit_api/comment.dart';
import '../../reddit_api/submission.dart';
import '../../reddit_api/subreddit.dart';

/* 
return SubmissionTiles(
  pageStorageKey: PageStorageKey('home'),
  stream: (context, type) =>
      context.read<CurrentUserNotifier>().front(type: type),
); 

return SubmissionTiles(
  pageStorageKey: PageStorageKey('FrontSubmissions'),
      controller: context.read<FrontSubmissionsNotifier>(),
);

final notifier = context.watch<Notifier>();
return SubmissionTiles(
  pageStorageKey: PageStorageKey('home'),
  stream: (context, type) {
    notifier.type = type;
    return notifier.front();
  }
  types: notifier.types,
  type: notifier.type,
);


final notifier = context.watch<Notifier>();
return SubmissionTiles(
  pageStorageKey: PageStorageKey('someName'),
  stream: (context) => notifier.front(),
  types: notifier.types,
  type: notifier.type,
  onChange: (type) => notifier.type = type;
);


final notifier = context.watch<Notifier>();
return SubmissionTiles(
  pageStorageKey: PageStorageKey('someName'),
  submissions: notifier.submissions,
  types: notifier.types,
  type: notifier.type,
  onChange: (type) => notifier.loadSubmissions(type);
);
*/

abstract class SearchNotifier extends ChangeNotifier {
  get subredditName;
  set subredditName(query);

  get query;
  set query(query);

  get subType; // sort
  set subType(subType); // sort

  // get sort;
  // set sort(sort);

  Future<SubmissionNotifier> search();
  Future<String?> resetSearch();
}

abstract class SubredditNotifier extends ChangeNotifier {
  Future<Subreddit> subreddit();
  Future<String?> resetSubreddit();

  set name(name);
  Future<String?> subscribe();
  Future<String?> unsubscribe();

  set subType(subType);
  get subType;
  Future<List<SubmissionNotifier>> submissions();
  Future<String?> resetSubmissions();

  Future<Object> about();
  Future<Object> menu();

  Future<String?> star();
  Future<String?> unstar();
}

abstract class HomeFrontNotifier extends ChangeNotifier {
  set subType(subType);
  get subType;

  Future<List<SubmissionNotifier>> submissions();
  Future<String?> resetSubmissions();
}

abstract class HomePopularNotifier extends ChangeNotifier {
  set subType(subType);
  get subType;
  Future<List<SubmissionNotifier>> submissions();
  Future<String?> resetSubmissions();
}

abstract class SubmissionNotifier extends ChangeNotifier {
  set id(String id);

  Future<Submission> submission();
  Future<String?> resetSubmission();

  List<CommentNotifier>? get comments;

  Future<String?> save();
  Future<String?> unsave();
  Future<String?> voteUp();
  Future<String?> voteDown();
  Future<String?> share();
  Future<String?> reply();
}

abstract class CommentNotifier extends ChangeNotifier {
  Future<String?> save(String commentId);
  Future<String?> unsave();
  Future<String?> voteUp();
  Future<String?> voteDown();
  Future<String?> share();
  Future<String?> replyTo();
}

abstract class UserNotifier extends ChangeNotifier {
  set name(_);

  Future<User> user();
  Future<String?> resetSearch();

  Future<String?> subscribe();
  Future<String?> unsubscribe();

  Future<List<SubmissionNotifier>> submissions();
  Future<String?> resetSubmissions();

  Future<List<CommentNotifier>> comments();
  Future<String?> resetComments();

  Future<List<Trophy>> trophies();
  Future<String?> resetTrophies();
}

abstract class CurrentUserNotifier extends ChangeNotifier {
  Future<String?> login();
  Future<String?> logout();

  Future<List<SubredditNotifier>> subreddits();
  Future<String?> resetSearch();

  Future<List<CommentNotifier>> savedComment();
  Future<String?> resetSavedComment();

  Future<List<SubmissionNotifier>> savedSubmissions();
  Future<String?> resetSavedSubmissions();
}
