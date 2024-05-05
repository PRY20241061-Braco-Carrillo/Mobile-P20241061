import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";

import "../../../../providers/image_provider.dart";
import "../../campus-card/campus_card.types.dart";
import "../../restaurant_info-dialog/restaurant_dialog.dart";
import "../../../global/image_display/image_display.dart";
import "../../../global/header/buttons/buttons_header.dart";

class CBaseRestaurantCategoriesHeader extends ConsumerWidget {
  final CampusCardData campusCardData;
  final double? height;
  final String idDialogProvider;
  final void Function(BuildContext)? onButtonPressed;

  const CBaseRestaurantCategoriesHeader(
      {super.key,
      required this.campusCardData,
      this.height,
      required this.idDialogProvider,
      this.onButtonPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildCardContent(context, ref);
  }

  Widget _buildCardContent(BuildContext context, WidgetRef ref) {
    final EdgeInsets padding = MediaQuery.of(context).padding;

    return Container(
      height: height,
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
                        campusCardData.name,
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
                                    imageUrl: campusCardData.logoUrl,
                                    title: campusCardData.name),
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
                      config: ImageConfig(imageUrl: campusCardData.imageUrl),
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
}
