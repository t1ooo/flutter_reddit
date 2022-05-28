import 'package:clock/clock.dart';
import 'package:draw/draw.dart' as draw;

import '../logging.dart';
import 'comment.dart';
import 'like.dart';
import 'message.dart';
import 'post_hint.dart';
import 'preview_images.dart';
import 'rule.dart';
import 'submission.dart';
import 'subreddit.dart';
import 'trophy.dart';
import 'user.dart';
import 'video.dart';

final commentParser = CommentParser();
final messageParser = MessageParser();
final previewItemParser = PreviewItemParser();
final ruleParser = RuleParser();
final submissionParser = SubmissionParser();
final subredditParser = SubredditParser();
final trophyParser = TrophyParser();
final userParser = UserParser();
final videoParser = VideoParser();

class CommentParser with RedditParser {
  List<Comment> fromDraws(Iterable<dynamic> s) {
    return _parseIterable<draw.Comment, Comment>(
      s.map((v) {
        if (v is draw.MoreComments) {
          _log.warning('MoreComments'); // TODO
          return null;
        }
        return v;
      }).whereType<draw.Comment>(),
      commentParser.fromDraw,
    );
  }

  Comment fromDraw(draw.Comment v) {
    return fromJson(v.data! as Map<String, dynamic>, drawComment: v);
  }

  Comment fromJson(
    Map<String, dynamic> m, {
    draw.Comment? drawComment,
  }) {
    return Comment(
      subredditId: _parseString(m, ['subreddit_id']),
      authorIsBlocked: _parseBool(m, ['author_is_blocked']),
      commentType: _parseString(m, ['comment_type']),
      linkTitle: _parseString(m, ['link_title']),
      ups: _parseInt(m, ['ups']),
      authorFlairType: _parseString(m, ['author_flair_type']),
      totalAwardsReceived: _parseInt(m, ['total_awards_received']),
      subreddit: _parseString(m, ['subreddit']),
      linkAuthor: _parseString(m, ['link_author']),
      likes: _parseLikes(m, ['likes']),
      replies: parseReplies(m, ['replies']),
      saved: _parseBool(m, ['saved']),
      id: _parseString(m, ['id']),
      gilded: _parseInt(m, ['gilded']),
      archived: _parseBool(m, ['archived']),
      noFollow: _parseBool(m, ['no_follow']),
      author: _parseString(m, ['author']),
      numComments: _parseInt(m, ['num_comments']),
      sendReplies: _parseBool(m, ['send_replies']),
      parentId: _parseString(m, ['parent_id']),
      score: _parseInt(m, ['score']),
      authorFullname: _parseString(m, ['author_fullname']),
      over18: _parseBool(m, ['over_18']),
      controversiality: _parseInt(m, ['controversiality']),
      body: _parseMarkdown(m, ['body']),
      downs: _parseInt(m, ['downs']),
      isSubmitter: _parseBool(m, ['is_submitter']),
      collapsed: _parseBool(m, ['collapsed']),
      bodyHtml: _parseString(m, ['body_html']),
      distinguished: _parseBool(m, ['distinguished']),
      stickied: _parseBool(m, ['stickied']),
      authorPremium: _parseBool(m, ['author_premium']),
      linkId: _parseString(m, ['link_id']),
      permalink: _parseString(m, ['permalink']),
      subredditType: _parseString(m, ['subreddit_type']),
      linkPermalink: _parseUrl(m, ['link_permalink']),
      name: _parseString(m, ['name']),
      subredditNamePrefixed: _parseString(m, ['subreddit_name_prefixed']),
      treatmentTags: _parseListString(m, ['treatment_tags']),
      created: _parseTime(m, ['created']),
      createdUtc: _parseTimeUtc(m, ['created_utc']),
      locked: _parseBool(m, ['locked']),
      quarantine: _parseBool(m, ['quarantine']),
      linkUrl: _parseUrl(m, ['link_url']),
      submissionId: parseSubmissionId(m, ['link_id']),
      awardIcons: _parseAwardIcons(m, ['all_awardings']),
      drawComment: drawComment,
    );
  }

