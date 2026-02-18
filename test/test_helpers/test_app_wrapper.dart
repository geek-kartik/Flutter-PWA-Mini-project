import 'package:flutter/material.dart';
import 'package:mini_project_pwa/config/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:mini_project_pwa/app.dart'; // or MyApp import

class TestAppWrapper extends StatelessWidget {
  final Widget? home;

  const TestAppWrapper({super.key, this.home});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeProvider(), child: home ?? const MyApp());
  }
}
