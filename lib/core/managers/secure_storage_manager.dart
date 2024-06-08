import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SecureStorageManager {
  static const String keyToken = "token";
  static const String keyUserId = "userId";
  static const String keyRole = "role";
  static const String keyGuest = "guest";
  static const String keyOrderInProgress = "orderInProgress";
  static const String keyOrderConfirmationToken = "orderConfirmationToken";
  static const String keyOrderRemainingTime = "orderRemainingTime";
  static const String keyOrderId = "orderId";

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> storeLoginData(String token, String userId, String role) async {
    await _storage.write(key: keyToken, value: token);
    await _storage.write(key: keyUserId, value: userId);
    await _storage.write(key: keyRole, value: role);
    await _storage.write(key: keyGuest, value: "false");
  }

  Future<void> storeGuestData(String token, String role) async {
    await _storage.write(key: keyToken, value: token);
    await _storage.write(key: keyRole, value: role);
    await _storage.write(key: keyGuest, value: "true");
  }

  Future<Map<String, dynamic>> getLoginData() async {
    final String? token = await _storage.read(key: keyToken);
    final String? userId = await _storage.read(key: keyUserId);
    final String? role = await _storage.read(key: keyRole);
    final String? guest = await _storage.read(key: keyGuest);
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

  Future<void> setOrderInProgress(bool inProgress) async {
    print('Storing order in progress: $inProgress');
    await _storage.write(key: keyOrderInProgress, value: inProgress.toString());
  }

  Future<bool> getOrderInProgress() async {
    final String? value = await _storage.read(key: keyOrderInProgress);
    final inProgress = value != null && value.toLowerCase() == 'true';
    print('Retrieving order in progress: $inProgress');
    return inProgress;
  }

  Future<void> setOrderConfirmationToken(String token) async {
    print('Storing order confirmation token: $token');
    await _storage.write(key: keyOrderConfirmationToken, value: token);
  }

  Future<String?> getOrderConfirmationToken() async {
    final token = await _storage.read(key: keyOrderConfirmationToken);
    print('Retrieving order confirmation token: $token');
    return token;
  }

  Future<void> setOrderRemainingTime(int time) async {
    print('Storing order remaining time: $time');
    await _storage.write(key: keyOrderRemainingTime, value: time.toString());
  }

  Future<int> getOrderRemainingTime() async {
    final String? value = await _storage.read(key: keyOrderRemainingTime);
    final remainingTime = value != null ? int.parse(value) : 300;
    print('Retrieving order remaining time: $remainingTime');
    return remainingTime;
  }

  Future<void> setOrderId(String orderId) async {
    print('Storing orderId: $orderId');
    await _storage.write(key: keyOrderId, value: orderId);
  }

  Future<String?> getOrderId() async {
    final orderId = await _storage.read(key: keyOrderId);
    print('Retrieving orderId: $orderId');
    return orderId;
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
