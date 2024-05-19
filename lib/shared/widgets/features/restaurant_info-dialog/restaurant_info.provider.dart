import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../core/managers/generic_cache_manager_mock.dart";
import "../../../providers/generic_service_mock_provider.dart";
import "restaurant_dialog.types.dart";

final AutoDisposeFutureProviderFamily<RestaurantInfoData, String>
    restaurantInfoProvider = FutureProvider.autoDispose
        .family<RestaurantInfoData, String>(
            (AutoDisposeFutureProviderRef<RestaurantInfoData> ref,
                String id) async {
  final GenericCacheManager<RestaurantInfoData> service =
      ref.watch(genericDataServiceProvider(id));
  return service.loadData();
});
