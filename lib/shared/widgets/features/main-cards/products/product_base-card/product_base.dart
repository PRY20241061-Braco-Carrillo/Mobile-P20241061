import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:skeletonizer/skeletonizer.dart";

import "../../../../../../config/routes/routes.dart";
import "../../../../../../modules/product/product_detail/product_detail_navigation_data.types.dart";
import "../../../../../../modules/product/products_list/category_navigation_data.types.dart";
import "../../../../../providers/image_provider.dart";
import "../../../../../utils/constants/currency_types.dart";
import "../../../../global/image_display/image_display.dart";
import "../../../campus-card/campus_card.types.dart";
import "product_base.types.dart";

class CProductBaseCard extends StatelessWidget {
  final ProductBaseCardData? data;
  final CategoryNavigationData? categoryNavigationData;
  final CampusCardData? campusCardData;
  final String type;
  final bool showSkeleton;
  final String? error;

  const CProductBaseCard({
    super.key,
    required this.data,
    required this.categoryNavigationData,
    this.type = ProductBaseTypes.product,
    this.campusCardData,
  })  : showSkeleton = false,
        error = null;

  const CProductBaseCard.skeleton({super.key})
      : data = null,
        error = null,
        showSkeleton = true,
        type = ProductBaseTypes.product,
        categoryNavigationData = null,
        campusCardData = null;

  const CProductBaseCard.error({super.key, required this.error})
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
    final double width = MediaQuery.of(context).size.width / 2 - 20;

    return InkWell(
      onTap: () {
        if (type == ProductBaseTypes.product) {
          GoRouter.of(context).push(
            "${AppRoutes.products}/${categoryNavigationData?.categoryData.campusCategoryId}/${data.productId}",
            extra: ProductDetailNavigationData(
              categoryData: categoryNavigationData!.categoryData,
              campusData: categoryNavigationData!.campusData,
              productData: data,
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(10), // Para una interacción suave
      splashColor: Colors.blue.withOpacity(0.3), // Efecto de splash visual
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5), // Sombra sutil para darle realce
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Imagen del producto con borde redondeado
            Container(
              height: 150,
              width: width,
              margin: const EdgeInsets.only(bottom: 8),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: ImageDisplay(
                      config: ImageConfig(
                        imageUrl: data.urlImage,
                        height: 150,
                        width: width,
                        onErrorHeight: 50,
                        onErrorWidth: 50,
                        onErrorFit: BoxFit.contain,
                        onErrorPadding:
                            const EdgeInsets.only(bottom: 70, top: 30),
                      ),
                    ),
                  ),
                  if (data.hasVariant == true)
                    const Positioned(
                      top: 8,
                      left: 8,
                      child: Chip(
                        label: Text(
                          'Variant Available',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    ),
                ],
              ),
            ),
            // Precio del producto
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '${getCurrencySymbol(data.currencyPrice)}${data.amountPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Nombre del producto
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                data.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Tiempo de cocción del producto
            if (data.minCookingTime != null && data.maxCookingTime != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${data.minCookingTime}-${data.maxCookingTime} ${data.unitOfTimeCookingTime}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: 12,
                  ),
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
                    topRight: Radius.circular(10),
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
