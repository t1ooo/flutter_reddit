import 'package:equatable/equatable.dart';

class Rule extends Equatable {
  const Rule({
    required this.kind,
    required this.description,
    required this.shortName,
    required this.violationReason,
    required this.createdUtc,
    required this.priority,
    required this.descriptionHtml,
  });

  final String kind;
  final String description;
  final String shortName;
  final String violationReason;
  final DateTime createdUtc;
  final int priority;
  final String descriptionHtml;

  @override
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
