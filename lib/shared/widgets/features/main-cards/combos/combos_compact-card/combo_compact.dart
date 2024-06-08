import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:skeletonizer/skeletonizer.dart";

import "../../../../../../config/routes/routes.dart";
import "../../../../../../modules/combos/combos_detail_navigations_data.types.dart";
import "../../../../../../modules/product/products_list/category_navigation_data.types.dart";
import "../../../campus-card/campus_card.types.dart";
import "../combos_base-card/combo_base.types.dart";

class CComboCompactCard extends StatelessWidget {
  final ComboByCampusCardData? data;
  final CategoryNavigationData? categoryNavigationData;
  final CampusCardData? campusCardData;

  final bool showSkeleton;
  final String? error;

  const CComboCompactCard({
    super.key,
    required this.data,
    this.campusCardData,
    required this.categoryNavigationData,
  })  : showSkeleton = false,
        error = null;

  const CComboCompactCard.skeleton({super.key})
      : data = null,
        error = null,
        showSkeleton = true,
        categoryNavigationData = null,
        campusCardData = null;

  const CComboCompactCard.error({super.key, required this.error})
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

  Widget _buildCardContent(BuildContext context, ComboByCampusCardData data) {
    return InkWell(
      onTap: () {
        GoRouter.of(context).push(
          "${AppRoutes.categories}${AppRoutes.combos}/${campusCardData?.campusId}/${data.comboId}",
          extra: ComboDetailNavigationData(
              campusData: campusCardData!, productData: data),
        );
      },
      child: Container(
        height: 120,
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildProductSummary(data.products),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                "${data.currencyPrice} ${data.amountPrice}",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductSummary(List<ProductByCampusCardData> products) {
    String productSummary =
        products.map((ProductByCampusCardData p) => p.name).join(", ");
    if (productSummary.length > 40) {
      productSummary = "${productSummary.substring(0, 40)}...";
    }

    return Text(
      productSummary,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: 12,
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
