// ignore_for_file: always_specify_types

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_project_pwa/app.dart';
import 'package:mini_project_pwa/config/environment_config.dart';
import 'package:mini_project_pwa/config/theme/theme_provider.dart';
import 'package:mini_project_pwa/core/di/injection_container.dart';
import 'package:mini_project_pwa/core/services/analytics/clever_tap_service.dart';
import 'package:mini_project_pwa/core/services/analytics/monegage_service.dart';
import 'package:mini_project_pwa/modules/auth/presentation/bloc/auth_bloc.dart';
import 'package:mini_project_pwa/modules/cart/presentation/bloc/cart_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvironmentConfig.initialize(environment: Environment.dev);

  // Initialize sentry if enabled in environment config
  // if (EnvironmentConfig.instance.enableCrashReporting) {
  //   await SentryFlutter.init(
  //     (options) {
  //       options.dsn = 'https://xxxxx@xxxxx.ingest.sentry.io/xxxxxx';
  //       options.environment = EnvironmentConfig.instance.isProduction
  //           ? 'production'
  //           : 'development';
  //       options.tracesSampleRate =
  //           EnvironmentConfig.instance.isProduction ? 1.0 : 0.1;
  //       options.attachStacktrace = true;
  //       options.recordHttpBreadcrumbs = true;
  //     },
  //   );
  // }

  if (EnvironmentConfig.instance.useFirebase) {
    await Firebase.initializeApp();
  }
  await initDependencies();
  await MoeService().init();
  await CleverTapService.init(accountId: 'XXXXXX'); // replace with actual clever tap acc id

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),

        /// Listen to the product cart changes globally
        BlocProvider(create: (_) => getIt<CartBloc>()),
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: MyApp(),
      ),
    ),
  );
}

Future<void> runSentryApp() async {
  if (EnvironmentConfig.instance.enableCrashReporting) {
    await SentryFlutter.init(
      (options) {
        options.dsn = 'https://xxxxx@xxxxx.ingest.sentry.io/xxxxxx';
      },
      appRunner: () => runApp(
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          child: const MyApp(),
        ),
      ),
    );
  }
}
