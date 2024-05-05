import "dart:convert";

import "package:flutter/foundation.dart";
import "package:flutter/services.dart";

import "../../shared/widgets/global/header/header.types.dart";
import "../shared_preferences/services/shared_preferences.service.dart";

class HeaderDataManager {
  static final HeaderDataManager _instance = HeaderDataManager._internal();
  late final Map<String, dynamic> _headers;

  HeaderDataManager._internal();

  factory HeaderDataManager() {
    return _instance;
  }

  Future<void> init() async {
    final SharedPreferencesService prefsService =
        SharedPreferencesService.instance;
    final String? headersJson = prefsService.getHeaders();

    if (headersJson == null) {
      await loadHeaders();
    } else {
      try {
        _headers = json.decode(headersJson) as Map<String, dynamic>;
      } on FormatException catch (e) {
        if (kDebugMode) {
          print("Error decoding headers: $e, attempting to load from JSON");
        }
        await loadHeaders();
      }
    }
  }

  Future<void> loadHeaders() async {
    try {
      final String jsonString =
          await rootBundle.loadString("assets/data/headers.json");

      final Map<String, dynamic> jsonResponse =
          json.decode(jsonString) as Map<String, dynamic>;

      if (jsonResponse.isEmpty) {
        if (kDebugMode) {
          print("Warning: JSON file is empty or incorrectly formatted.");
        }
      } else {
        final String jsonHeaders = json.encode(jsonResponse);
        await SharedPreferencesService.instance.setHeaders(jsonHeaders);
        _headers = jsonResponse;
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error loading headers from JSON: $e");
      }
    }
  }

  dynamic getHeader(String key) {
    if (_headers.containsKey(key)) {
      final dynamic headerMap = _headers[key];
      if (headerMap != null && headerMap is Map<String, dynamic>) {
        return _deserializeHeader(headerMap);
      } else {
        if (kDebugMode) {
          print("Data format error for key $key.");
        }
      }
    } else {
      if (kDebugMode) {
        print("No header configuration found for key $key.");
      }
    }
    return null;
  }

  dynamic _deserializeHeader(Map<String, dynamic> headerMap) {
    switch (headerMap["type"]) {
      case "HeaderFullData":
        return HeaderFullData.fromJson(headerMap);
      case "HeaderIconData":
        return HeaderIconData.fromJson(headerMap);
      default:
        if (kDebugMode) {
          print("Unknown type ${headerMap['type']}");
        }
        return null;
    }
  }
}
