/*import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:skeletonizer/skeletonizer.dart";
import "../../../utils/constants/currency_types.dart";
import "labels/discount_labels.dart";
import "labels/size_labels.dart";
import "product_card.types.dart";

class CMenuCardDiscount extends StatelessWidget {
  final MenuCardData? data;
  final bool showSkeleton;
  final String? error;

  const CMenuCardDiscount({super.key, required this.data})
      : showSkeleton = false,
        error = null;

  const CMenuCardDiscount.skeleton({super.key})
      : data = null,
        error = null,
        showSkeleton = true;

  const CMenuCardDiscount.error({super.key, required this.error})
      : data = null,
        showSkeleton = false;

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

  Widget _buildCardContent(BuildContext context, MenuCardData data) {
    return InkWell(
      onTap: () {},
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          padding: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(204, 230, 255, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: data.primaryImage.url,
                      fit: BoxFit.cover,
                      placeholder: (BuildContext context, String url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (BuildContext context, String url, Object error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                  if (data.primaryImage.sizeLabel != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizeLabel(
                          size: data.primaryImage.sizeLabel!.size,
                          fontSize: 12),
                    ),
                ],
              ),
            ),
            if (data.primaryImage.discountLabel != null &&
                data.primaryImage.discountLabel!.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(left: 6.0, right: 8.0),
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(bottom: 3),
                  itemCount: data.primaryImage.discountLabel?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return DiscountLabel(
                      discount: data.primaryImage.discountLabel![index],
                      fontSize: 12,
                    );
                  },
                ),
              ),
            Container(
              padding: const EdgeInsets.only(bottom: 2),
              margin: const EdgeInsets.only(left: 10.0, right: 8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                currencySymbol[data.header.price.currency]! +
                    data.header.price.price.toString(),
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
                data.title.title,
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
*/