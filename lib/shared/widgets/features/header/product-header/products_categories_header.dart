import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "../../../../providers/image_provider.dart";
import "../../../global/image_display/image_display.dart";

class CBaseProductCategoriesHeader extends ConsumerWidget {
  final double? height;
  final void Function(BuildContext)? onButtonPressed;
  final String title;
  final bool withIcon;
  final String iconUrl;
  final double fontSize;

  const CBaseProductCategoriesHeader({
    super.key,
    required this.title,
    this.height,
    this.onButtonPressed,
    this.withIcon = false,
    this.iconUrl = "",
    this.fontSize = 24,
  });

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
                flex: withIcon ? 7 : 10,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 40, bottom: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              fontSize: fontSize,
                            ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        textAlign: TextAlign.start,
                      )
                    ],
                  ),
                ),
              ),
              withIcon == false
                  ? const SizedBox(height: 10)
                  : Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.only(top: 20, right: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: ImageDisplay(
                            config: ImageConfig(imageUrl: iconUrl),
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
