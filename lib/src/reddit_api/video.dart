import 'package:equatable/equatable.dart';
import 'package:flutter_reddit_prototype/src/reddit_api/parse.dart';

class Video extends Equatable {
  Video({
    required this.bitrateKbps,
    required this.fallbackUrl,
    required this.height,
    required this.width,
    required this.scrubberMediaUrl,
    required this.duration,
    required this.isGif,
  });

  factory Video.fromJson(Map<String, dynamic> m) {
    const f = 'Video';
    return Video(
      bitrateKbps: parseInt(m['bitrate_kbps'], '$f.bitrate_kbps'),
      fallbackUrl: parseUrl(m['fallback_url'], '$f.fallback_url'),
      height: parseDouble(m['height'], '$f.height'),
      width: parseDouble(m['width'], '$f.width'),
      scrubberMediaUrl:
          parseUrl(m['scrubber_media_url'], '$f.scrubber_media_url'),
      duration: parseInt(m['duration'], '$f.duration'),
      isGif: parseBool(m['is_gif'], '$f.is_gif'),
    );
  }

  final int bitrateKbps;
  final String fallbackUrl;
  final double height;
  final double width;
  final String scrubberMediaUrl;
  final int duration;
  final bool isGif;

  Video copyWith({
    int? bitrateKbps,
    String? fallbackUrl,
    double? height,
    double? width,
    String? scrubberMediaUrl,
    int? duration,
    bool? isGif,
  }) {
    return Video(
      bitrateKbps: bitrateKbps ?? this.bitrateKbps,
      fallbackUrl: fallbackUrl ?? this.fallbackUrl,
      height: height ?? this.height,
      width: width ?? this.width,
      scrubberMediaUrl: scrubberMediaUrl ?? this.scrubberMediaUrl,
      duration: duration ?? this.duration,
      isGif: isGif ?? this.isGif,
    );
  }

  @override
  List<Object> get props {
    return [
      bitrateKbps,
      fallbackUrl,
      height,
      width,
      scrubberMediaUrl,
      duration,
      isGif,
    ];
  }
}
