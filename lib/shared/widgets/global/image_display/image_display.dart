import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "../../../providers/image_provider.dart";

class ImageDisplay extends ConsumerWidget {
  final ImageConfig config;

  const ImageDisplay({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ImageProvider<Object>> imageProvider =
        ref.watch(imageProviderCache(config));

    return imageProvider.when(
      data: (ImageProvider<Object> img) => Image(
        image: img,
        width: config.width,
        height: config.height,
        fit: config.fit,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object error, StackTrace stackTrace) {
        debugPrint("Error loading image: $error, stackTrace: $stackTrace");
        return const Icon(Icons.error);
      },
    );
  }
}
