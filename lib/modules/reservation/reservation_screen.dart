import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../core/managers/secure_storage_manager.dart';
import '../../core/notifiers/reservation/get_reservation_by_user.notifier.dart';
import '../../layout/main_layout.dart';
import '../../shared/widgets/global/header/icon_header.dart';

final FutureProvider<Map<String, dynamic>> authDataProvider =
    FutureProvider<Map<String, dynamic>>(
        (FutureProviderRef<Map<String, dynamic>> ref) async {
  return ref.read(secureStorageProvider).getLoginData();
});

class ReservationsScreen extends ConsumerStatefulWidget {
  const ReservationsScreen({super.key});

  @override
  ReservationsScreenState createState() => ReservationsScreenState();
}

class ReservationsScreenState extends ConsumerState<ReservationsScreen> {
  @override
  Widget build(BuildContext context) {
    final PersistentTabController controller = PersistentTabController();

    final AsyncValue<Map<String, dynamic>> authData =
        ref.watch(authDataProvider);

    return MainLayout(
      body: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: <Widget>[
                CBaseIconHeader(
                  headerKey: "reservations",
                  height: 220,
                  returnButton: false,
                ),
                const SizedBox(height: 5.0),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Center(
                      child: authData.when(
                        data: (data) {
                          final userId = data[SecureStorageManager.keyUserId] ??
                              'No userId found';
                          if (userId == 'No userId found') {
                            return Text("No user ID found");
                          } else {
                            return ReservationList(userId: userId);
                          }
                        },
                        loading: () => CircularProgressIndicator(),
                        error: (error, stack) => Text('Error: $error'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReservationList extends ConsumerWidget {
  final String userId;

  const ReservationList({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationState =
        ref.watch(getReservationByUserNotifierProvider(userId));

    return reservationState.when(
      data: (response) {
        final reservations = response.data;
        if (reservations.isEmpty) {
          return Center(child: Text("No reservations found"));
        } else {
          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              return Card(
                child: ListTile(
                  title: Text('Reservation ID: ${reservation.reservationId}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: ${reservation.reservationStatus}'),
                      Text(
                          'Date: ${reservation.reservationDate?.toIso8601String() ?? 'N/A'}'),
                      Text('Message: ${reservation.message ?? 'No message'}'),
                      Text(
                          'Qualification: ${reservation.userQualification ?? 'No qualification'}'),
                      Text(
                          'Order Request ID: ${reservation.orderRequestId ?? 'No order request ID'}'),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
