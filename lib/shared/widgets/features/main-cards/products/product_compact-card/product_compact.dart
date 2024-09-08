import "package:easy_localization/easy_localization.dart";
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
      borderRadius: BorderRadius.circular(10), // Efecto suave en las esquinas
      splashColor: Colors.blue.withOpacity(0.3), // Efecto de splash
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15), // Sombra suave
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            // Imagen del producto a la izquierda
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ImageDisplay(
                config: ImageConfig(
                  imageUrl: data.urlImage,
                  height: 70,
                  width: 70,
                  onErrorHeight: 50,
                  onErrorWidth: 50,
                  onErrorFit: BoxFit.contain,
                  onErrorPadding: const EdgeInsets.only(bottom: 20, top: 10),
                ),
              ),
            ),
            const SizedBox(width: 12), // Espaciado entre la imagen y el texto

            // Información del producto
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Nombre del producto
                  Text(
                    data.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Mostrar si el producto tiene variantes
                  if (data.hasVariant != null && data.hasVariant!)
                    Row(
                      children: const <Widget>[
                        Icon(
                          Icons.shopping_bag,
                          size: 14,
                          color: Colors.redAccent,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Variants available',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Mostrar precio a la derecha
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    data.hasVariant != null && data.hasVariant!
                        ? "${labelSincePriceKey.tr()} ${getCurrencySymbol(data.currencyPrice)}${data.amountPrice.toStringAsFixed(2)}"
                        : getCurrencySymbol(data.currencyPrice) +
                            data.amountPrice.toStringAsFixed(2),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.right,
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
