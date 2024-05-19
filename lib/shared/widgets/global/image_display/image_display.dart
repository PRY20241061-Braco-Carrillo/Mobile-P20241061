import "package:cached_network_image/cached_network_image.dart";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../providers/image_provider.dart";

class ImageDisplay extends ConsumerWidget {
  final ImageConfig config;

  const ImageDisplay({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: _getImageWidget(
        config.imageUrl,
        config.width,
        config.height,
        config.fit,
        config.errorAssetPath,
        config.onErrorWidth,
        config.onErrorHeight,
        config.onErrorFit,
        config.padding,
        config.onErrorPadding,
      ),
    );
  }

  Widget _getImageWidget(
    String? url,
    double width,
    double height,
    BoxFit fit,
    String errorAssetPath,
    double onErrorWidth,
    double onErrorHeight,
    BoxFit onErrorFit,
    EdgeInsets? padding,
    EdgeInsets? onErrorPadding,
  ) {
    if (url == null) {
      return Padding(
        padding: onErrorPadding ?? const EdgeInsets.all(0),
        child: SvgPicture.asset(
          errorAssetPath,
          height: onErrorHeight,
          fit: onErrorFit,
          width: onErrorWidth,
        ),
      );
    } else if (url.endsWith(".svg")) {
      return FutureBuilder<bool>(
        future: _checkSvgNetwork(url),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: width,
              height: height,
              child: const Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError ||
              (snapshot.hasData && !snapshot.data!)) {
            return Padding(
              padding: onErrorPadding ?? const EdgeInsets.all(0),
              child: SvgPicture.asset(
                errorAssetPath,
                height: onErrorHeight,
                fit: onErrorFit,
                width: onErrorWidth,
              ),
            );
          } else {
            return Padding(
              padding: padding ?? const EdgeInsets.all(0),
              child: SvgPicture.network(
                url,
                width: width,
                height: height,
                fit: fit,
                placeholderBuilder: (BuildContext context) => SizedBox(
                  width: width,
                  height: height,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            );
          }
        },
      );
    } else {
      return Padding(
        padding: padding ?? const EdgeInsets.all(0),
        child: CachedNetworkImage(
          imageUrl: url,
          width: width,
          height: height,
          fit: fit,
          placeholder: (BuildContext context, String url) => SizedBox(
              width: width,
              height: height,
              child: const Center(child: CircularProgressIndicator())),
          errorWidget: (BuildContext context, String url, Object error) =>
              Padding(
            padding: onErrorPadding ?? const EdgeInsets.all(0),
            child: SvgPicture.asset(
              errorAssetPath,
              height: onErrorHeight,
              fit: onErrorFit,
              width: onErrorWidth,
            ),
          ),
        ),
      );
    }
  }

  Future<bool> _checkSvgNetwork(String url) async {
    try {
      final response = await Dio().get(url);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
