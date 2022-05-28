import 'package:equatable/equatable.dart';

class Trophy extends Equatable {
  const Trophy({
    required this.icon70,
    required this.grantedAt,
    required this.url,
    required this.icon40,
    required this.name,
    required this.awardId,
    required this.id,
    required this.description,
  });

  final String icon70;
  final DateTime grantedAt;
  final String url;
  final String icon40;
  final String name;
  final String awardId;
  final String id;
  final String description;

  @override
  List<Object> get props {
    return [
      icon70,
      grantedAt,
      url,
      icon40,
      name,
      awardId,
      id,
      description,
    ];
  }
}
