import 'package:flutter/material.dart';
import 'package:mini_project_pwa/app_router.dart';
import 'package:mini_project_pwa/config/theme/theme_data.dart';
import 'package:mini_project_pwa/config/theme/theme_provider.dart';
import 'package:mini_project_pwa/core/services/localization/l10n/app_localizations.dart';
import 'package:mini_project_pwa/core/utils/extensions/build_context_extensions.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp.router(
      title: 'Flutter Commerce',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget? child) {
        final mediaQuery = MediaQuery.of(context);

        // Combine system text scale with our device-aware responsive scale
        // and clamp it to avoid excessively large or tiny text.
        //
        // This makes fonts adapt differently on phones, tablets, and
        // desktop/laptop layouts while still respecting user settings.
        final double responsiveScale = context.deviceTextScale;
        final clampedTextScale = (mediaQuery.textScaleFactor * responsiveScale)
            .clamp(0.85, 1.3)
            .toDouble();

        return MediaQuery(
          data: mediaQuery.copyWith(textScaleFactor: clampedTextScale),
          child: child ?? const SizedBox.shrink(),
        );
      },

      // support for localization below, first being the fallback locale
      supportedLocales: const [Locale('en'), Locale('es')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: AppRouter.router,
    );
  }
}
