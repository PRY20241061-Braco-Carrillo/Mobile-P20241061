import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class SecureStorageManager {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> storeLoginData(String token, String userId, String role) async {
    print("Storing token: $token");
    print("Storing userId: $userId");
    print("Storing role: $role");
    await _storage.write(key: "token", value: token);
    await _storage.write(key: "userId", value: userId);
    await _storage.write(key: "role", value: role);
    await _storage.write(key: "guest", value: "false");
  }

  Future<Map<String, dynamic>> getLoginData() async {
    final String? token = await _storage.read(key: "token");
    final String? userId = await _storage.read(key: "userId");
    final String? role = await _storage.read(key: "role");
    print("Read token: $token");
    print("Read userId: $userId");
    print("Read role: $role");
    return <String, dynamic>{
      "token": token,
      "userId": userId,
      "role": role,
    };
  }

  Future<void> clearStorage() async {
    await _storage.deleteAll();
  }

  Future<bool> isAuthenticated() async {
    final String? token = await _storage.read(key: "token");
    return token != null;
  }
}

final Provider<SecureStorageManager> secureStorageProvider =
    Provider<SecureStorageManager>((ProviderRef<SecureStorageManager> ref) {
  return SecureStorageManager();
});

final FutureProvider<Map<String, dynamic>> authDataProvider =
    FutureProvider<Map<String, dynamic>>(
        (FutureProviderRef<Map<String, dynamic>> ref) async {
  return ref.read(secureStorageProvider).getLoginData();
});
