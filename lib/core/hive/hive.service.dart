import "dart:io";

import "package:hive/hive.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:path_provider/path_provider.dart";

final Provider<HiveService> hiveServiceProvider = Provider<HiveService>(
  (ProviderRef<HiveService> ref) => HiveService.instance,
);

class HiveService {
  static final HiveService _instance = HiveService._privateConstructor();
  static HiveService get instance => _instance;

  HiveService._privateConstructor();

  Future<void> init() async {
    final Directory appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    //Hive.registerAdapter(RestaurantResponseAdapter());
    //Hive.registerAdapter(ListRestaurantResponseAdapter());
  }

  Future<Box<T>> safeOpenBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
  }
/*
  Future<void> putRestaurants(List<RestaurantResponse> restaurants) async {
    final Box<ListRestaurantResponse> box =
        await safeOpenBox<ListRestaurantResponse>(AppKeysHive.boxName);
    await box.put(AppKeysHive.restaurants,
        ListRestaurantResponse(restaurants: restaurants));
    await box.close();
  }

  Future<List<RestaurantResponse>?> getRestaurants() async {
    final Box<ListRestaurantResponse> box =
        await safeOpenBox<ListRestaurantResponse>(AppKeysHive.boxName);
    final ListRestaurantResponse? listResponse =
        box.get(AppKeysHive.restaurants);
    await box.close();
    return listResponse?.restaurants;
  }
*/
}
