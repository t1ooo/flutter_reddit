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

  Future<String?> searchAll();
  Future<String?> search();
  List<SubmissionNotifier>? get submission;
}

abstract class SubredditLoaderNotifier extends ChangeNotifier {
  Future<String?> loadSubreddit();
}

abstract class SubredditNotifier extends ChangeNotifier {
  set name(name);
  Future<String?> subscribe();
  Future<String?> unsubscribe();

  set subType(subType);
  get subType;
  Future<String?> loadSubmissions();
  List<SubmissionNotifier>? get submission;

  Future<String?> loadAbout();
  get about;

  Future<String?> loadMenu();
  get menu;

  Future<String?> star();
  Future<String?> unstar();
}

abstract class HomeFrontNotifier extends ChangeNotifier {
  set subType(subType);
  get subType;

  Future<String?> loadSubmissions();
  List<SubmissionNotifier>? get submission;
}

abstract class HomePopularNotifier extends ChangeNotifier {
  set subType(subType);
  get subType;
  Future<String?> loadSubmissions();
  List<SubmissionNotifier>? get submission;
}

abstract class SubmissionLoaderNotifier extends ChangeNotifier {
  Future<String?> loadSubmission();
}

abstract class SubmissionNotifier extends ChangeNotifier {
  set id(String id);

  Submission? get submission;

  List<CommentNotifier>? get comments;

  Future<String?> save();
  Future<String?> unsave();
  Future<String?> like();
  Future<String?> dislike();
  Future<String?> share();
  Future<String?> reply();
}

abstract class CommentNotifier extends ChangeNotifier {
  Future<String?> save(String commentId);
  Future<String?> unsave();
  Future<String?> like();
  Future<String?> dislike();
  Future<String?> share();
  Future<String?> replyTo();
}

abstract class UserLoaderNotifier extends ChangeNotifier {
  UserNotifier? get user;
  Future<void> loadUser();
}

abstract class UserNotifier extends ChangeNotifier {
  set name(_);

  Future<String?> subscribe();
  Future<String?> unsubscribe();

  Future<String?> loadSubmissions();
  List<SubmissionNotifier>? get submissions;

  Future<String?> loadComments();
  List<CommentNotifier>? get comments;

  Future<String?> loadTrophies();
  List<Trophy>? get trophies;
}

abstract class AuthNotifier extends ChangeNotifier {
  Future<String?> login();
  Future<String?> logout();
}

abstract class CurrentUserNotifier extends ChangeNotifier {
  Future<String?> login();
  Future<String?> logout();

  Future<String?> loadSubreddits();
  List<SubredditNotifier>? get subreddits;

  Future<String?> loadSavedComment();
  List<CommentNotifier>? get savedComment;

  Future<String?> loadSavedSubmissions();
  List<SubmissionNotifier>? get savedSubmissions;
}
