import 'package:equatable/equatable.dart';

import 'parse.dart';

// import 'parse.dart';

class Rule extends Equatable {
  final String kind;
  final String description;
  final String shortName;
  final String violationReason;
  final DateTime createdUtc;
  final int priority;
  final String descriptionHtml;

  Rule({
    required this.kind,
    required this.description,
    required this.shortName,
    required this.violationReason,
    required this.createdUtc,
    required this.priority,
    required this.descriptionHtml,
  });

  factory Rule.fromJson(Map m) {
    const f = 'Rule';
    return Rule(
      kind: parseString(m['kind'], '$f.kind'),
      description: parseString(m['description'], '$f.description'),
      shortName: parseString(m['short_name'], '$f.short_name'),
      violationReason:
          parseString(m['violation_reason'], '$f.violation_reason'),
      createdUtc: parseTimeUtc(m['created_utc'], '$f.created_utc'),
      priority: parseInt(m['priority'], '$f.priority'),
      descriptionHtml:
          parseString(m['description_html'], '$f.description_html'),
    );
  }

  @override
  // TODO: implement props
  List<Object> get props {
    return [
      kind,
      description,
      shortName,
      violationReason,
      createdUtc,
      priority,
      descriptionHtml,
    ];
  }

  Rule copyWith({
    String? kind,
    String? description,
    String? shortName,
    String? violationReason,
    DateTime? createdUtc,
    int? priority,
    String? descriptionHtml,
  }) {
    return Rule(
      kind: kind ?? this.kind,
      description: description ?? this.description,
      shortName: shortName ?? this.shortName,
      violationReason: violationReason ?? this.violationReason,
      createdUtc: createdUtc ?? this.createdUtc,
      priority: priority ?? this.priority,
      descriptionHtml: descriptionHtml ?? this.descriptionHtml,
    );
  }
}
