import "package:flutter/material.dart";
import "package:skeletonizer/skeletonizer.dart";

import "../../../../../../modules/product/products_list/category_navigation_data.types.dart";
import "../../../../../utils/constants/promotions_keys.dart";
import "../../../campus-card/campus_card.types.dart";
import "../../labels/size_labels.dart";
import "../promotions_base-card/promotion_base.types.dart";

class CCPromotionCompactCard extends StatelessWidget {
  final PromotionByCampusCardData? data;
  final CategoryNavigationData? categoryNavigationData;
  final CampusCardData? campusCardData;

  final bool showSkeleton;
  final String? error;

  const CCPromotionCompactCard({
    super.key,
    required this.data,
    this.campusCardData,
    required this.categoryNavigationData,
  })  : showSkeleton = false,
        error = null;

  const CCPromotionCompactCard.skeleton({super.key})
      : data = null,
        error = null,
        showSkeleton = true,
        categoryNavigationData = null,
        campusCardData = null;

  const CCPromotionCompactCard.error({super.key, required this.error})
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

  Widget _buildCardContent(
      BuildContext context, PromotionByCampusCardData data) {
    return InkWell(
      onTap: () {
        // Acción al hacer clic en la tarjeta
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (data.hasVariant) ...<Widget>[
                    const SizedBox(height: 4),
                    const SizeLabel(fontSize: 12),
                  ],
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                data.discountType == PromotionKeys.percentage
                    ? "${data.discount}%"
                    : "S/. ${data.discount}",
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
