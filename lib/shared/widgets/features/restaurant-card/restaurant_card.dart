import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:go_router/go_router.dart";
import "package:skeletonizer/skeletonizer.dart";
import "../../../../config/routes/routes.dart";
import "restaurant_card.types.dart";

class CRestaurantCard extends StatelessWidget {
  final RestaurantCardData? data;
  final bool showSkeleton;
  final String? error;

  const CRestaurantCard({super.key, required this.data})
      : showSkeleton = false,
        error = null;

  const CRestaurantCard.skeleton({super.key})
      : data = null,
        error = null,
        showSkeleton = true;

  const CRestaurantCard.error({super.key, required this.error})
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

  Widget _buildCardContent(BuildContext context, RestaurantCardData data) {
    return InkWell(
      onTap: () {
        GoRouter.of(context).push("${AppRoutes.campus}/${data.restaurantId}");
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomLeft,
              children: <Widget>[
                _getImageWidget(data.imageUrl, 200, 100),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 10, left: 10, top: 3, bottom: 3),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: _getImageWidget(data.logoUrl, 50, 50),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      data.name,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 16),
                      overflow: TextOverflow.ellipsis,
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

  Widget _getImageWidget(String? url, double width, double height) {
    if (url == null) {
      return SvgPicture.asset("assets/images/not_found/picture_not_found.svg",
          height: height);
    } else if (url.endsWith(".svg")) {
      return SvgPicture.network(
        url,
        width: width,
        height: height,
        placeholderBuilder: (BuildContext context) =>
            const CircularProgressIndicator(),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (BuildContext context, String url) =>
            const CircularProgressIndicator(),
        errorWidget: (BuildContext context, String url, Object error) =>
            const Icon(Icons.error),
      );
    }
  }

  Widget _buildSkeleton(BuildContext context) {
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
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 100,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      right: 10, left: 10, top: 3, bottom: 3),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Skeleton.shade(
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
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 100,
                    height: 20,
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildErrorContent(Object error) {
    return Center(
      child: Text("Error: $error"),
    );
  }
}
