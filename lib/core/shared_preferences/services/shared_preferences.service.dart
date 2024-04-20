import "package:shared_preferences/shared_preferences.dart";
import "../constants/app_keys.dart";

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

  Future<bool> setGuest(bool isGuest) async {
    return await _prefs?.setBool(AppKeys.isGuest, isGuest) ?? false;
  }

  bool getGuest() {
    return _prefs?.getBool(AppKeys.isGuest) ?? false;
  }

  Future<bool> removeGuest() async {
    return await _prefs?.remove(AppKeys.isGuest) ?? false;
  }
}
