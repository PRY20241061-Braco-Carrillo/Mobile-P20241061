import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:skeletonizer/skeletonizer.dart";

import "../../../../../config/routes/routes.dart";
import "../../../../../modules/product/product_detail/product_detail_navigation_data.types.dart";
import "../../../../../modules/product/products_list/category_navigation_data.types.dart";
import "../../../../providers/image_provider.dart";
import "../../../../utils/constants/currency_types.dart";
import "../../../global/image_display/image_display.dart";
import "../labels/size_labels.dart";
import "product_base.types.dart";

class CProductBaseCard extends StatelessWidget {
  final ProductBaseCardData? data;
  final CategoryNavigationData? categoryNavigationData;

  final bool showSkeleton;
  final String? error;

  const CProductBaseCard(
      {super.key, required this.data, required this.categoryNavigationData})
      : showSkeleton = false,
        error = null;

  const CProductBaseCard.skeleton({super.key})
      : data = null,
        error = null,
        showSkeleton = true,
        categoryNavigationData = null;

  const CProductBaseCard.error({super.key, required this.error})
      : data = null,
        showSkeleton = false,
        categoryNavigationData = null;

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
    final double width = MediaQuery.of(context).size.width / 2 - 20;
    return InkWell(
      onTap: () {
        GoRouter.of(context).push(
            "${AppRoutes.products}/${categoryNavigationData?.categoryData.campusCategoryId}/${data.productId}",
            extra: ProductDetailNavigationData(
                categoryData: categoryNavigationData!.categoryData,
                campusData: categoryNavigationData!.campusData,
                productData: data));
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          padding: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(204, 230, 255, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 150, // Altura fija para la imagen
                  width: width,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        child: ImageDisplay(
                          config: ImageConfig(
                              imageUrl: data.urlImage,
                              height: 150,
                              width: width,
                              onErrorHeight: 50,
                              onErrorWidth: 50,
                              onErrorFit: BoxFit.contain,
                              onErrorPadding:
                                  const EdgeInsets.only(bottom: 70, top: 30)),
                        ),
                      ),
                      if (data.hasVariant == true)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizeLabel(fontSize: 12),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 2),
                  margin: const EdgeInsets.only(left: 10.0, right: 8.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    getCurrencySymbol(data.currencyPrice) +
                        data.amountPrice.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 2),
                  margin: const EdgeInsets.only(left: 10.0, right: 8.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    data.name,
                    maxLines: 4,
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1,
                    ),
                  ),
                ),
              ])),
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
        child: Column(
          children: <Widget>[
            Skeleton.shade(
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
              ),
            ),
            Skeleton.shade(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 8.0, bottom: 2),
                child: Container(
                  width: double.infinity,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Skeleton.shade(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 8.0, bottom: 2),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
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
