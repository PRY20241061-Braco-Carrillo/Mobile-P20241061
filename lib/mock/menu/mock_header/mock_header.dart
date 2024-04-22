import "dart:convert";

import "../../../shared/widgets/global/header/header.types.dart";
import "package:flutter/services.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class MockHeaderCardService {
  Future<HeaderFullData> cargarDatosHeader() async {
    try {
      // ignore: always_specify_types
      await Future.delayed(const Duration(seconds: 3));
      final String jsonString = await rootBundle
          .loadString("lib/mock/json/header_full_card_data.json");
      // ignore: always_specify_types
      final jsonResponse = json.decode(jsonString);
      return HeaderFullData.fromJson(jsonResponse);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      rethrow;
    }
  }
}

final Provider<MockHeaderCardService> mockHeaderCardServiceProvider =
    Provider<MockHeaderCardService>((ProviderRef<MockHeaderCardService> ref) {
  return MockHeaderCardService();
});

final AutoDisposeFutureProvider<HeaderFullData> headerProvider =
    FutureProvider.autoDispose<HeaderFullData>(
        (AutoDisposeFutureProviderRef<HeaderFullData> ref) async {
  final MockHeaderCardService service =
      ref.watch(mockHeaderCardServiceProvider);
  try {
    return await service.cargarDatosHeader();
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    throw Exception("Error fetching header data");
  }
});

class MockHeaderCardServiceIcon {
  Future<HeaderIconData> cargarDatosHeader() async {
    try {
      // ignore: always_specify_types
      await Future.delayed(const Duration(seconds: 3));
      final String jsonString =
          await rootBundle.loadString("lib/mock/json/header_icon_data.json");
      // ignore: always_specify_types
      final jsonResponse = json.decode(jsonString);
      return HeaderIconData.fromJson(jsonResponse);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}

final Provider<MockHeaderCardServiceIcon> mockHeaderCardServiceProviderIcon =
    Provider<MockHeaderCardServiceIcon>(
        (ProviderRef<MockHeaderCardServiceIcon> ref) {
  return MockHeaderCardServiceIcon();
});

final AutoDisposeFutureProvider<HeaderIconData> headerProviderIcon =
    FutureProvider.autoDispose<HeaderIconData>(
        (AutoDisposeFutureProviderRef<HeaderIconData> ref) async {
  final MockHeaderCardServiceIcon service =
      ref.watch(mockHeaderCardServiceProviderIcon);
  try {
    return await service.cargarDatosHeader();
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    throw Exception("Error fetching header data");
  }
});
