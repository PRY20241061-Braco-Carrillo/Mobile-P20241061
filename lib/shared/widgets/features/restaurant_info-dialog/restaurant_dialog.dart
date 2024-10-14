import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:easy_localization/easy_localization.dart";

import "../../../../core/models/base_response.dart";
import "../../../../core/notifiers/management/campus/restaurant_info.provider.dart";
import "../../../providers/image_provider.dart";
import "../../global/image_display/image_display.dart";
import "restaurant.types.dart";

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
    final AsyncValue<BaseResponse<CampusResponse>> dialogData =
        ref.watch(restaurantDetailNotifierProvider(idDialogProvider));

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          controller: ModalScrollController.of(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              // Imagen destacada del restaurante
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ImageDisplay(config: ImageConfig(imageUrl: imageUrl)),
              ),
              const SizedBox(height: 16),
              dialogData.when(
                data: (BaseResponse<CampusResponse> response) =>
                    RestaurantInfoContent(data: response.data),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (Object error, StackTrace stack) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("Error: $error"),
                ),
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
  final CampusResponse data;

  const RestaurantInfoContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    const String labelAvailableKey = "RestaurantInfoDialog.available";
    const String labelTakeHomeKey = "RestaurantInfoDialog.takeHome";
    const String labelDeliveryKey = "RestaurantInfoDialog.delivery";
    const String labelOpenHoursKey = "RestaurantInfoDialog.openHours";
    const String labelBreakfastKey = "RestaurantInfoDialog.breakfast";
    const String labelLunchKey = "RestaurantInfoDialog.lunch";
    const String labelDinnerKey = "RestaurantInfoDialog.dinner";
    const String labelPhoneKey = "RestaurantInfoDialog.phone";
    const String labelAddressKey = "RestaurantInfoDialog.address";

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(
              data.name,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Text(
              data.isAvailable
                  ? labelAvailableKey.tr()
                  : "${labelAvailableKey.tr()} (Cerrado)",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: data.isAvailable ? Colors.green : Colors.red,
                  ),
            ),
          ),
          const Divider(),
          // Dirección del restaurante
          ListTile(
            title: Text(labelAddressKey.tr(),
                style: Theme.of(context).textTheme.displaySmall),
            subtitle: Text(
              data.address,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const Divider(),
          // Horarios de apertura
          // ListTile(
          //   title: Text(labelOpenHoursKey.tr(),
          //       style: Theme.of(context).textTheme.subtitle1),
          //   subtitle: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: <Widget>[
          //       _buildMealTimeRow(context, labelBreakfastKey.tr(),
          //           data.openHour["breakfast"] as MealTime?),
          //       _buildMealTimeRow(context, labelLunchKey.tr(),
          //           data.openHour["lunch"] as MealTime?),
          //       if (data.openHour["dinner"] != null)
          //         _buildMealTimeRow(context, labelDinnerKey.tr(),
          //             data.openHour["dinner"] as MealTime?),
          //     ],
          //   ),
          // ),
          // const Divider(),
          // Servicios de "para llevar" y "a domicilio"
          ListTile(
            title: Text(labelTakeHomeKey.tr(),
                style: Theme.of(context).textTheme.labelMedium),
            trailing: Icon(
              data.toTakeHome ? Icons.check_circle : Icons.cancel,
              color: data.toTakeHome ? Colors.green : Colors.red,
            ),
          ),
          ListTile(
            title: Text(labelDeliveryKey.tr(),
                style: Theme.of(context).textTheme.labelMedium),
            trailing: Icon(
              data.toDelivery ? Icons.check_circle : Icons.cancel,
              color: data.toDelivery ? Colors.green : Colors.red,
            ),
          ),
          const Divider(),
          // Información de contacto
          ListTile(
            title: Text(labelPhoneKey.tr(),
                style: Theme.of(context).textTheme.labelMedium),
            subtitle: Text(
              data.phoneNumber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTimeRow(
      BuildContext context, String label, MealTime? mealTime) {
    if (mealTime == null) return Container();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            "${mealTime.opening} - ${mealTime.closing}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
