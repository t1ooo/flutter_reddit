import 'package:equatable/equatable.dart';

import '../util/map.dart';
import 'parse.dart';

class Trophy extends Equatable {
  Trophy({
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

  factory Trophy.fromJson(Map data) {
    return Trophy(
      icon70: mapGet(data, 'icon_70', ''),
      grantedAt: parseTime(data['granted_at']),
      url: mapGet(data, 'url', ''),
      icon40: mapGet(data, 'icon_40', ''),
      name: mapGet(data, 'name', ''),
      awardId: mapGet(data, 'award_id', ''),
      id: mapGet(data, 'id', ''),
      description: mapGet(data, 'description', ''),
    );
  }

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
