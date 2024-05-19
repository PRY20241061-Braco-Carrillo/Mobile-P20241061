import "package:flutter/material.dart";

class ImageConfig {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final Map<String, String>? headers;
  final int? maxWidth;
  final int? maxHeight;
  final String errorAssetPath;
  final double onErrorWidth;
  final double onErrorHeight;
  final BoxFit onErrorFit;
  final EdgeInsets? padding;
  final EdgeInsets? onErrorPadding;

  ImageConfig({
    required this.imageUrl,
    this.width = 100.0,
    this.height = 100.0,
    this.fit = BoxFit.cover,
    this.headers,
    this.maxWidth,
    this.maxHeight,
    this.errorAssetPath = "assets/images/not_found/picture_not_found.svg",
    this.onErrorWidth = 100.0,
    this.onErrorHeight = 100.0,
    this.onErrorFit = BoxFit.cover,
    this.padding,
    this.onErrorPadding,
  });
}
