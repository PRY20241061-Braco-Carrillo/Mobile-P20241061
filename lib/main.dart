import "config/routes/app_router.dart";

import "config/theme/theme_manager.dart";
import "core/shared_preferences/services/shared_preferences.service.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:go_router/go_router.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

final Provider<FlutterSecureStorage> secureStorageProvider =
    Provider<FlutterSecureStorage>((ProviderRef<FlutterSecureStorage> ref) =>
        const FlutterSecureStorage());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SharedPreferencesService.instance.init();

  final bool onboardingComplete =
      SharedPreferencesService.instance.getOnboardingComplete();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const <Locale>[
          Locale("en", "US"),
          Locale("es", "ES")
        ],
        path: "assets/translations",
        fallbackLocale: const Locale("en", "US"),
        child: MyApp(onboardingComplete: onboardingComplete),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final bool onboardingComplete;

  const MyApp({super.key, required this.onboardingComplete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = ref.watch(themeProvider);
    final Future<GoRouter> futureRouter = AppRouter.createRouter();

    return FutureBuilder<GoRouter>(
      future: futureRouter,
      builder: (BuildContext context, AsyncSnapshot<GoRouter> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final GoRouter appRouter = snapshot.data!;
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
        return const CircularProgressIndicator();
      },
    );
  }
}

/*
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const App(), // Ahora MyApp apunta a App como su home.
    );
  }
}
*/





/*
class App extends StatefulWidget {
  const App({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<App> {
  // Lista de etiquetas, puedes agregar más aquí.
  // Cada etiqueta tiene una posición en la pantalla (left, top) y un texto.
  final List<Map<String, dynamic>> labels = [
    {
      "left": 150.0,
      "top": 200.0,
      "text": "Tomate",
    },
    {
      "left": 200.0,
      "top": 300.0,
      "text": "Lechuga",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Model Viewer con Etiquetas'),
        ),
        body: Stack(
          children: [
            const ModelViewer(
              backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
              src: 'assets/sas_blue.glb',
              alt: "Un modelo 3D de comida",
              ar: true,
              autoRotate: true,
              cameraControls: true,
            ),
            ...labels
                .map((label) => Positioned(
                      left: label["left"],
                      top: label["top"],
                      child: GestureDetector(
                        onTap: () {
                          // Aquí puedes agregar lo que sucede cuando tocas una etiqueta.
                          // Por ejemplo, mostrar un diálogo con más información.
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text(label["text"]),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.yellow,
                          child: Text(
                            label["text"],
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}

*/



/*
//Componente de realidad aumentada:
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: ModelViewer(src: 'assets/sas_blue.glb', ar: true));
  }
}
*/