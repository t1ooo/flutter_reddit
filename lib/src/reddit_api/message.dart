import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../logging/logging.dart';
import 'parse.dart';

class Message extends Equatable {
  final String subreddit;
  // final List<Message> replies;
  final String authorFullname;
  final String id;
  final String subject;
  final String author;
  final int numComments;
  final int parentId;
  final String subredditNamePrefixed;
  final bool new_;
  final String body;
  final String dest;
  final bool wasComment;
  final String bodyHtml;
  final String name;
  final DateTime created;
  final DateTime createdUtc;
  final String distinguished;

  // static final _log = getLogger('Message');

  Message({
    required this.subreddit,
    // required this.replies,
    required this.authorFullname,
    required this.id,
    required this.subject,
    required this.author,
    required this.numComments,
    required this.parentId,
    required this.subredditNamePrefixed,
    required this.new_,
    required this.body,
    required this.dest,
    required this.wasComment,
    required this.bodyHtml,
    required this.name,
    required this.created,
    required this.createdUtc,
    required this.distinguished,
  });

  // static const _descLen = 150;
  // String get desc {
  //   final text = body.replaceAll(RegExp(r'\s+'), ' ');
  //   return text.length <= _descLen ? text : text.substring(0, _descLen) + '...';
  // }

  Message copyWith({
    String? subreddit,
    List<dynamic>? replies,
    String? authorFullname,
    String? id,
    String? subject,
    String? author,
    int? numComments,
    int? parentId,
    String? subredditNamePrefixed,
    bool? new_,
    String? body,
    String? dest,
    bool? wasComment,
    String? bodyHtml,
    String? name,
    DateTime? created,
    DateTime? createdUtc,
    String? distinguished,
  }) {
    return Message(
      subreddit: subreddit ?? this.subreddit,
      // replies: replies ?? this.replies,
      authorFullname: authorFullname ?? this.authorFullname,
      id: id ?? this.id,
      subject: subject ?? this.subject,
      author: author ?? this.author,
      numComments: numComments ?? this.numComments,
      parentId: parentId ?? this.parentId,
      subredditNamePrefixed:
          subredditNamePrefixed ?? this.subredditNamePrefixed,
      new_: new_ ?? this.new_,
      body: body ?? this.body,
      dest: dest ?? this.dest,
      wasComment: wasComment ?? this.wasComment,
      bodyHtml: bodyHtml ?? this.bodyHtml,
      name: name ?? this.name,
      created: created ?? this.created,
      createdUtc: createdUtc ?? this.createdUtc,
      distinguished: distinguished ?? this.distinguished,
    );
  }

  factory Message.fromJson(Map<String, dynamic> m) {
    const f = 'message';
    return Message(
      subreddit: parseString(m['subreddit_id'], '$f.subreddit_id'),
      // replies: List<dynamic>.from(m['replies'] ?? const []),
      authorFullname:
          parseString(m['author_fullname'], '$f.author_fullname'),
      id: parseString(m['id'], '$f.id'),
      subject: parseString(m['subject'], '$f.subject'),
      author: parseString(m['author'], '$f.author'),
      numComments: parseInt(m['num_comments'], '$f.num_comments'),
      parentId: parseInt(m['parent_Id'], '$f.parent_Id'),
      subredditNamePrefixed: parseString(
          m['subreddit_name_prefixed'], '$f.subreddit_name_prefixed'),
      new_: parseBool(m['new'], '$f.new'),
      body: parseString(m['body'], '$f.body'),
      dest: parseString(m['dest'], '$f.dest'),
      wasComment: parseBool(m['was_comment'], '$f.wasComment'),
      bodyHtml: parseString(m['body_html'], '$f.bodyHtml'),
      name: parseString(m['name'], '$f.name'),
      created: parseTime(m['created'], '$f.created'),
      createdUtc: parseTimeUtc(m['created_utc'], '$f.created_utc'),
      distinguished: parseString(m['distinguished'], '$f.distinguished'),
    );
  }

  @override
  List<Object> get props {
    return [
      subreddit,
      // replies,
      authorFullname,
      id,
      subject,
      author,
      numComments,
      parentId,
      subredditNamePrefixed,
      new_,
      body,
      dest,
      wasComment,
      bodyHtml,
      name,
      created,
      createdUtc,
      distinguished,
    ];
  }
}
