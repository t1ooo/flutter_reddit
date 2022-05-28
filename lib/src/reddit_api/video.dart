import 'package:equatable/equatable.dart';

class Video extends Equatable {
  const Video({
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
