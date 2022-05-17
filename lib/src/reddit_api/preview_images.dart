import 'package:equatable/equatable.dart';

import 'parse.dart';

class Previews extends Equatable {
  Preview? images;
  Preview? gifs;
  Preview? mp4;

  Previews({
    required this.images,
    required this.gifs,
    required this.mp4,
  });

  @override
  List<Object?> get props => [images, gifs, mp4];

  Previews copyWith({
    Preview? Function()? images,
    Preview? Function()? gifs,
    Preview? Function()? mp4,
  }) {
    return Previews(
      images: images != null ? images() : this.images,
      gifs: gifs != null ? gifs() : this.gifs,
      mp4: mp4 != null ? mp4() : this.mp4,
    );
  }

  factory Previews.fromJson(Map<String, dynamic> map) {
    return Previews(
      images: Preview.fromJsonN(map),
      gifs: Preview.fromJsonN(map['variants']?['gif']),
      mp4: Preview.fromJsonN(map['variants']?['mp4']),
    );
  }
}

class Preview extends Equatable {
  Preview({
    required this.source,
    required this.resolutions,
  });

  final PreviewItem source;
  final List<PreviewItem> resolutions;

  Preview copyWith({
    PreviewItem? source,
    List<PreviewItem>? resolutions,
  }) {
    return Preview(
      source: source ?? this.source,
      resolutions: resolutions ?? this.resolutions,
    );
  }

  factory Preview.fromJson(Map<String, dynamic> m) {
    return Preview(
      source: PreviewItem.fromJson(m['source']),
      resolutions: List<PreviewItem>.from(
          m['resolutions']?.map((x) => PreviewItem.fromJson(x))),
    );
  }

  static Preview? fromJsonN(dynamic m) {
    return (m is Map<String, dynamic>) ? Preview.fromJson(m) : null;
  }

  @override
  List<Object> get props => [source, resolutions];
}

class PreviewItem extends Equatable {
  PreviewItem({
    required this.url,
    required this.width,
    required this.height,
  });

  final String url;
  final double width;
  final double height;

  PreviewItem copyWith({
    String? url,
    double? width,
    double? height,
  }) {
    return PreviewItem(
      url: url ?? this.url,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  factory PreviewItem.fromJson(Map<String, dynamic> m) {
    const f = 'SizedImage';
    return PreviewItem(
      url: parseUrl(m['url'], '$f.url'),
      width: parseDouble(m['width'], '$f.width'),
      height: parseDouble(m['height'], '$f.height'),
    );
  }

  @override
  List<Object> get props => [url, width, height];
}
