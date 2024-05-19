import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";

import "../../../providers/image_provider.dart";
import "restaurant_dialog.types.dart";
import "../../global/image_display/image_display.dart";
import "restaurant_info.provider.dart";

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
    final AsyncValue<RestaurantInfoData> dialogData =
        ref.watch(restaurantInfoProvider(idDialogProvider));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).colorScheme.secondary,
        child: SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 16),
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
              const SizedBox(height: 8),
              ImageDisplay(config: ImageConfig(imageUrl: imageUrl)),
              dialogData.when(
                data: (RestaurantInfoData data) =>
                    RestaurantInfoContent(data: data),
                loading: () => const CircularProgressIndicator(),
                error: (Object error, StackTrace stack) =>
                    Text("Error: $error"),
              ),
              const SizedBox(height: 16),
            ],
          ),
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
    const String labelNameKey = "Category.infoDialog.name";
    const String labelAvailableKey = "Category.infoDialog.available";
    const String labelClosedKey = "Category.infoDialog.closed";
    const String labelAddressKey = "Category.infoDialog.address";
    const String labelServiceTypeKey = "Category.infoDialog.serviceType";
    const String labelFacebookKey = "Category.infoDialog.facebook";
    const String labelInstagramKey = "Category.infoDialog.instagram";
    const String labelTwitterKey = "Category.infoDialog.twitter";
    const String labelYouTubeKey = "Category.infoDialog.youtube";
    const String labelWhatsAppKey = "Category.infoDialog.whatapp";
    const String labelPhoneKey = "Category.infoDialog.phone";
    const String labelEmailKey = "Category.infoDialog.email";
    const String labelYesKey = "Category.infoDialog.yes";
    const String labelNoKey = "Category.infoDialog.no";
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(labelNameKey.tr(),
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(data.name),
            ),
            ListTile(
              title: Text(labelAvailableKey.tr(),
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle:
                  Text(data.isAvailable ? labelYesKey.tr() : labelNoKey.tr()),
            ),
            ListTile(
              title: Text(labelClosedKey.tr(),
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle:
                  Text(data.isClosed ? labelYesKey.tr() : labelNoKey.tr()),
            ),
            ListTile(
              title: Text(labelAddressKey.tr(),
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(
                  "${data.address.street}, ${data.address.city}, ${data.address.zipCode}, ${data.address.country}"),
            ),
            ListTile(
              title: Text(labelServiceTypeKey.tr(),
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(data.serviceType.services.join(", ")),
            ),
            if (data.socialMedia.facebook != null)
              ListTile(
                title: Text(labelFacebookKey.tr(),
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(data.socialMedia.facebook!),
              ),
            if (data.socialMedia.instagram != null)
              ListTile(
                title: Text(labelInstagramKey.tr(),
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(data.socialMedia.instagram!),
              ),
            if (data.socialMedia.twitter != null)
              ListTile(
                title: Text(labelTwitterKey.tr(),
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(data.socialMedia.twitter!),
              ),
            if (data.socialMedia.youtube != null)
              ListTile(
                title: Text(labelYouTubeKey.tr(),
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(data.socialMedia.youtube!),
              ),
            if (data.socialMedia.whatsapp != null)
              ListTile(
                title: Text(labelWhatsAppKey.tr(),
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(data.socialMedia.whatsapp!),
              ),
            ListTile(
              title: Text(labelPhoneKey.tr(),
                  style: Theme.of(context).textTheme.titleMedium),
              subtitle: Text(data.contact.phone),
            ),
            if (data.contact.email != null)
              ListTile(
                title: Text(labelEmailKey.tr(),
                    style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text(data.contact.email!),
              ),
          ],
        ),
      ),
    );
  }
}
