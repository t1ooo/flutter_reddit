import 'package:equatable/equatable.dart';

import '../logging/logging.dart';
import 'parse.dart';

// class Preview extends Equatable {
//   PreviewImages images;
//   PreviewImages gifs;

//   @override
//   // TODO: implement props
//   List<Object?> get props => [images. gifs];
// }


class PreviewImages extends Equatable {
  PreviewImages({
    required this.source,
    required this.resolutions,
    required this.gifs,
  });

  final SizedImage source;
  final List<SizedImage> resolutions;
  final PreviewImages? gifs;

  PreviewImages copyWith({
    SizedImage? source,
    List<SizedImage>? resolutions,
    PreviewImages? Function()? gifs,
  }) {
    return PreviewImages(
      source: source ?? this.source,
      resolutions: resolutions ?? this.resolutions,
      gifs: gifs != null ? gifs() : this.gifs,
    );
  }

  factory PreviewImages.fromJson(Map<String, dynamic> m) {
    return PreviewImages(
      source: SizedImage.fromJson(m['source']),
      resolutions: List<SizedImage>.from(
          m['resolutions']?.map((x) => SizedImage.fromJson(x))),
      gifs: fromJsonN(m['variants']?['gif']),
    );
  }

  static PreviewImages? fromJsonN(m) {
    return (m is Map<String, dynamic>) ? PreviewImages.fromJson(m) : null;
  }

  @override
  List<Object> get props => [source, resolutions];
}

class SizedImage extends Equatable {
  SizedImage({
    required this.url,
    required this.width,
    required this.height,
  });

  final String url;
  final double width;
  final double height;

  // static final _log = getLogger('SizedImage');

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

  factory SizedImage.fromJson(Map<String, dynamic> m) {
    const f = 'SizedImage';
    return SizedImage(
      url: parseUrl(m['url'], '$f.url'),
      width: parseDouble(m['width'], '$f.width'),
      height: parseDouble(m['height'], '$f.height'),
    );
  }

  @override
  List<Object> get props => [url, width, height];
}
