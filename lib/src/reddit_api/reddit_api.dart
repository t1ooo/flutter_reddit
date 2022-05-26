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

// TODO: move to file
typedef Sort = draw.Sort;

// TODO: move to subreddit
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

// TODO: merge saved|unaved etc to one method
abstract class RedditApi {
  Future<List<Submission>> front({
    required int limit,
    required FrontSubType type,
  });
  Future<List<Submission>> popular({required int limit, required SubType type});
  Future<List<Submission>> all({required int limit, required SubType type});

  Future<User> user(String name);
  Future<List<Comment>> userComments(User user, {required int limit});
  Future<List<Submission>> userSubmissions(User user, {required int limit});
  Future<List<Trophy>> userTrophies(User user);
  Future<UserSaved> userSaved(User user, {required int limit});
  Future<void> userBlock(User user, bool block);
  // Future<void> userUnblock(User user);

  Future<Subreddit> subreddit(String name);
  // Future<String> subredditIcon(Subreddit subreddit);
  Future<void> subredditSubscribe(Subreddit subreddit, bool subscribe);
  // Future<void> subredditUnsubscribe(Subreddit subreddit);
  Future<void> subredditFavorite(Subreddit subreddit, bool favorite);
  // Future<void> subredditUnfavorite(Subreddit subreddit);
  Future<List<Submission>> subredditSubmissions(
    Subreddit subreddit, {
    required int limit,
    required SubType type,
  });
  Future<List<Rule>> subredditRules(Subreddit subreddit);

  Future<Submission> submission(String id);
  Future<void> submissionLike(Submission submission, Like like);
  Future<void> submissionSave(Submission submission, bool save);
  // Future<void> submissionUnsave(Submission submission);
  Future<void> submissionHide(Submission submission, bool hide);
  // Future<void> submissionUnhide(Submission submission);
  Future<Comment> submissionReply(Submission submission, String body);
  Future<void> submissionReport(Submission submission, String reason);

  Future<void> commentLike(Comment comment, Like like);
  Future<void> commentSave(Comment comment, bool save);
  // Future<void> commentUnsave(Comment comment);
  Future<Comment> commentReply(Comment comment, String body);
  Future<void> commentReport(Comment comment, String reason);

  Future<User?> currentUser();
  Future<List<Subreddit>> currentUserSubreddits({required int limit});

  Future<List<Submission>> search(
    String query, {
    required int limit,
    required Sort sort,
    String subreddit = 'all',
  });
  Future<List<Subreddit>> searchSubreddits(String query, {required int limit});
  // Future<List<Subreddit>> searchSubredditsByName(String query);

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
