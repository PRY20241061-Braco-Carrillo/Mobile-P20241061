import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

import "config/routes/app_router.dart";
import "config/theme/theme_manager.dart";
import "core/hive/hive.service.dart";
import "core/managers/header_data_manager.dart";
import "core/shared_preferences/services/shared_preferences.service.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SharedPreferencesService.instance.init();
  await HeaderDataManager().init();
  await HiveService.instance.init();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const <Locale>[
          Locale("en", "US"),
          Locale("es", "ES")
        ],
        path: "assets/translations",
        fallbackLocale: const Locale("en", "US"),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = ref.watch(themeProvider);
    final GoRouter appRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: theme,
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
      routeInformationProvider: appRouter.routeInformationProvider,
    );
  }
}
