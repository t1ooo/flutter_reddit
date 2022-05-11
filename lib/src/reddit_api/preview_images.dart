import 'package:equatable/equatable.dart';

import 'parse.dart';

class PreviewImages extends Equatable {
  final SizedImage source;
  final List<SizedImage> resolutions;

  PreviewImages({
    required this.source,
    required this.resolutions,
  });

  PreviewImages copyWith({
    SizedImage? source,
    List<SizedImage>? resolutions,
  }) {
    return PreviewImages(
      source: source ?? this.source,
      resolutions: resolutions ?? this.resolutions,
    );
  }

  factory PreviewImages.fromJson(Map<String, dynamic> map) {
    return PreviewImages(
      source: SizedImage.fromJson(map['source']),
      resolutions: List<SizedImage>.from(
          map['resolutions']?.map((x) => SizedImage.fromJson(x)) ?? const []),
    );
  }

  @override
  List<Object> get props => [source, resolutions];
}

class SizedImage extends Equatable {
  final String url;
  final double width;
  final double height;
  SizedImage({
    required this.url,
    required this.width,
    required this.height,
  });

  SizedImage copyWith({
    String? url,
    double? width,
    double? height,
  }) {
    return SizedImage(
      url: url ?? this.url,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  factory SizedImage.fromJson(Map<String, dynamic> map) {
    return SizedImage(
      url: parseUrl(map['url']),
      width: _tryParseDouble(map['width']) ?? 0,
      height: _tryParseDouble(map['height']) ?? 0,
    );
  }

  @override
  List<Object> get props => [url, width, height];
}

double? _tryParseDouble(dynamic value) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}
