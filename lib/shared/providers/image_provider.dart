import "package:file/src/interface/file.dart";
import "package:flutter/material.dart";
import "package:flutter_cache_manager/flutter_cache_manager.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class ImageConfig {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final Map<String, String>? headers;
  final int? maxWidth;
  final int? maxHeight;

  ImageConfig({
    required this.imageUrl,
    this.width = 100.0,
    this.height = 100.0,
    this.fit = BoxFit.cover,
    this.headers,
    this.maxWidth,
    this.maxHeight,
  });
}

final FutureProviderFamily<ImageProvider<Object>, ImageConfig> imageProviderCache =
    FutureProvider.family<ImageProvider, ImageConfig>((FutureProviderRef<ImageProvider<Object>> ref, ImageConfig config) async {
  final DefaultCacheManager cacheManager = DefaultCacheManager();
  try {
    final File file = await cacheManager.getSingleFile(config.imageUrl,
        headers: config.headers);
    return FileImage(file);
  } catch (e) {
    debugPrint("Error fetching image from cache: $e");
    rethrow;
  }
});
