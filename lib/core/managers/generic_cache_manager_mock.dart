import "dart:convert";

import "package:flutter/services.dart";
import "package:flutter_cache_manager/flutter_cache_manager.dart";

class GenericCacheManager<T> {
  final CacheManager cacheManager;
  final String cacheKey;
  final String assetPath;
  final T Function(Map<String, dynamic> json) fromJson;

  GenericCacheManager({
    CacheManager? cacheManager,
    required this.cacheKey,
    required this.assetPath,
    required this.fromJson,
  }) : cacheManager = cacheManager ?? DefaultCacheManager();

  Future<T> loadData() async {
    try {
      final FileInfo? file = await cacheManager.getFileFromCache(cacheKey);
      if (file != null) {
        try {
          final String jsonString = await file.file.readAsString();
          final dynamic jsonResponse = json.decode(jsonString);
          return fromJson(jsonResponse);
          // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          await cacheManager.removeFile(cacheKey);
          return await fetchDataFromBundle();
        }
      } else {
        return await fetchDataFromBundle();
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      rethrow;
    }
  }

  Future<T> fetchDataFromBundle() async {
    final String jsonString = await rootBundle.loadString(assetPath);
    // ignore: always_specify_types
    final jsonResponse = json.decode(jsonString);
    await cacheManager.putFile(
      cacheKey,
      Uint8List.fromList(utf8.encode(jsonString)),
      fileExtension: "json",
    );
    return fromJson(jsonResponse);
  }
}
