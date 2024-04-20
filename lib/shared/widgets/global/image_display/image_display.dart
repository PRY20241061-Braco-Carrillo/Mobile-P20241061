import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "../../../providers/image_provider.dart";

class ImageDisplay extends ConsumerWidget {
  final ImageConfig config;
  final double width;
  final double height;
  final BoxFit fit;

  const ImageDisplay({
    super.key,
    required this.config,
    this.width = 100.0,
    this.height = 100.0,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ImageProvider<Object>> imageProvider = ref.watch(imageProviderCache(config));

    return imageProvider.when(
      data: (ImageProvider<Object> img) => Image(
        image: img,
        width: width,
        height: height,
        fit: fit,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, StackTrace stackTrace) {
        debugPrint("Error loading image: $error, stackTrace: $stackTrace");
        return const Icon(Icons.error);
      },
    );
  }
}
