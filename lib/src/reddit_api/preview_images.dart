import 'package:equatable/equatable.dart';

class Preview extends Equatable {
  const Preview({
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

  @override
  List<Object> get props => [source, resolutions];
}

class PreviewItem extends Equatable {
  const PreviewItem({
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

  @override
  List<Object> get props => [url, width, height];
}
