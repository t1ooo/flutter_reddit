import 'package:draw/draw.dart' as draw;
import 'package:flutter_reddit_prototype/src/reddit_api/rule.dart';

import 'message.dart';
import 'trophy.dart';
import 'user.dart';
import 'comment.dart';
import 'submission.dart';
import 'submission_type.dart';
import 'subreddit.dart';
import 'like.dart';

typedef Sort = draw.Sort;

String removeSubredditPrefix(String name) {
  const prefix = 'r/';
  if (name.startsWith(prefix)) {
    return name.substring(prefix.length);
  }
  return name;
}

class UserSaved {
  UserSaved(this.submissions, this.comments);
  List<Submission> submissions;
  List<Comment> comments;
}

abstract class RedditApi {
  Future<List<Submission>> front({
    required int limit,
    required FrontSubType type,
  });
  Future<List<Submission>> popular({required int limit, required SubType type});

  

  Future<User> user(String name);
  Future<List<Comment>> userComments(String name, {required int limit});
  Future<List<Submission>> userSubmissions(String name, {required int limit});
  Future<List<Trophy>> userTrophies(String name);
  Future<UserSaved> userSaved(String name, {required int limit});
  Future<void> userBlock(String name);
  Future<void> userUnblock(String name);

  Future<Subreddit> subreddit(String name);
  // Future<String> subredditIcon(String name);
  Future<void> subredditSubscribe(String name);
  Future<void> subredditUnsubscribe(String name);
  Future<void> subredditFavorite(String name);
  Future<void> subredditUnfavorite(String name);
  Future<List<Submission>> subredditSubmissions(
    String name, {
    required int limit,
    required SubType type,
  });
  Future<List<Rule>> subredditRules(String name);

  Future<Submission> submission(String id);
  Future<void> submissionLike(String id, Like like);
  Future<void> submissionSave(String id);
  Future<void> submissionUnsave(String id);
  Future<void> submissionHide(String id);
  Future<void> submissionUnhide(String id);
  Future<Comment> submissionReply(String id, String body);
  Future<void> submissionReport(String id, String reason);

  Future<void> commentLike(String id, Like like);
  Future<void> commentSave(String id);
  Future<void> commentUnsave(String id);
  Future<Comment> commentReply(String id, String body);
  Future<void> commentReport(String id, String reason);

  Future<User?> currentUser();
  Future<List<Subreddit>> currentUserSubreddits({required int limit});

  Future<List<Submission>> search(
    String query, {
    required int limit,
    required Sort sort,
    String subreddit = 'all',
  });
  Future<List<Subreddit>> searchSubreddits(String query, {required int limit});
  Future<List<Subreddit>> searchSubredditsByName(String query);

  Future<Submission> submit({
    required String subreddit,
    required String title,
    String? selftext,
    String? url,
    bool resubmit = true,
    bool sendReplies = true,
    bool nsfw = false,
    bool spoiler = false,
  });

  bool get isLoggedIn;
  Future<bool> loginSilently();
  Future<void> login();
  Future<void> logout();

  Future<List<Message>> inboxMessages();
}
