import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../constants/app_keys.dart";

final Provider<SharedPreferencesService> sharedPreferencesServiceProvider =
    Provider<SharedPreferencesService>(
        (ProviderRef<SharedPreferencesService> ref) {
  return SharedPreferencesService.instance;
});

class SharedPreferencesService {
  SharedPreferencesService._privateConstructor();

  static final SharedPreferencesService _instance =
      SharedPreferencesService._privateConstructor();
  static SharedPreferencesService get instance => _instance;

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setOnboardingComplete(bool value) async {
    return await _prefs?.setBool(AppKeys.onboardingComplete, value) ?? false;
  }

  bool getOnboardingComplete() {
    return _prefs?.getBool(AppKeys.onboardingComplete) ?? false;
  }

  Future<bool> removeOnboardingComplete() async {
    return await _prefs?.remove(AppKeys.onboardingComplete) ?? false;
  }

  Future<bool> setHeaders(String headersJson) async {
    return await _prefs?.setString(AppKeys.headers, headersJson) ?? false;
  }

  String? getHeaders() {
    return _prefs?.getString(AppKeys.headers);
  }

  Future<bool> removeHeaders() async {
    return await _prefs?.remove(AppKeys.headers) ?? false;
  }

  Future<bool> setHeadersVersion(String version) async {
    return await _prefs?.setString(AppKeys.headersVersion, version) ?? false;
  }

  String? getHeadersVersion() {
    return _prefs?.getString(AppKeys.headersVersion);
  }
}
