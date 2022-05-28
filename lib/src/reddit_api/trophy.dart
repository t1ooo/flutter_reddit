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

  // factory Trophy.fromJson(Map<String, dynamic> m) {
  //   const f = 'Trophy';
  //   return Trophy(
  //     icon70: parseString(m['icon_70'], '$f.icon_70'),
  //     grantedAt: parseTime(m['granted_at'], '$f.granted_at'),
  //     url: parseString(m['url'], '$f.url'),
  //     icon40: parseString(m['icon_40'], '$f.icon_40'),
  //     name: parseString(m['name'], '$f.name'),
  //     awardId: parseString(m['award_id'], '$f.award_id'),
  //     id: parseString(m['id'], '$f.id'),
  //     description: parseString(m['description'], '$f.description'),
  //   );
  // }

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
