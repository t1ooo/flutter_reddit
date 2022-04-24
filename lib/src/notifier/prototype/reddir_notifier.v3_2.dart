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
      context.read<CurrentUserNotifierX>().front(type: type),
); 

return SubmissionTiles(
  pageStorageKey: PageStorageKey('FrontSubmissions'),
      controller: context.read<FrontSubmissionsNotifierX>(),
);

final NotifierX = context.watch<NotifierX>();
return SubmissionTiles(
  pageStorageKey: PageStorageKey('home'),
  stream: (context, type) {
    NotifierX.type = type;
    return NotifierX.front();
  }
  types: NotifierX.types,
  type: NotifierX.type,
);


final NotifierX = context.watch<NotifierX>();
return SubmissionTiles(
  pageStorageKey: PageStorageKey('someName'),
  stream: (context) => NotifierX.front(),
  types: NotifierX.types,
  type: NotifierX.type,
  onChange: (type) => NotifierX.type = type;
);


final NotifierX = context.watch<NotifierX>();
return SubmissionTiles(
  pageStorageKey: PageStorageKey('someName'),
  submissions: NotifierX.submissions,
  types: NotifierX.types,
  type: NotifierX.type,
  onChange: (type) => NotifierX.loadSubmissions(type);
);
*/

abstract class SearchNotifierX with SubmissionsMixinX, ChangeNotifier {
  get subredditName;
  get query;

  get sort;
  get sorts;

  Future<String?> search(query, sort, [subredditName]);
  List<Submission>? get submission;
}

abstract class SubredditNotifierX with SubmissionsMixinX, ChangeNotifier {
  set name(name);
  Future<String?> subscribe();
  Future<String?> unsubscribe();

  get subType;
  get subTypes;
  Future<String?> loadSubmissions(subType);
  List<Submission>? get submission;

  Future<String?> loadAbout();
  get about;

  Future<String?> loadMenu();
  get menu;

  Future<String?> star();
  Future<String?> unstar();
}

// abstract class HomeFrontNotifierX with SubmissionsMixinX, ChangeNotifier {
//   get subType;
//   get subTypes;

//   Future<String?> loadSubmissions(subType);
//   List<Submission>? get submission;
// }

// abstract class HomePopularNotifierX with SubmissionsMixinX, ChangeNotifier {
//   get subType;
//   get subTypes;
//   Future<String?> loadSubmissions(subType);
//   List<Submission>? get submission;
// }

abstract class HomeNotifierX with SubmissionsMixinX, ChangeNotifier {
  get frontSubType;
  get subTypes;

  Future<String?> loadFrontSubmissions(subType);
  List<Submission>? get frontSubmission;

  get popularSubType;
  Future<String?> loadPopularSubmissions(subType);
  List<Submission>? get popularSubmission;
}

abstract class SubmissionNotifierX with CommentsMixin, SubmissionsMixinX {
  Future<String?> loadSubmission(id);
  Submission? get submission;
}

abstract class UserNotifierX with CommentsMixin, SubmissionsMixinX {
  Future<void> loadUser(name);
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

abstract class CurrentUserNotifierX with CommentsMixin, SubmissionsMixinX {
  Future<String?> login();
  Future<String?> logout();

  Future<String?> loadSubreddits();
  List<Subreddit>? get subreddits;

  Future<String?> loadSavedComment();
  List<Comment>? get savedComment;

  Future<String?> loadSavedSubmissions();
  List<Submission>? get savedSubmissions;
}

mixin SubmissionsMixinX {
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
