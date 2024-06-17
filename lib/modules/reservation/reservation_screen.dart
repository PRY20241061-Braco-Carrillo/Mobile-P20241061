import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:quickalert/quickalert.dart'; // Importa quickalert

import '../../core/managers/secure_storage_manager.dart';
import "../../core/models/reservation/update_reservation_status.request.types.dart";
import '../../core/notifiers/reservation/get_reservation_by_user.notifier.dart';
import '../../layout/main_layout.dart';
import '../../shared/widgets/global/header/icon_header.dart';
import '../../core/notifiers/reservation/update_reservation_status.notifier.dart';

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

    return RefreshIndicator(
      onRefresh: () => ref
          .refresh(getReservationByUserNotifierProvider(userId).notifier)
          .reloadData(),
      child: reservationState.when(
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
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(
                            context, ref, reservation.reservationId!);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
        loading: () => CircularProgressIndicator(),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, WidgetRef ref, String reservationId) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Confirm Deletion',
      text: 'Are you sure you want to delete this reservation?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.green,
      onConfirmBtnTap: () {
        Navigator.of(context, rootNavigator: true).pop();
        _deleteReservation(context, ref, reservationId);
      },
      onCancelBtnTap: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
  }

  void _deleteReservation(
      BuildContext context, WidgetRef ref, String reservationId) {
    final notifier =
        ref.read(updateReservationNotifierProvider(UpdateReservation(
      reservationId: reservationId,
      status: "CANCELADO_USUARIO",
    )).notifier);

    notifier.updateReservationStatus().then((_) {
      notifier.state.when(
        data: (response) {
          if (response.code == "UPDATED") {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: 'Success',
              text: 'Reservation deleted successfully',
            );
            ref.refresh(getReservationByUserNotifierProvider(userId));
          } else {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Error',
              text: 'Failed to delete reservation',
            );
          }
        },
        loading: () => CircularProgressIndicator(),
        error: (error, stack) => QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Failed to delete reservation',
        ),
      );
    });
  }
}
