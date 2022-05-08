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

  static final _log = getLogger('Message');

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
      subredditNamePrefixed: subredditNamePrefixed ?? this.subredditNamePrefixed,
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

  factory Message.fromJson(Map data) {
    return Message(
      subreddit: mapGet(data, 'subreddit_id', '', _log),
      // replies: List<dynamic>.from(data['replies'] ?? const []),
      authorFullname: mapGet(data, 'authorFullname', '', _log),
      id: mapGet(data, 'id', '', _log),
      subject: mapGet(data, 'subject', '', _log),
      author: mapGet(data, 'author', '', _log),
      numComments: mapGet(data, 'numComments', 0, _log),
      parentId: mapGet(data, 'parentId', 0, _log),
      subredditNamePrefixed: mapGet(data, 'subredditNamePrefixed', '', _log),
      new_: mapGet(data, 'new', false, _log),
      body: mapGet(data, 'body', '', _log),
      dest: mapGet(data, 'dest', '', _log),
      wasComment: mapGet(data, 'wasComment', false, _log),
      bodyHtml: mapGet(data, 'bodyHtml', '', _log),
      name: mapGet(data, 'name', '', _log),
      created: parseTime(data['created'], false, _log),
      createdUtc: parseTime(data['createdUtc'], true, _log),
      distinguished: mapGet(data, 'distinguished', '', _log),
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
