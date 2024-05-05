/*import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:skeletonizer/skeletonizer.dart";
import "../../../utils/constants/currency_types.dart";
import "buttons/button_product_card.dart";
import "labels/discount_labels.dart";
import "product_card.types.dart";

class CMenuCardFull extends StatelessWidget {
  final MenuCardData? data;
  final bool showSkeleton;
  final String? error;

  const CMenuCardFull({super.key, required this.data})
      : showSkeleton = false,
        error = null;

  const CMenuCardFull.skeleton({super.key})
      : data = null,
        error = null,
        showSkeleton = true;

  const CMenuCardFull.error({super.key, required this.error})
      : data = null,
        showSkeleton = false;

  @override
  Widget build(BuildContext context) {
    if (showSkeleton) {
      return _buildSkeleton(context);
    } else if (error != null) {
      return _buildErrorContent(error!);
    } else {
      return _buildCardContent(context, data!);
    }
  }

  Widget _buildCardContent(BuildContext context, MenuCardData data) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        transformAlignment: Alignment.center,
        constraints: const BoxConstraints(
          minHeight: 400,
          minWidth: double.infinity,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Row(
            textBaseline: TextBaseline.alphabetic,
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(top: 10, left: 8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.access_time,
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                        size: 16),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        "${data.header.timeRange.min}-${data.header.timeRange.max} ${data.header.timeRange.scale}",
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(top: 10, right: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        "Diferentes tamaños",
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 8, top: 8),
              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: data.primaryImage.url,
                  fit: BoxFit.cover,
                  width: 300,
                  height: 200,
                  placeholder: (BuildContext context, String url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (BuildContext context, String url, Object error) => const Icon(Icons.error),
                ),
              )),
          if (data.primaryImage.discountLabel != null &&
              data.primaryImage.discountLabel!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(left: 6.0, right: 8.0),
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 3),
                itemCount: data.primaryImage.discountLabel?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return DiscountLabel(
                    discount: data.primaryImage.discountLabel![index],
                    fontSize: 16,
                  );
                },
              ),
            ),
          Container(
            padding: const EdgeInsets.only(bottom: 2, top: 8),
            margin: const EdgeInsets.only(left: 10.0, right: 8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              data.title.title,
              maxLines: 4,
              textAlign: TextAlign.start,
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w400,
                fontSize: 24,
                height: 1,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 2, top: 8),
            margin: const EdgeInsets.only(left: 10.0, right: 8.0),
            alignment: Alignment.centerLeft,
            child: Text(
              currencySymbol[data.header.price.currency]! +
                  data.header.price.price.toString(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 4),
            margin: const EdgeInsets.only(left: 8.0, right: 8.0),
            alignment: Alignment.center,
            child: Column(children: <Widget>[
              MenuCardFooterButton(
                  buttonType: MenuCardFooterButtonTypes.ar,
                  onPressed: () {},
                  fontSize: 18),
              MenuCardFooterButton(
                  buttonType: MenuCardFooterButtonTypes.add,
                  onPressed: () {},
                  fontSize: 18),
              MenuCardFooterButton(
                  buttonType: MenuCardFooterButtonTypes.promotionDetail,
                  onPressed: () {},
                  fontSize: 18)
            ]),
          )
        ]));
  }

  Widget _buildSkeleton(
    BuildContext context,
  ) {
    return Skeletonizer(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Skeleton.leaf(
                    child: Container(
                      width: 30,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Skeleton.leaf(
                    child: Container(
                      width: 30,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Skeleton.shade(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Skeleton.shade(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Align(
                  child: Container(
                    width: 90,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
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


/**
 * 
 *     final categoryCard = ref.watch(categoryCardByIdProvider('1'));

 * Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, left: 10, right: 10, bottom: 10),
                  child: categoryCard.when(
                    data: (data) => CMenuCardFull(data: data),
                    loading: () => const CMenuCardFull.skeleton(),
                    error: (error, _) =>
                        CMenuCardFull.error(error: error.toString()),
                  ),
                ),
 * 
 */*/