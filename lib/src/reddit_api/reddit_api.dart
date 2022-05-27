import 'package:draw/draw.dart' as draw;
import 'rule.dart';

import 'comment.dart';
import 'like.dart';
import 'message.dart';
import 'submission.dart';
import 'submission_type.dart';
import 'subreddit.dart';
import 'trophy.dart';
import 'user.dart';

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

  Future<Subreddit> subreddit(String name);

  Future<void> subredditSubscribe(Subreddit subreddit, bool subscribe);

  Future<void> subredditFavorite(Subreddit subreddit, bool favorite);

  Future<List<Submission>> subredditSubmissions(
    Subreddit subreddit, {
    required int limit,
    required SubType type,
  });
  Future<List<Rule>> subredditRules(Subreddit subreddit);

  Future<Submission> submission(String id);
  Future<void> submissionLike(Submission submission, Like like);
  Future<void> submissionSave(Submission submission, bool save);

  Future<void> submissionHide(Submission submission, bool hide);

  Future<Comment> submissionReply(Submission submission, String body);
  Future<void> submissionReport(Submission submission, String reason);

  Future<void> commentLike(Comment comment, Like like);
  Future<void> commentSave(Comment comment, bool save);

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
