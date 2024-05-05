import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:skeletonizer/skeletonizer.dart";

import "../../../../config/routes/routes.dart";
import "campus_card.types.dart";

class CCampusCard extends StatelessWidget {
  final CampusCardData? data;
  final bool showSkeleton;
  final String? error;

  const CCampusCard({super.key, required this.data})
      : showSkeleton = false,
        error = null;

  const CCampusCard.skeleton({super.key})
      : data = null,
        error = null,
        showSkeleton = true;

  const CCampusCard.error({super.key, required this.error})
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

  Widget _buildCardContent(BuildContext context, CampusCardData data) {
    return InkWell(
      onTap: () {
        context.go("${AppRoutes.categories}/${data.campusId}", extra: data);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
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
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
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
