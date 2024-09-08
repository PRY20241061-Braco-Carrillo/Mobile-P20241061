import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:go_router/go_router.dart";

import "../campus-card/campus_card.types.dart";

class CategorySimpleButton extends StatelessWidget {
  final String title;
  final String? imageUrl;

  final String path;
  final CampusCardData? campusData;

  const CategorySimpleButton({
    super.key,
    required this.title,
    this.imageUrl,
    required this.path,
    this.campusData,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        GoRouter.of(context).push(
          path,
          extra: campusData,
        );
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
                  Expanded(
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: <Widget>[
                        _getImageWidget(imageUrl, double.infinity, 100),
                      ],
                    ),
                  ),
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
                      title,
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
            SvgPicture.asset(
          "assets/images/not_found/picture_not_found.svg",
          height: 20,
          allowDrawingOutsideViewBox: true,
          matchTextDirection: true,
          width: 20,
          clipBehavior: Clip.none,
        ),
      );
    }
  }
}