  List<Comment> parseReplies(dynamic map, List<dynamic> keys) {
    // ignore: parameter_assignments
    keys = keys + ['data', 'children'];
    final value = _get<List<dynamic>?>(map, keys, null);

    if (value == null) {
      return [];
    }

    return _parseIterable<dynamic, Comment>(value, (v) {
      return commentParser.fromJson(v['data'] as Map<String, dynamic>);
    });
  }

  String parseSubmissionId(dynamic map, List<dynamic> keys) {
    final value = _get<String?>(map, keys, null);
    if (value == null || value == '') {
      return '';
    }

    final s = value.split('_');
    return s.isEmpty ? '' : s.last;
  }
}

class MessageParser with RedditParser {
  List<Message> fromDraws(Iterable<draw.Message> s) {
    return _parseIterable<draw.Message, Message>(s, fromDraw);
  }

  Message fromDraw(draw.Message v) {
    return fromJson(v.data! as Map<String, dynamic>);
  }

  Message fromJson(Map<String, dynamic> m) {
    return Message(
      subreddit: _parseString(m, ['subreddit_id']),
      authorFullname: _parseString(m, ['author_fullname']),
      id: _parseString(m, ['id']),
      subject: _parseString(m, ['subject']),
      author: _parseString(m, ['author']),
      numComments: _parseInt(m, ['num_comments']),
      parentId: _parseInt(m, ['parent_Id']),
      subredditNamePrefixed: _parseString(m, ['subreddit_name_prefixed']),
      new_: _parseBool(m, ['new']),
      body: _parseMarkdown(m, ['body']),
      dest: _parseString(m, ['dest']),
      wasComment: _parseBool(m, ['was_comment']),
      bodyHtml: _parseString(m, ['body_html']),
      name: _parseString(m, ['name']),
      created: _parseTime(m, ['created']),
      createdUtc: _parseTimeUtc(m, ['created_utc']),
      distinguished: _parseString(m, ['distinguished']),
    );
  }
}

class PreviewItemParser with RedditParser {
  PreviewItem fromJson(Map<String, dynamic> m) {
    return PreviewItem(
      url: _parseUrl(m, ['url']),
      width: _parseDouble(m, ['width']),
      height: _parseDouble(m, ['height']),
    );
  }
}

class RuleParser with RedditParser {
  List<Rule> fromResponse(dynamic resp) {
    // final value = _get<List<dynamic>?>(resp, ['rules'], null);
    // if (value == null) {
    //   return [];
    // }
    return _parseIterable<dynamic, Rule>(resp['rules'] as List<dynamic>, (v) {
      return fromJson(v as Map<String, dynamic>);
    });
  }

  Rule fromJson(Map<String, dynamic> m) {
    return Rule(
      kind: _parseString(m, ['kind']),
      description: _parseString(m, ['description']),
      shortName: _parseString(m, ['short_name']),
      violationReason: _parseString(m, ['violation_reason']),
      createdUtc: _parseTimeUtc(m, ['created_utc']),
      priority: _parseInt(m, ['priority']),
      descriptionHtml: _parseString(m, ['description_html']),
    );
  }
}

// TODO: rename from to parse
class SubmissionParser with RedditParser {
  List<Submission> fromDraws(
    Iterable<draw.UserContent> s,
  ) {
    return _parseIterable<draw.Submission, Submission>(
      s.whereType<draw.Submission>(),
      fromDraw,
    );
  }

  Submission fromDraw(draw.Submission v) {
    final drawComments = v.comments?.comments;
    final comments =
        drawComments != null ? commentParser.fromDraws(drawComments) : null;
    return fromJson(
      v.data! as Map<String, dynamic>,
      comments: comments,
    );
  }

