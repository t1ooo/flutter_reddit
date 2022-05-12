import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../logging/logging.dart';
import 'parse.dart';

class Preview extends Equatable {
  PreviewItem? images;
  PreviewItem? gifs;
  PreviewItem? mp4;

  Preview({
    required this.images,
    required this.gifs,
    required this.mp4,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [images, gifs, mp4];

  Preview copyWith({
    PreviewItem? Function()? images,
    PreviewItem? Function()? gifs,
    PreviewItem? Function()? mp4,
  }) {
    return Preview(
      images: images != null ? images() : this.images,
      gifs: gifs != null ? gifs() : this.gifs,
      mp4: mp4 != null ? mp4() : this.mp4,
    );
  }

  factory Preview.fromJson(Map<String, dynamic> map) {
    return Preview(
      images: PreviewItem.fromJsonN(map),
      gifs: PreviewItem.fromJsonN(map['variants']?['gif']),
      mp4: PreviewItem.fromJsonN(map['variants']?['mp4']),
    );
  }
}

class PreviewItem extends Equatable {
  PreviewItem({
    required this.source,
    required this.resolutions,
    // required this.gifs,
  });

  final SizedPreview source;
  final List<SizedPreview> resolutions;
  // final PreviewImages? gifs;

  PreviewItem copyWith({
    SizedPreview? source,
    List<SizedPreview>? resolutions,
    // PreviewImages? Function()? gifs,
  }) {
    return PreviewItem(
      source: source ?? this.source,
      resolutions: resolutions ?? this.resolutions,
      // gifs: gifs != null ? gifs() : this.gifs,
    );
  }

  factory PreviewItem.fromJson(Map<String, dynamic> m) {
    return PreviewItem(
      source: SizedPreview.fromJson(m['source']),
      resolutions: List<SizedPreview>.from(
          m['resolutions']?.map((x) => SizedPreview.fromJson(x))),
      // gifs: fromJsonN(m['variants']?['gif']),
    );
  }

  static PreviewItem? fromJsonN(m) {
    return (m is Map<String, dynamic>) ? PreviewItem.fromJson(m) : null;
  }

  @override
  List<Object> get props => [source, resolutions];
}

class SizedPreview extends Equatable {
  SizedPreview({
    required this.url,
    required this.width,
    required this.height,
  });

  final String url;
  final double width;
  final double height;

  // static final _log = getLogger('SizedImage');

  SizedPreview copyWith({
    String? url,
    double? width,
    double? height,
  }) {
    return SizedPreview(
      url: url ?? this.url,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  factory SizedPreview.fromJson(Map<String, dynamic> m) {
    const f = 'SizedImage';
    return SizedPreview(
      url: parseUrl(m['url'], '$f.url'),
      width: parseDouble(m['width'], '$f.width'),
      height: parseDouble(m['height'], '$f.height'),
    );
  }

  @override
  List<Object> get props => [url, width, height];
}
