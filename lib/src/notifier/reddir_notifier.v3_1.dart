import 'package:flutter/foundation.dart';

import '../reddit_api/trophy.dart';
import '../reddit_api/user.dart';
import '../reddit_api/comment.dart';
import '../reddit_api/submission.dart';
import '../reddit_api/subreddit.dart';

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

abstract class SearchNotifier with SubmissionsMixin, ChangeNotifier {
  get subredditName;
  set subredditName(subredditName);

  get query;
  set query(query);

  get subType; // sort
  set subType(subType); // sort

  // get sort;
  // set sort(sort);

  Future<String?> searchAll();
  Future<String?> search();
  List<Submission>? get submission;
}

abstract class SubredditNotifier with SubmissionsMixin, ChangeNotifier {
  set name(name);
  Future<String?> subscribe();
  Future<String?> unsubscribe();

  set subType(subType);
  get subType;
  Future<String?> loadSubmissions();
  List<Submission>? get submission;

  Future<String?> loadAbout();
  get about;

  Future<String?> loadMenu();
  get menu;

  Future<String?> star();
  Future<String?> unstar();
}

abstract class HomeFrontNotifier with SubmissionsMixin, ChangeNotifier {
  set subType(subType);
  get subType;

  Future<String?> loadSubmissions();
  List<Submission>? get submission;
}

abstract class HomePopularNotifier with SubmissionsMixin, ChangeNotifier {
  set subType(subType);
  get subType;
  Future<String?> loadSubmissions();
  List<Submission>? get submission;
}

abstract class SubmissionNotifier with CommentsMixin, SubmissionsMixin {
  set id(String id);

  Future<String?> loadSubmission();
  Submission? get submission;
}

abstract class UserNotifier with CommentsMixin, SubmissionsMixin {
  set name(_);

  Future<void> loadUser();
  User get user;

  Future<String?> subscribe();
  Future<String?> unsubscribe();

  Future<String?> loadSubmissions();
  List<Submission>? get submissions;

  Future<String?> loadComments();
  List<Comment>? get comments;

  Future<String?> loadTrophies();
  List<Trophy>? get trophies;
}

abstract class CurrentUserNotifier with CommentsMixin, SubmissionsMixin {
  Future<String?> login();
  Future<String?> logout();

  Future<String?> loadSubreddits();
  List<Subreddit>? get subreddits;

  Future<String?> loadSavedComment();
  List<Comment>? get savedComment;

  Future<String?> loadSavedSubmissions();
  List<Submission>? get savedSubmissions;
}

mixin SubmissionsMixin {
  Future<String?> saveSubmissions(String submissionId);
  Future<String?> unsaveSubmissions(String submissionId);
  Future<String?> voteUpSubmissions(String submissionId);
  Future<String?> voteDownSubmissions(String submissionId);
  Future<String?> shareSubmissions(String submissionId);
  Future<String?> replySubmissions(String submissionId);
}

mixin CommentsMixin {
  Future<String?> saveComment(String commentId);
  Future<String?> unsaveComment(String commentId);
  Future<String?> voteUpComment(String commentId);
  Future<String?> voteDownComment(String commentId);
  Future<String?> shareComment(String commentId);
  Future<String?> replyToComment(String commentId);
}
