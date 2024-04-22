import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:skeletonizer/skeletonizer.dart";
import "../../../providers/image_provider.dart";
import "../../features/restaurant_info-dialog/restaurant_dialog.dart";
import "buttons/buttons_header.dart";
import "header.types.dart";
import "../image_display/image_display.dart";

class CBaseFullHeader extends ConsumerWidget {
  final HeaderFullData? data;
  final bool showSkeleton;
  final String? error;
  final String idDialogProvider;
  final void Function(BuildContext)? onButtonPressed;

  const CBaseFullHeader(
      {super.key,
      required this.data,
      required this.idDialogProvider,
      this.onButtonPressed})
      : showSkeleton = false,
        error = null;

  const CBaseFullHeader.skeleton({super.key})
      : data = null,
        error = null,
        showSkeleton = true,
        idDialogProvider = "",
        onButtonPressed = null;

  const CBaseFullHeader.error({super.key, required this.error})
      : data = null,
        showSkeleton = false,
        idDialogProvider = "",
        onButtonPressed = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (showSkeleton) {
      return _buildSkeleton(context);
    } else if (error != null) {
      return _buildErrorContent(error!);
    } else {
      return _buildCardContent(context, ref, data!);
    }
  }

  Widget _buildCardContent(
      BuildContext context, WidgetRef ref, HeaderFullData data) {
    final EdgeInsets padding = MediaQuery.of(context).padding;

    return Container(
      height: 270,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      padding: const EdgeInsets.only(top: 20),
      child: Stack(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 80, bottom: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        data.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              fontSize: 24,
                            ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10),
                      MenuHeaderButton(
                        width: 120,
                        height: 45,
                        buttonType: HeaderButtonTypes.info,
                        onPressed: () {
                          showBarModalBottomSheet(
                            context: context,
                            expand: true,
                            builder: (BuildContext context) =>
                                RestaurantInfoDialog(
                                    idDialogProvider: idDialogProvider,
                                    imageUrl: data.logo,
                                    title: data.title),
                          );
                        },
                        fontSize: 18,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: ImageDisplay(
                      config: ImageConfig(imageUrl: data.logo),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: padding.top,
            left: padding.left,
            child: IconButton(
              icon: const Icon(Icons.arrow_circle_left_rounded),
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              iconSize: 35,
              onPressed: () => onButtonPressed?.call(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    return Skeletonizer(
      child: Container(
        height: 250,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: const EdgeInsets.only(top: 20),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, top: 60, bottom: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Skeleton.shade(
                          child: Container(
                            width: double.infinity,
                            height: 28,
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Skeleton.shade(
                          child: Container(
                            width: 120,
                            height: 45,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Skeleton.shade(
                child: Icon(Icons.arrow_circle_left_rounded,
                    size: 35, color: Colors.grey[300]),
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
