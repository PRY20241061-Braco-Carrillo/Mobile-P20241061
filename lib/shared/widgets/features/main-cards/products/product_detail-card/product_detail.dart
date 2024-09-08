import "package:flutter/material.dart";
import "package:skeletonizer/skeletonizer.dart";

import "../../../../../../modules/product/products_list/category_navigation_data.types.dart";
import "../../../../../providers/image_provider.dart";
import "../../../../../utils/constants/currency_types.dart";
import "../../../../global/image_display/image_display.dart";
import "../product_base-card/product_base.types.dart";

class CProductDetailCard extends StatelessWidget {
  final CategoryNavigationData? categoryNavigationData;
  final ProductBaseCardData? productBaseCardData;

  final bool showSkeleton;
  final String? error;

  const CProductDetailCard(
      {super.key, this.categoryNavigationData, this.productBaseCardData})
      : showSkeleton = false,
        error = null;

  const CProductDetailCard.skeleton({super.key})
      : error = null,
        showSkeleton = true,
        categoryNavigationData = null,
        productBaseCardData = null;

  const CProductDetailCard.error({super.key, required this.error})
      : showSkeleton = false,
        categoryNavigationData = null,
        productBaseCardData = null;

  @override
  Widget build(BuildContext context) {
    if (showSkeleton) {
      return _buildSkeleton();
    } else if (error != null) {
      return _buildErrorContent(error!);
    } else {
      return _buildCardContent(context, productBaseCardData!);
    }
  }

  Widget _buildCardContent(BuildContext context, ProductBaseCardData data) {
    final double width = MediaQuery.of(context).size.width - 20;

    return InkWell(
      onTap: () {
        // Acciones al tocar la tarjeta
      },
      borderRadius: BorderRadius.circular(10),
      splashColor: Colors.blue.withOpacity(0.3), // Efecto de splash
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Imagen con animación
            Container(
              width: width,
              height: 250,
              margin: const EdgeInsets.only(bottom: 8),
              child: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Hero(
                      // Transición de Hero animada
                      tag: data.urlImage,
                      child: ImageDisplay(
                          config: ImageConfig(
                              imageUrl: data.urlImage,
                              width: width,
                              height: 300,
                              fit: BoxFit.fill)),
                    ),
                  ),
                  // Badge de oferta o variantes
                  if (data.hasVariant != null && data.hasVariant!)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'New Variant',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Título del producto
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                data.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

            const SizedBox(height: 10),
            // Sección de calificación y precio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Precio del producto
                  Text(
                    getCurrencySymbol(data.currencyPrice) +
                        data.amountPrice.toString(),
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
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
