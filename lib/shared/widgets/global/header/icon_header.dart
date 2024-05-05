import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";

import "../../../../core/managers/header_data_manager.dart";
import "header.types.dart";

class CBaseIconHeader extends StatelessWidget {
  final String headerKey;
  final double? height;
  final void Function(BuildContext)? onButtonPressed;
  final bool? returnButton;

  const CBaseIconHeader(
      {super.key,
      required this.headerKey,
      this.height,
      this.onButtonPressed,
      this.returnButton = true});

  @override
  Widget build(BuildContext context) {
    final HeaderIconData? headerData =
        HeaderDataManager().getHeader(headerKey) as HeaderIconData?;

    return _buildCardContent(context, headerData);
  }

  Widget _buildCardContent(BuildContext context, HeaderIconData? data) {
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
                      left: 20, top: 40, bottom: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        data?.title.tr() ?? "",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                              fontSize: 28,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
              data?.icon == null
                  ? const SizedBox(height: 10)
                  : Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.only(top: 20, right: 20),
                        child: data?.isAsset == true
                            ? SvgPicture.asset(
                                data?.icon ?? "",
                                width: 100,
                                height: 100,
                              )
                            : SvgPicture.network(
                                data?.icon ?? "",
                                width: 100,
                                height: 100,
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                  BlendMode.srcIn,
                                ),
                              ),
                      ),
                    ),
            ],
          ),
          returnButton == true
              ? Positioned(
                  top: padding.top,
                  left: padding.left,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_circle_left_rounded),
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    iconSize: 35,
                    onPressed: () => onButtonPressed?.call(context),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
