import "../../core/managers/cache_keys_mock.dart";
import "../../core/managers/generic_cache_manager_mock.dart";
import "../widgets/features/restaurant_info-dialog/restaurant_dialog.types.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

final ProviderFamily<GenericCacheManager<RestaurantInfoData>, String> genericDataServiceProvider =
    Provider.family<GenericCacheManager<RestaurantInfoData>, String>((ProviderRef<GenericCacheManager<RestaurantInfoData>> ref, String id) {
  return GenericCacheManager<RestaurantInfoData>(
    cacheKey: CacheKeys.restaurantData(id),
    assetPath: CacheKeys.restaurantDialogJson(id),
    fromJson: (Map<String, dynamic> json) => RestaurantInfoData.fromJson(json),
  );
});
