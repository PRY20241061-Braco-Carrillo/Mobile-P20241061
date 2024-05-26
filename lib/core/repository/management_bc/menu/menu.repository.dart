import "package:dio/dio.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../constants/management_bc/menu/menu.constants.dart";

import "../../../models/base_response.dart";

import "../../../models/management/menu/menu_by_campus.response.types.dart";

import "../../../models/management/menu/menu_detail.response.types.dart";
import "../../../network/api_service.dart";

final Provider<MenuRepository> menuRepositoryProvider =
    Provider<MenuRepository>((ProviderRef<MenuRepository> ref) {
  final ApiService apiService = ref.read(apiServiceProvider);
  return MenuRepository(apiService);
});

class MenuRepository {
  final ApiService apiService;

  MenuRepository(this.apiService);

  Future<BaseResponse<List<MenuByCampusResponse>>> getMenuByCampus({
    required String campusId,
  }) async {
    final String endpoint = "${MenuEndpoints.menu}/$campusId";

    final Response response = await apiService.getRequest(
      endpoint,
    );
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<List<MenuByCampusResponse>>.fromJson(responseData,
        (Object? json) {
      return List<MenuByCampusResponse>.from(
        (json as List).map(
            (e) => MenuByCampusResponse.fromJson(e as Map<String, dynamic>)),
      );
    });
  }

  Future<BaseResponse<MenuDetailResponse>> getMenuDetail({
    required String menuId,
  }) async {
    final String endpoint =
        "${MenuEndpoints.menu}${MenuEndpoints.detail}/$menuId";

    final Response response = await apiService.getRequest(
      endpoint,
    );
    final Map<String, dynamic> responseData = response.data;

    return BaseResponse<MenuDetailResponse>.fromJson(responseData,
        (Object? json) {
      return MenuDetailResponse.fromJson(json as Map<String, dynamic>);
    });
  }
}
