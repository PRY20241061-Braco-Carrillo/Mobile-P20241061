import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "../../../../mock/menu/mock_menu_dialog_info/mock_menu_dialog_info.dart";
import "../../../providers/image_provider.dart";
import "restaurant_dialog.types.dart";
import "../../global/image_display/image_display.dart";

class RestaurantInfoDialog extends ConsumerWidget {
  final String idDialogProvider;
  final String imageUrl;
  final String title;

  const RestaurantInfoDialog({
    super.key,
    required this.idDialogProvider,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<RestaurantInfoData> dialogData = ref.watch(restaurantInfoProvider(idDialogProvider));

    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 16),
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 18)),
            const SizedBox(height: 8),
            ImageDisplay(
                config: ImageConfig(imageUrl: imageUrl)),
            dialogData.when(
                data: (RestaurantInfoData data) => RestaurantInfoContent(data: data),
                loading: () => const CircularProgressIndicator(),
                error: (Object error, StackTrace stack) => Text("Error: $error")),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class RestaurantInfoContent extends StatelessWidget {
  final RestaurantInfoData data;

  const RestaurantInfoContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("ID: ${data.id}"),
        Text("Nombre: ${data.name}"),
        Text('Disponible: ${data.isAvailable ? "Sí" : "No"}'),
        Text('Cerrado: ${data.isClosed ? "Sí" : "No"}'),
        Text(
            "Dirección: ${data.address.street}, ${data.address.city}, ${data.address.zipCode}, ${data.address.country}"),
        Text('Tipo de servicio: ${data.serviceType.services.join(", ")}'),
        if (data.socialMedia.facebook != null)
          Text("Facebook: ${data.socialMedia.facebook}"),
        if (data.socialMedia.instagram != null)
          Text("Instagram: ${data.socialMedia.instagram}"),
        if (data.socialMedia.twitter != null)
          Text("Twitter: ${data.socialMedia.twitter}"),
        if (data.socialMedia.youtube != null)
          Text("YouTube: ${data.socialMedia.youtube}"),
        if (data.socialMedia.whatsapp != null)
          Text("WhatsApp: ${data.socialMedia.whatsapp}"),
        Text("Contacto - Teléfono: ${data.contact.phone}"),
        if (data.contact.email != null) Text("Email: ${data.contact.email}"),
      ],
    );
  }
}
