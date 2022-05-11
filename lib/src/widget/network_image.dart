import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';

import '../logger.dart';
import '../logging/logging.dart';

// Widget voidError(_, __) => Container();

// class CustomNetworkImage extends StatelessWidget {
//   static final _log = getLogger('CustomNetworkImage');

//   const CustomNetworkImage(
//     this.src, {
//     Key? key,
//     this.width,
//     this.height,
//     this.imageBuilder,
//   }) : super(key: key);

//   final String src;
//   final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder;
//   final double? width;
//   final double? height;

//   @override
//   Widget build(BuildContext context) {
//     // return Image.network(
//     //   src,
//     //   width: width,
//     //   height: width,
//     //   errorBuilder: (_, e, st) {
//     //     _log.info('', e);
//     //     return Container();
//     //   },
//     // );
//     return CachedNetworkImage(
//       imageUrl: src,
//       width: width,
//       height: height,
//       imageBuilder: imageBuilder,
//       placeholder: (context, url) => CircularProgressIndicator(),
//       errorWidget: (context, url, error) {
//         _log.info('', error);
//         return Icon(Icons.error);
//       },
//     );
//   }
// }

class CustomNetworkImage extends StatelessWidget {
  CustomNetworkImage(
    this.src, {
    Key? key,
    this.onData,
    this.onError,
    this.onLoading,
  }) : super(key: key);

  final String src;
  final Widget Function(BuildContext, ImageProvider<Object>)? onData;
  final Widget Function(BuildContext, Object)? onError;
  final Widget Function(BuildContext)? onLoading;

  @override
  Widget build(BuildContext context) {
    if (src == '') {
      return (onError ?? onErrorDefault)(context, 'src is empty');
    }
    return CachedNetworkImage(
      imageUrl: src,
      cacheManager: context.read<CacheManager>(),
      imageBuilder: (context, imageProvider) =>
          (onData ?? onDataDefault)(context, imageProvider),
      placeholder: (context, url) => (onLoading ?? onLoadingDefault)(context),
      errorWidget: (context, url, error) =>
          (onError ?? onErrorDefault)(context, error),
    );
  }

  Widget onDataDefault(BuildContext context, ImageProvider<Object> image) {
    return Image(
      image: image,
      errorBuilder: (_, e, __) => (onError ?? onErrorDefault)(context, e),
    );
  }

  Widget onLoadingDefault(BuildContext context) {
    return Container();
  }

  Widget onErrorDefault(BuildContext context, Object error) {
    uiLogger.error('$error');
    return Container();
  }
}

// Widget imageErrorBuilder(BuildContext context, Object error) {
//   uiLogger.error('$error');
//   return Container();
// }

Widget imageErrorBuilder(BuildContext context, Object error, dynamic st) {
  uiLogger.error('$error');
  return Container();
}

class CustomNetworkImageBuilder extends StatelessWidget {
  const CustomNetworkImageBuilder(
    this.src, {
    Key? key,
    // this.width,
    // this.height,
    this.builder,
  }) : super(key: key);

  final String src;
  final Widget Function(BuildContext, ImageProvider<Object>?, Object?)? builder;
  // final double? width;
  // final double? height;

  @override
  Widget build(BuildContext context) {
    // return Image.network(
    //   src,
    //   width: width,
    //   height: width,
    //   errorBuilder: (_, e, st) {
    //     _log.info('', e);
    //     return Container();
    //   },
    // );
    if (src == '') {
      return (builder ?? builderDefault)(context, null, 'src is empty');
    }
    return CachedNetworkImage(
      imageUrl: src,
      // width: width,
      // height: height,
      cacheManager: context.read<CacheManager>(),
      imageBuilder: (context, imageProvider) =>
          (builder ?? builderDefault)(context, imageProvider, null),
      placeholder: (context, url) =>
          (builder ?? builderDefault)(context, null, null),
      errorWidget: (context, url, error) =>
          (builder ?? builderDefault)(context, null, error),
    );
  }

  Widget builderDefault(
    BuildContext context,
    ImageProvider<Object>? image,
    Object? error,
  ) {
    if (error != null) {
      uiLogger.error('$error');
      return Container();
    }
    if (image != null) {
      return Image(
        image: image,
        errorBuilder: (_, e, __) {
          uiLogger.error('$e');
          return Container();
        },
      );
    }
    return Container();
  }
}