  Submission fromJson(
    Map<String, dynamic> m, {
    List<Comment>? comments,
    draw.Submission? drawSubmission,
  }) {
    return Submission(
      author: _parseString(m, ['author']),
      authorFlairText: _parseString(m, ['author_flair_text']),
      awardIcons: _parseAwardIcons(m, ['all_awardings']),
      created: _parseTime(m, ['created']),
      createdUtc: _parseTimeUtc(m, ['created_utc']),
      domain: _parseString(m, ['domain']),
      downs: _parseInt(m, ['downs']),
      hidden: _parseBool(m, ['hidden']),
      id: _parseString(m, ['id']),
      isVideo: _parseBool(m, ['is_video']),
      linkFlairText: _parseString(m, ['link_flair_text']),
      totalAwardsReceived: _parseInt(m, ['total_awards_received']),
      numComments: _parseInt(m, ['num_comments']),
      over18: _parseBool(m, ['over_18']),
      pinned: _parseBool(m, ['pinned']),
      score: _parseInt(m, ['score']),
      selftext: _parseString(m, ['selftext']),
      subreddit: _parseString(m, ['subreddit']),
      subredditNamePrefixed: _parseString(m, ['subreddit_name_prefixed']),
      thumbnail: _parseUrl(m, ['thumbnail']),
      title: _parseString(m, ['title']),
      ups: _parseInt(m, ['ups']),
      url: _parseUrl(m, ['url']),
      likes: _parseLikes(m, ['likes']),
      saved: _parseBool(m, ['saved']),
      preview: parsePreview(m, ['preview']),
      video: parseVideo(m, ['media']),
      postHint: parsePostHint(m, ['post_hint']),
      authorIsBlocked: _parseBool(m, ['author_is_blocked']),
      comments: comments,
      drawSubmission: drawSubmission,
    );
  }

  List<Preview> parsePreview(dynamic map, List<dynamic> keys) {
    // ignore: parameter_assignments
    keys = keys + ['images'];
    final value = _get<List<dynamic>?>(map, keys, null);
    if (value == null) {
      return [];
    }

    return _parseIterable<dynamic, Preview>(value, (v) {
      v ??= _get<dynamic>(v, ['variants', 'gif'], null);
      final source =
          previewItemParser.fromJson(v['source'] as Map<String, dynamic>);
      final resolutions = ((v['resolutions'] as List<dynamic>?) ?? [])
          .map((x) => previewItemParser.fromJson(x as Map<String, dynamic>))
          .cast<PreviewItem>()
          .toList();
      return Preview(source: source, resolutions: resolutions);
    });
  }

  Video? parseVideo(dynamic map, List<dynamic> keys) {
    // ignore: parameter_assignments
    keys = keys + ['reddit_video'];
    final value = _get<Map<String, dynamic>?>(map, keys, null);
    if (value == null) {
      return null;
    }
    return videoParser.fromJson(value);
  }

  PostHint parsePostHint(dynamic map, List<dynamic> keys) {
    final value = _get<String?>(map, keys, null);
    switch (value) {
      case 'hosted:video':
        return PostHint.hostedVideo;
      case 'image':
        return PostHint.image;
      case 'link':
        // TODO: move to view
        return (_parseUrl(map, ['url']) != '') ? PostHint.link : PostHint.self;
      case 'rich:video':
        return PostHint.richVideo;
      case 'self':
        return PostHint.self;
      case '':
      case null:
        return PostHint.none;
    }

    _log.warning('fail to parse postHint: $keys: $value');
    return PostHint.none;
  }
}

class SubredditParser with RedditParser {
  List<Subreddit> fromDraws(Iterable<draw.Subreddit> s) {
    return _parseIterable<draw.Subreddit, Subreddit>(s, fromDraw);
  }

  Subreddit fromDraw(draw.Subreddit v) {
    return subredditParser.fromJson(
      v.data! as Map<String, dynamic>,
      drawSubreddit: v,
    );
  }

  Subreddit fromJson(Map<String, dynamic> m, {draw.Subreddit? drawSubreddit}) {
    return Subreddit(
      communityIcon: _parseUrl(m, ['community_icon']),
      created: _parseTime(m, ['created']),
      createdUtc: _parseTimeUtc(m, ['created_utc']),
      description: _parseMarkdown(m, ['description']),
      descriptionHtml: _parseString(m, ['description_html']),
      displayName: _parseString(m, ['display_name']),
      displayNamePrefixed: _parseString(m, ['display_name_prefixed']),
      id: _parseString(m, ['id']),
      lang: _parseString(m, ['lang']),
      name: _parseString(m, ['name']),
      publicDescription: _parseString(m, ['public_description']),
      publicDescriptionHtml: _parseString(m, ['public_description_html']),
      submitTextHtml: _parseString(m, ['submit_text_html']),
      submitText: _parseString(m, ['submit_text']),
      subredditType: _parseString(m, ['subreddit_type']),
      subscribers: _parseInt(m, ['subscribers']),
      title: _parseString(m, ['title']),
      url: _parseString(m, ['url']),
      headerImg: _parseUrl(m, ['header_img']),
      bannerBackgroundImage: _parseUrl(m, ['banner_background_image']),
      bannerBackgroundColor: parseColor(m, ['banner_background_color']),
      userIsSubscriber: _parseBool(m, ['user_is_subscriber']),
      userHasFavorited: _parseBool(m, ['user_has_favorited']),
      drawSubreddit: drawSubreddit,
    );
  }

