import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

import '../../core/managers/secure_storage_manager.dart';
import '../../layout/main_layout.dart';
import '../../shared/widgets/global/header/icon_header.dart';
import '../../config/routes/routes.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainLayout(
      body: Stack(
        children: <Widget>[
          Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: <Widget>[
                CBaseIconHeader(
                  headerKey: "settings",
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await ref
                                    .read(secureStorageProvider)
                                    .clearStorage();
                                GoRouter.of(context)
                                    .go(AppRoutes.accessOptions);
                              },
                              icon: const Icon(Icons.logout),
                              label: const Text('Cerrar sesión'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                const url =
                                    'https://forms.gle/dBUoxNjPn8JmRTpe8';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'No se pudo abrir el enlace $url')),
                                  );
                                }
                              },
                              icon: const Icon(Icons.link),
                              label: const Text('Encuesta de satisfacción'),
                            ),
                          ),
                        ),
                      ],
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
