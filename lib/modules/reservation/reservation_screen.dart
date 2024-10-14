import "package:easy_localization/easy_localization.dart";
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
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.only(
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
            return Center(child: Text('reservations.no_reservations'.tr()));
          } else {
            return ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final reservation = reservations[index];
                final reservationStatusColor =
                    _getStatusColor(reservation.reservationStatus);
                final statusIcon =
                    _getStatusIcon(reservation.reservationStatus);
                final qualificationColor =
                    _getQualificationColor(reservation.userQualification);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showFullReservationIdDialog(context,
                                    reservation.reservationId ?? 'N/A');
                              },
                              child: Text(
                                'reservations.id'.tr() +
                                    ": ${_getShortenedId(reservation.reservationId)}",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                            Icon(statusIcon, color: reservationStatusColor),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'reservations.status'.tr() +
                              ": " +
                              reservation.reservationStatus!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: reservationStatusColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'reservations.date'.tr() +
                              ": ${reservation.reservationDate?.toIso8601String() ?? 'N/A'}",
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'reservations.message'.tr() +
                              ": ${reservation.message ?? 'N/A'}",
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'reservations.qualification'.tr() + ": ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Chip(
                              label:
                                  Text(reservation.userQualification ?? 'N/A'),
                              backgroundColor: qualificationColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'reservations.order_id'.tr() +
                              ": ${reservation.orderRequestId ?? 'N/A'}",
                        ),
                        const SizedBox(height: 15),
                        // Mostrar el botón de eliminar solo si el estado es POR_CONFIRMAR
                        if (reservation.reservationStatus == 'POR_CONFIRMAR')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                      context, ref, reservation.reservationId!);
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) =>
            Center(child: Text('reservations.load_error'.tr())),
      ),
    );
  }

  String _getShortenedId(String? id) {
    if (id == null || id.length <= 6) {
      return id ?? 'N/A';
    }
    return '...${id.substring(id.length - 6)}';
  }

  void _showFullReservationIdDialog(
      BuildContext context, String reservationId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('reservations.id'.tr()),
          content: Text(reservationId),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'POR_CONFIRMAR':
        return Colors.orange;
      case 'CONFIRMADO':
        return Colors.green;
      case 'DENEGADO':
        return Colors.redAccent;
      case 'EN_PREPARACION':
        return Colors.blue;
      case 'CANCELADO_ADMIN':
        return Colors.red;
      case 'CANCELADO_USUARIO':
        return Colors.red;
      case 'ENTREGADO':
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'POR_CONFIRMAR':
        return Icons.hourglass_empty;
      case 'CONFIRMADO':
        return Icons.check_circle;
      case 'DENEGADO':
        return Icons.cancel;
      case 'EN_PREPARACION':
        return Icons.local_dining;
      case 'CANCELADO_ADMIN':
      case 'CANCELADO_USUARIO':
        return Icons.cancel;
      case 'ENTREGADO':
        return Icons.check_circle_outline;
      default:
        return Icons.help_outline;
    }
  }

  Color _getQualificationColor(String? qualification) {
    switch (qualification) {
      case 'EXCELENTE':
        return Colors.greenAccent;
      case 'BUENO':
        return Colors.blueAccent;
      case 'REGULAR':
        return Colors.orangeAccent;
      case 'MALO':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, WidgetRef ref, String reservationId) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'reservations.confirm_deletion'.tr(),
      text: 'reservations.confirm_deletion_text'.tr(),
      confirmBtnText: 'reservations.yes'.tr(),
      cancelBtnText: 'reservations.no'.tr(),
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
              title: 'reservations.deletion_success'.tr(),
              text: 'reservations.deletion_success_text'.tr(),
            );
            ref.refresh(getReservationByUserNotifierProvider(userId));
          } else {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'reservations.deletion_error'.tr(),
              text: 'reservations.deletion_error_text'.tr(),
            );
          }
        },
        loading: () => const CircularProgressIndicator(),
        error: (error, stack) => QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'reservations.deletion_error'.tr(),
          text: 'reservations.deletion_error_text'.tr(),
        ),
      );
    });
  }
}