  final _colorRegExp = RegExp(r'^#[0-9abcdef]{3,8}$', caseSensitive: false);

  String parseColor(dynamic map, List<dynamic> keys) {
    final value = _get<String?>(map, keys, null);
    if (value == null || value == '') {
      return '';
    }

    if (_colorRegExp.hasMatch(value)) {
      return value;
    }
    _log.warning('fail to parse color: $keys: $value');
    return '';
  }
}

class TrophyParser with RedditParser {
  List<Trophy> fromDraws(Iterable<draw.Trophy> s) {
    return _parseIterable<draw.Trophy, Trophy>(s, fromDraw);
  }

  Trophy fromDraw(draw.Trophy v) {
    return trophyParser.fromJson(v.data! as Map<String, dynamic>);
  }

  Trophy fromJson(Map<String, dynamic> m) {
    return Trophy(
      icon70: _parseString(m, ['icon_70']),
      grantedAt: _parseTime(m, ['granted_at']),
      url: _parseString(m, ['url']),
      icon40: _parseString(m, ['icon_40']),
      name: _parseString(m, ['name']),
      awardId: _parseString(m, ['award_id']),
      id: _parseString(m, ['id']),
      description: _parseString(m, ['description']),
    );
  }
}

class UserParser with RedditParser {
  User fromDraw(draw.Redditor v) {
    return userParser.fromJson(
      v.data! as Map<String, dynamic>,
      drawRedditor: v,
    );
  }

  User fromJson(Map<String, dynamic> m, {draw.Redditor? drawRedditor}) {
    return User(
      isEmployee: _parseBool(m, ['is_employee']),
      isFriend: _parseBool(m, ['is_friend']),
      awardeeKarma: _parseInt(m, ['awardee_karma']),
      id: _parseString(m, ['id']),
      verified: _parseBool(m, ['verified']),
      isGold: _parseBool(m, ['is_gold']),
      isMod: _parseBool(m, ['is_mod']),
      awarderKarma: _parseInt(m, ['awarder_karma']),
      hasVerifiedEmail: _parseBool(m, ['has_verified_email']),
      iconImg: _parseUrl(m, ['icon_img']),
      linkKarma: _parseInt(m, ['link_karma']),
      isBlocked: _parseBool(m, ['is_blocked']),
      totalKarma: _parseInt(m, ['total_karma']),
      acceptChats: _parseBool(m, ['accept_chats']),
      name: _parseString(m, ['name']),
      created: _parseTime(m, ['created']),
      createdUtc: _parseTimeUtc(m, ['created_utc']),
      snoovatarImg: _parseString(m, ['snoovatar_img']),
      commentKarma: _parseInt(m, ['comment_karma']),
      acceptFollowers: _parseBool(m, ['accept_followers']),
      hasSubscribed: _parseBool(m, ['has_subscribed']),
      subreddit: subredditParser.fromJson(_get(m, ['subreddit'], {})),
      drawRedditor: drawRedditor,
    );
  }
}

class VideoParser with RedditParser {
  Video fromJson(Map<String, dynamic> m) {
    return Video(
      bitrateKbps: _parseInt(m, ['bitrate_kbps']),
      fallbackUrl: _parseUrl(m, ['fallback_url']),
      height: _parseDouble(m, ['height']),
      width: _parseDouble(m, ['width']),
      scrubberMediaUrl: _parseUrl(m, ['scrubber_media_url']),
      duration: _parseInt(m, ['duration']),
      isGif: _parseBool(m, ['is_gif']),
    );
  }
}

