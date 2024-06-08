import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:skeletonizer/skeletonizer.dart";

import "../../../../../../config/routes/routes.dart";

import "../../../../../../modules/product/menus/menu_detail_navigation_data.types.dart";
import "../../../../../../modules/product/products_list/category_navigation_data.types.dart";
import "../../../campus-card/campus_card.types.dart";
import "../menu_base-card/menu_base.types.dart";

class CMenuCompactCard extends StatelessWidget {
  final MenuBaseCardData? data;
  final CategoryNavigationData? categoryNavigationData;
  final CampusCardData? campusCardData;

  final bool showSkeleton;
  final String? error;

  const CMenuCompactCard({
    super.key,
    required this.data,
    this.campusCardData,
    required this.categoryNavigationData,
  })  : showSkeleton = false,
        error = null;

  const CMenuCompactCard.skeleton({super.key})
      : data = null,
        error = null,
        showSkeleton = true,
        categoryNavigationData = null,
        campusCardData = null;

  const CMenuCompactCard.error({super.key, required this.error})
      : data = null,
        showSkeleton = false,
        categoryNavigationData = null,
        campusCardData = null;

  @override
  Widget build(BuildContext context) {
    if (showSkeleton) {
      return _buildSkeleton();
    } else if (error != null) {
      return _buildErrorContent(error!);
    } else {
      return _buildCardContent(context, data!);
    }
  }

  Widget _buildCardContent(BuildContext context, MenuBaseCardData data) {
    return InkWell(
      onTap: () {
        GoRouter.of(context).push(
            "${AppRoutes.categories}${AppRoutes.menu}/${campusCardData?.campusId}/${data.menuId}",
            extra: MenuDetailNavigationData(
                campusData: campusCardData!, productData: data));
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(204, 230, 255, 1),
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Skeletonizer(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorContent(Object error) {
    return Center(
      child: Text("Error: $error"),
    );
  }
}
