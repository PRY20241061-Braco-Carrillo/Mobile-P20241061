import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:skeletonizer/skeletonizer.dart";
import "header.types.dart";

class CBaseIconHeader extends StatelessWidget {
  final HeaderIconData? data;
  final double? height;
  final bool showSkeleton;
  final String? error;
  final void Function(BuildContext)? onButtonPressed;
  final bool? returnButton;

  const CBaseIconHeader(
      {super.key,
      required this.data,
      this.height,
      this.onButtonPressed,
      this.returnButton = true})
      : showSkeleton = false,
        error = null;

  const CBaseIconHeader.skeleton({super.key})
      : data = null,
        error = null,
        showSkeleton = true,
        height = 200,
        onButtonPressed = null,
        returnButton = false;

  const CBaseIconHeader.error({super.key, required this.error})
      : data = null,
        showSkeleton = false,
        height = 200,
        onButtonPressed = null,
        returnButton = false;

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

  Widget _buildCardContent(BuildContext context, HeaderIconData data) {
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
                        data.title,
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
              data.icon == null
                  ? const SizedBox(height: 10)
                  : Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.only(top: 20, right: 20),
                        child: data.isAsset == true
                            ? SvgPicture.asset(
                                data.icon ?? "",
                                width: 100,
                                height: 100,
                              )
                            : SvgPicture.network(
                                data.icon ?? "",
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

  Widget _buildSkeleton(BuildContext context) {
    return Skeletonizer(
      child: Container(
        height: 200,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        padding: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
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
                            width: 150,
                            height: 22,
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
                    padding: const EdgeInsets.only(top: 20, right: 20),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              child: IconButton(
                icon: Icon(Icons.arrow_circle_left_rounded,
                    size: 35, color: Colors.grey[300]),
                onPressed: null,
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