mixin RedditParser {
  late final _log = getLogger(runtimeType.toString());

  Like _parseLikes(dynamic map, List<dynamic> keys) {
    final value = _get<bool?>(map, keys, null);
    if (value == null) {
      return Like.none;
    }
    return value ? Like.up : Like.down;
  }

  DateTime _parseTime(dynamic map, List<dynamic> keys) {
    return __parseTime(map, keys, true);
  }

  DateTime _parseTimeUtc(dynamic map, List<dynamic> keys) {
    return __parseTime(map, keys, false);
  }

  DateTime __parseTime(
    dynamic map,
    List<dynamic> keys,
    bool isUtc,
  ) {
    final value = double.tryParse(_get<dynamic>(map, keys, null).toString());
    if (value == null) {
      return clock.now();
    }

    return DateTime.fromMillisecondsSinceEpoch(
      value.round() * 1000,
      isUtc: isUtc,
    );
  }

  List<String> _parseAwardIcons(dynamic map, List<dynamic> keys) {
    // ignore: parameter_assignments
    keys = keys + ['data', 'children'];
    final value = _get<List<dynamic>?>(map, keys, null);
    if (value == null) {
      return [];
    }

    return value
        .map((v) => _parseUrl(v, ['resized_icons', 0, 'url']))
        .where((v) => v != '')
        .toList();
  }

  String _parseUrl(dynamic map, List<dynamic> keys) {
    final value = _get<String?>(map, keys, null);
    if (value == null ||
        value == '' ||
        value == 'self' ||
        value == 'default' ||
        value == 'image' ||
        value == 'spoiler') {
      return '';
    }

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value.replaceAll('&amp;', '&');
    }
    _log.warning('fail to parse url: $keys: $value');
    return '';
  }

  double _parseDouble(dynamic map, List<dynamic> keys) {
    final value = _get<dynamic>(map, keys, null);

    const defaultValue = 0.0;
    if (value == null) {
      return defaultValue;
    }
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }
    _log.warning('fail to parse double: $keys: $value');
    return defaultValue;
  }

  int _parseInt(dynamic map, List<dynamic> keys) {
    final value = _get<dynamic>(map, keys, null);
    
    const defaultValue = 0;
    if (value == null) {
      return defaultValue;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    _log.warning('fail to parse int: $keys: $value');
    return defaultValue;
  }

  String _parseString(dynamic map, List<dynamic> keys) {
    final value = _get<String?>(map, keys, null);
    if (value == null) {
      return '';
    }
    return value;
  }

  final _markdownRegExp = RegExp('#+');

  String _parseMarkdown(dynamic map, List<dynamic> keys) {
    final value = _get<String?>(map, keys, null);
    if (value == null || value == '') {
      return '';
    }
    return value
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAllMapped(_markdownRegExp, (m) {
      return ' ${m.group(0)} ';
    });
  }

  bool _parseBool(dynamic map, List<dynamic> keys) {
    final value = _get<bool?>(map, keys, null);
    if (value == null) {
      return false;
    }
    return value;
  }

  List<String> _parseListString(dynamic map, List<dynamic> keys) {
    final value = _get<List<dynamic>?>(map, keys, null);
    if (value == null) {
      return [];
    }
    return value
        .map((v) => _cast<String>(v, ''))
        .where((v) => v != '')
        .toList();
  }

  dynamic _getNestedValue(dynamic map, List<dynamic> keys) {
    dynamic current = map;
    for (final key in keys) {
      if (current is List && key is int) {
        current = current[key];
      } else if (current is Map) {
        current = current[key];
      } else {
        return null;
      }
    }
    return current;
  }

  T _get<T>(dynamic map, List<dynamic> keys, T defaultValue) {
    final value = _getNestedValue(map, keys);
    if (value is T) {
      return value;
    }
    _log.warning('fail to cast: $keys:<${value.runtimeType}> to <$T>');
    return defaultValue;
  }

  T _cast<T>(dynamic value, T defaultValue) {
    if (value is T) {
      return value;
    }
    return defaultValue;
  }

  List<R> _parseIterable<T, R>(Iterable<T> s, R Function(T) parser) {
    return s.map((v) => _try(() => parser(v))).whereType<R>().toList();
  }

  T? _try<T>(T Function() fn) {
    try {
      return fn();
      // ignore: avoid_catching_errors
    } on TypeError catch (e, st) {
      _log.warning('', e, st);
    } on Exception catch (e, st) {
      _log.warning('', e, st);
    }
    return null;
  }
}
