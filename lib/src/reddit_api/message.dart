import 'package:equatable/equatable.dart';

class Message extends Equatable {
  const Message({
    required this.subreddit,
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

  final String subreddit;
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

  @override
  List<Object> get props {
    return [
      subreddit,
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
