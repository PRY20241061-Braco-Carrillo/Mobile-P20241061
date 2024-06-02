import "package:flutter/material.dart";
import "package:skeletonizer/skeletonizer.dart";

import "../../../../../providers/image_provider.dart";
import "../../../../global/image_display/image_display.dart";
import "../combos_base-card/combo_base.types.dart";

class CComboDetailCard extends StatelessWidget {
  final ComboByCampusCardData? comboDetailCardData;

  final bool showSkeleton;
  final String? error;

  const CComboDetailCard({super.key, this.comboDetailCardData})
      : showSkeleton = false,
        error = null;

  const CComboDetailCard.skeleton({super.key})
      : showSkeleton = true,
        error = null,
        comboDetailCardData = null;

  const CComboDetailCard.error({super.key, required this.error})
      : showSkeleton = false,
        comboDetailCardData = null;

  @override
  Widget build(BuildContext context) {
    if (showSkeleton) {
      return _buildSkeleton();
    } else if (error != null) {
      return _buildErrorContent(error!);
    } else {
      return _buildCardContent(context, comboDetailCardData!);
    }
  }

  Widget _buildCardContent(BuildContext context, ComboByCampusCardData data) {
    final double width = MediaQuery.of(context).size.width - 20;
    return InkWell(
      onTap: () {
        // Action on tap
      },
      child: Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: width,
              height: 300,
              margin: const EdgeInsets.only(bottom: 8),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: ImageDisplay(
                  config: ImageConfig(
                    imageUrl: data.urlImage,
                    width: width,
                    height: 300,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 2),
              margin: const EdgeInsets.only(left: 10.0, right: 8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                "S/. ${data.amountPrice.toString()}",
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
                maxLines: 2,
                textAlign: TextAlign.start,
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildProductDetails(data.products),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetails(List<ProductByCampusCardData> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: products.map((ProductByCampusCardData product) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: <Widget>[
              Image.network(
                product.urlImage,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      product.description,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
