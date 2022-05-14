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
*/

mixin SubmissionMixin {
  Future<Submission> submission();
  Future<String?> saveSubmission(String id);
  Future<String?> unsaveSubmission(String id);
  Future<String?> likeSubmission(String id);
  Future<String?> dislikeSubmission(String id);
  Future<String?> shareSubmission(String id);
  Future<String?> reply(String id);
}

mixin CommentMixin {
  Future<String?> saveComment(String commentId);
  Future<String?> unsaveComment(String commentId);
  Future<String?> likeComment(String commentId);
  Future<String?> dislikeComment(String commentId);
  Future<String?> shareComment(String commentId);
  Future<String?> replyToComment(String commentId);
}

abstract class SearchNotifier extends ChangeNotifier {
  get subredditName;
  set subredditName(query);

  get query;
  set query(query);

  get subType; // sort
  set subType(subType); // sort

  // get sort;
  // set sort(sort);

  Stream<Submission> search();
}

abstract class SubredditNotifier extends ChangeNotifier {
  set name(name); // subreddit name
  Future<String?> subscribe();
  Future<String?> unsubscribe();

  Future<String?> star();
  Future<String?> unstar();
}

abstract class SubredditSubmissionsNotifier extends ChangeNotifier {
  set name(name); // subreddit name
  set subType(subType);
  get subType;

  Stream<Submission> submissions();

  Future<String?> saveSubmission(String id);
  Future<String?> unsaveSubmission(String id);
  Future<String?> likeSubmission(String id);
  Future<String?> dislikeSubmission(String id);
  Future<String?> shareSubmission(String id);
}

abstract class SubredditAboutNotifier extends ChangeNotifier {
  set name(name); // subreddit name
  about();
}

abstract class SubredditMenuNotifier extends ChangeNotifier {
  set name(name); // subreddit name
  menu();
}

abstract class HomeFrontNotifier extends ChangeNotifier {
  set subType(subType);
  get subType;

  Stream<Submission> submissions();

  Future<String?> saveSubmission(String id);
  Future<String?> unsaveSubmission(String id);
  Future<String?> likeSubmission(String id);
  Future<String?> dislikeSubmission(String id);
  Future<String?> shareSubmission(String id);
}

abstract class HomePopularNotifier extends ChangeNotifier {
  Stream<Submission> submissions();
  set subType(subType);
  get subType;
  Future<String?> saveSubmission(String id);
  Future<String?> unsaveSubmission(String id);
  Future<String?> likeSubmission(String id);
  Future<String?> dislikeSubmission(String id);
  Future<String?> shareSubmission(String id);
}

/* abstract class SubmissionNotifier extends ChangeNotifier {
  set id(String id);
  Future<Submission> submission();
  Future<String?> save();
  Future<String?> unsave();
  Future<String?> like();
  Future<String?> dislike();
  Future<String?> share();
}

abstract class CommentsNotifier extends ChangeNotifier {
  Future<String?> saveSubmission(String id);
  Future<String?> unsaveSubmission(String id);
  Future<String?> likeSubmission(String id);
  Future<String?> dislikeSubmission(String id);
  Future<String?> shareSubmission(String id);
  Future<String?> reply(String submissionId);
  Future<String?> replyTo(String id);
} */

abstract class SubmissionNotifier extends ChangeNotifier {
  set id(String id);

  Future<Submission> submission();
  Future<String?> saveSubmission(String id);
  Future<String?> unsaveSubmission(String id);
  Future<String?> likeSubmission(String id);
  Future<String?> dislikeSubmission(String id);
  Future<String?> shareSubmission(String id);
  Future<String?> reply(String id);

  Future<String?> saveComment(String commentId);
  Future<String?> unsaveComment(String commentId);
  Future<String?> likeComment(String commentId);
  Future<String?> dislikeComment(String commentId);
  Future<String?> shareComment(String commentId);
  Future<String?> replyToComment(String commentId);
}

abstract class UserNotifier extends ChangeNotifier {
  set name(_);

  Future<User> user();

  Future<String?> subscribe();
  Future<String?> unsubscribe();
}

abstract class UserSubmissionsNotifier extends ChangeNotifier {
  set name(_);
  Future<Submission> submission();

  Future<String?> save();
  Future<String?> unsave();
  Future<String?> like();
  Future<String?> dislike();
  Future<String?> share();
  Future<String?> reply();
}

abstract class UserCommentsNotifier extends ChangeNotifier {
  set name(_);
  Future<Comment> comments();

  Future<String?> saveComment(String commentId);
  Future<String?> unsaveComment(String commentId);
  Future<String?> likeComment(String commentId);
  Future<String?> dislikeComment(String commentId);
  Future<String?> shareComment(String commentId);
  Future<String?> replyToComment(String commentId);
}

abstract class UserAboutNotifier extends ChangeNotifier {
  set name(_);
  Future<List<Trophy>> trophies();
}

abstract class CurrentUserSavedCommentsNotifier extends ChangeNotifier {
  Stream<Comment> savedComment();

  // Future<String?> saveComment(String commentId);
  Future<String?> unsaveComment(String commentId);
  Future<String?> likeComment(String commentId);
  Future<String?> dislikeComment(String commentId);
  Future<String?> shareComment(String commentId);
  Future<String?> replyToComment(String commentId);
}

abstract class CurrentUserSavedSubmissionsNotifier extends ChangeNotifier {
  Stream<Submission> savedSubmissions();

  Future<String?> save();
  Future<String?> unsave();
  Future<String?> like();
  Future<String?> dislike();
  Future<String?> share();
  Future<String?> reply();
}

abstract class CurrentUserSubredditsNotifier extends ChangeNotifier {
  Stream<Subreddit> subreddits();

  Future<String?> star();
  Future<String?> unstar();
}

abstract class CurrentUserNotifier extends ChangeNotifier {
  Future<String?> login();
  Future<String?> logout();
}

//////////////////////////////////////

class CachedStream<T> {
  CachedStream(this.getStream);

  final Stream<T> Function() getStream;
  final List<T> _cache = [];

  Stream<T> cached() {
    if (_cache.isNotEmpty) {
      print('cached');
      return Stream.fromIterable(_cache);
    }
    return getStream().map((v) {
      _cache.add(v);
      return v;
    });
  }

  void clear() {
    _cache.clear();
  }
}

class CachedValue<T> {
  CachedValue(this.getValue);

  final T Function() getValue;
  T? _cache;

  T cached() {
    if (_cache == null) {
      _cache = getValue();
    }
    return _cache!;
  }

  void clear() {
    _cache = null;
  }
}
