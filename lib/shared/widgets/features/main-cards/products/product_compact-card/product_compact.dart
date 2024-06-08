import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:skeletonizer/skeletonizer.dart";

import "../../../../../../config/routes/routes.dart";
import "../../../../../../modules/product/product_detail/product_detail_navigation_data.types.dart";
import "../../../../../../modules/product/products_list/category_navigation_data.types.dart";
import "../../../../../utils/constants/currency_types.dart";
import "../../../campus-card/campus_card.types.dart";
import "../../labels/size_labels.dart";
import "../product_base-card/product_base.types.dart";

class CProductCompactCard extends StatelessWidget {
  final ProductBaseCardData? data;
  final CategoryNavigationData? categoryNavigationData;
  final CampusCardData? campusCardData;

  final String type;
  final bool showSkeleton;
  final String? error;

  const CProductCompactCard({
    super.key,
    required this.data,
    this.campusCardData,
    required this.categoryNavigationData,
    this.type = ProductBaseTypes.product,
  })  : showSkeleton = false,
        error = null;

  const CProductCompactCard.skeleton({super.key})
      : data = null,
        error = null,
        type = ProductBaseTypes.product,
        showSkeleton = true,
        categoryNavigationData = null,
        campusCardData = null;

  const CProductCompactCard.error({super.key, required this.error})
      : data = null,
        showSkeleton = false,
        type = ProductBaseTypes.product,
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

  Widget _buildCardContent(BuildContext context, ProductBaseCardData data) {
    const String labelSincePriceKey = "MenuCard.sincePrice.label";

    return InkWell(
      onTap: () {
        if (type == ProductBaseTypes.product) {
          GoRouter.of(context).push(
              "${AppRoutes.products}/${categoryNavigationData?.categoryData.campusCategoryId}/${data.productId}",
              extra: ProductDetailNavigationData(
                  categoryData: categoryNavigationData!.categoryData,
                  campusData: categoryNavigationData!.campusData,
                  productData: data));
        }
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
                  if (data.hasVariant != null && data.hasVariant!) ...<Widget>[
                    const SizedBox(height: 4),
                    const SizeLabel(fontSize: 12),
                  ],
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                data.hasVariant != null && data.hasVariant!
                    ? "${labelSincePriceKey.tr()} ${getCurrencySymbol(data.currencyPrice)}${data.amountPrice}"
                    : getCurrencySymbol(data.currencyPrice) +
                        data.amountPrice.toString(),
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
