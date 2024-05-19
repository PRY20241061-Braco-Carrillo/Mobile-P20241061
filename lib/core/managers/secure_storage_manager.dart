import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class SecureStorageManager {
  static const String keyToken = "token";
  static const String keyUserId = "userId";
  static const String keyRole = "role";
  static const String keyGuest = "guest";

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> storeLoginData(String token, String userId, String role) async {
    print("Storing token: $token");
    print("Storing userId: $userId");
    print("Storing role: $role");
    await _storage.write(key: keyToken, value: token);
    await _storage.write(key: keyUserId, value: userId);
    await _storage.write(key: keyRole, value: role);
    await _storage.write(key: keyGuest, value: "false");
  }

  Future<void> storeGuestData(String token, String role) async {
    print("Storing guest token: $token");
    print("Storing guest role: $role");
    await _storage.write(key: keyToken, value: token);
    await _storage.write(key: keyRole, value: role);
    await _storage.write(key: keyGuest, value: "true");
  }

  Future<Map<String, dynamic>> getLoginData() async {
    final String? token = await _storage.read(key: keyToken);
    final String? userId = await _storage.read(key: keyUserId);
    final String? role = await _storage.read(key: keyRole);
    final String? guest = await _storage.read(key: keyGuest);
    print("Read token: $token");
    print("Read userId: $userId");
    print("Read role: $role");
    return <String, dynamic>{
      keyToken: token,
      keyUserId: userId,
      keyRole: role,
      keyGuest: guest,
    };
  }

  Future<void> clearStorage() async {
    await _storage.deleteAll();
  }

  Future<bool> isAuthenticated() async {
    final String? token = await _storage.read(key: keyToken);
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
