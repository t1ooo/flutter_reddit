import 'package:equatable/equatable.dart';
import 'package:flutter_reddit_prototype/src/reddit_api/parse.dart';

import '../logging/logging.dart';

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

  final int bitrateKbps;
  final String fallbackUrl;
  final int height;
  final int width;
  final String scrubberMediaUrl;
  final int duration;
  final bool isGif;

  static final _log = getLogger('Video');

  Video copyWith({
    int? bitrate_kbps,
    String? fallback_url,
    int? height,
    int? width,
    String? scrubber_media_url,
    int? duration,
    bool? is_gif,
  }) {
    return Video(
      bitrateKbps: bitrate_kbps ?? this.bitrateKbps,
      fallbackUrl: fallback_url ?? this.fallbackUrl,
      height: height ?? this.height,
      width: width ?? this.width,
      scrubberMediaUrl: scrubber_media_url ?? this.scrubberMediaUrl,
      duration: duration ?? this.duration,
      isGif: is_gif ?? this.isGif,
    );
  }

  factory Video.fromJson(Map map) {
    return Video(
      bitrateKbps: parseInt(map['bitrate_kbps'], _log),
      fallbackUrl: parseUrl(map['fallback_url'], _log),
      height: parseInt(map['height'], _log),
      width: parseInt(map['width'], _log),
      scrubberMediaUrl: parseUrl(map['scrubber_media_url']),
      duration: parseInt(map['duration']),
      isGif: cast(map['is_gif'], false, _log),
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
